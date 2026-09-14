module SOC (
    input             clk,     // system clock
    input             resetn,  // reset button
    output wire [0:0] LEDS,    // system LEDs
    input             RXD,     // UART receive
    output            TXD      // UART transmit
);

  //###########################
  //### INTERFAZ DE MEMORIA ###
  //###########################
  // mem_addr  [salida, 32 bits] : Dirección de byte para acceso a memoria.
  //                               Los bits [1:0] se ignoran en accesos alineados.
  // mem_rdata [entrada, 32 bits]: Dato leído de la memoria. Es válido cuando
  //                               mem_rstrb está activo y tras el tiempo de acceso.
  // mem_rstrb [salida, 1 bit]   : Habilitación de lectura (activo alto).
  // mem_wdata [salida, 32 bits] : Dato a escribir en memoria. Para SB/SH se
  //                               coloca en los bits según la dirección.
  // mem_wmask [salida, 4 bits]  : Máscara de escritura por byte (activo alto).
  //                               Bit i=1 habilita la escritura del byte i.
  // wr        [interno, 1 bit]  : Señal interna. Activa cuando hay escritura
  //                               (algún bit de mem_wmask está en alto).
  // rd        [interno, 1 bit]  : Señal interna. Activa cuando hay lectura
  //                                  (igual a mem_rstrb).
  wire [31:0] mem_addr;  // Memory address
  wire [31:0] mem_rdata;  // Memory read data
  wire [31:0] mem_wdata;  // Memory write data
  wire        mem_rstrb;  // Memory read strobe (habilitación de lectura)
  wire [ 3:0] mem_wmask;  // Memory write mask (byte enable)
  wire        wr = |mem_wmask;  // Write enable: activo si algún byte se escribe
  wire        rd = mem_rstrb;  // Read enable: alias de mem_rstrb

  //##########################
  //### DESCRIPCIÓN DE CPU ###
  //##########################
  FemtoRV32 CPU (
      .clk      (clk),        // Reloj del sistema
      .reset    (resetn),     // Reset activo bajo
      .mem_addr (mem_addr),   // Dirección de memoria (byte address)
      .mem_rdata(mem_rdata),  // Dato leído de memoria
      .mem_rstrb(mem_rstrb),  // Habilitación de lectura de memoria
      .mem_wdata(mem_wdata),  // Dato a escribir en memoria
      .mem_wmask(mem_wmask),  // Máscara de escritura por byte
      .mem_rbusy(1'b0),       // Memoria de lectura nunca ocupada (0)
      .mem_wbusy(1'b0)        // Memoria de escritura nunca ocupada (0)
  );

  //###################################
  //### DESCRIPCIÓN DE CHIP SELECT ###
  //###################################
  // El módulo chip_select decodifica mem_addr y genera un bus one-hot cs
  // (activo alto) que habilita un único periférico/memoria según el mapa:
  //   0x00400000 -> chip0
  //   0x00410000 -> chip1
  //   0x00420000 -> chip2
  //   0x00430000 -> chip3
  //   0x00440000 -> chip4
  //   0x00450000 -> chip5
  //   resto      -> RAM (default)
  wire [6:0] cs;  // Bus one-hot de selección de chip (activo alto)
  wire       cs_uart = cs[0];  // Chip select UART        @ 0x00400000
  wire       cs_chip1 = cs[1];  // Chip select chip1       @ 0x00410000
  wire       cs_mult = cs[2];  // Chip select multiplicador @ 0x00420000
  wire       cs_chip3 = cs[3];  // Chip select chip3       @ 0x00430000
  wire       cs_chip4 = cs[4];  // Chip select chip4       @ 0x00440000
  wire       cs_chip5 = cs[5];  // Chip select chip5       @ 0x00450000
  wire       cs_ram = cs[6];  // Chip select RAM         @ default
  chip_select u_chip_select (
      .mem_addr  (mem_addr),   // Dirección de memoria a decodificar
      .chip0_dout(uart_dout),  // Datos del chip0 (UART)     @ 0x00400000
      .chip1_dout(),           // Datos del chip1 (sin uso)  @ 0x00410000
      .chip2_dout(mult_dout),  // Datos del chip2 (mult)     @ 0x00420000
      .chip3_dout(),           // Datos del chip3 (sin uso)  @ 0x00430000
      .chip4_dout(),           // Datos del chip4 (sin uso)  @ 0x00440000
      .chip5_dout(),           // Datos del chip5 (sin uso)  @ 0x00450000
      .chip6_dout(RAM_rdata),  // Datos del chip6 (RAM)      @ default
      .cs        (cs),         // Bus one-hot de selección de chip
      .mem_rdata (mem_rdata)   // Dato leído seleccionado -> al núcleo
  );

  //##########################
  //### DESCRIPCIÓN DE RAM ###
  //##########################
  // Memoria RAM mapeada en el rango por defecto (cualquier dirección que no
  // caiga en un periférico). Solo responde cuando cs_ram está activo.
  //   - Lectura : habilitada con (cs_ram & rd)
  //   - Escritura: habilitada enmascarando mem_wmask con cs_ram
  wire [31:0] RAM_rdata;  // Dato leído de la RAM hacia el bus mem_rdata
  Memory u_ram (
      .clk      (clk),                     // Reloj del sistema
      .mem_addr (mem_addr),                // Dirección de byte para acceso
      .mem_rdata(RAM_rdata),               // Dato leído de la RAM
      .mem_rstrb(cs_ram & rd),             // Lectura solo si la RAM está seleccionada
      .mem_wdata(mem_wdata),               // Dato a escribir
      .mem_wmask({4{cs_ram}} & mem_wmask)  // Escritura solo si cs_ram está activo
  );

  //######################################
  //### DESCRIPCIÓN DE PERIFERICO UART ###
  //######################################
  // Periférico UART mapeado en 0x00400000 (cs_uart).
  //   - Configuración: 25 MHz de reloj, 57600 baudios.
  //   - Registro de escritura (TX): escribe mem_wdata cuando (cs_uart & wr).
  //   - Registro de lectura  (RX): devuelve uart_dout cuando (cs_uart & rd).
  //   - Reset activo alto en el periférico (!resetn).
  wire [31:0] uart_dout;  // [31:0] Dato leído del UART hacia mem_rdata
  peripheral_uart #(
      .CLK_FREQ(25000000),  // Frecuencia de reloj en Hz (25 MHz)
      .BAUD    (57600)      // Velocidad en baudios (57600)
  ) u_uart (
      .clk    (clk),        // Reloj del sistema (25 MHz)
      .rst    (!resetn),    // Reset activo alto (invertido desde resetn)
      .d_in   (mem_wdata),  // [31:0] Dato a transmitir (TX)
      .cs     (cs_uart),    // Chip select del UART @ 0x00400000
      .addr   (mem_addr),   // [31:0] Dirección de byte dentro del periférico
      .rd     (rd),         // Habilitación de lectura (activo alto)
      .wr     (wr),         // Habilitación de escritura (activo alto)
      .d_out  (uart_dout),  // [31:0] Dato recibido (RX) hacia el núcleo
      .uart_tx(TXD),        // Línea serie de transmisión
      .uart_rx(RXD),        // Línea serie de recepción
      .ledout (LEDS[0])     // Indicador LED de actividad UART
  );

  //######################################
  //### DESCRIPCIÓN DE PERIFERICO MULT ###
  //######################################
  // Periférico multiplicador mapeado en 0x00420000 (cs_mult).
  //   - Escritura (WR): carga operandos o dispara la operación.
  //   - Lectura   (RD): devuelve mult_dout con el resultado.
  //   - Reset activo alto en el periférico (!resetn).
  wire [31:0] mult_dout;  // [31:0] Resultado del multiplicador hacia mem_rdata
  peripheral_mult u_mult (
      .clk  (clk),        // Reloj del sistema
      .reset(!resetn),    // Reset activo alto (invertido desde resetn)
      .d_in (mem_wdata),  // [31:0] Dato de entrada (operando) desde el núcleo
      .cs   (cs_mult),    // Chip select del multiplicador @ 0x00420000
      .addr (mem_addr),   // [31:0] Dirección de byte dentro del periférico
      .rd   (rd),         // Habilitación de lectura (activo alto)
      .wr   (wr),         // Habilitación de escritura (activo alto)
      .d_out(mult_dout)   // [31:0] Resultado hacia el bus mem_rdata
  );

  // //########################################
  // //### DESCRIPCIÓN DE PERIFERICO DPRAM ###
  // //########################################
  // // Memoria Dual-Port RAM (DPRAM) accesible como periférico.
  // //   - Puerto 0 (p0): interfaz con el núcleo RISC-V (16 bits de datos/dir).
  // //   - Chip select : cs[6] (compartido con RAM según el mapa actual).
  // //   - Reset activo alto en el periférico (!resetn).
  // //   - Solo se usan los 16 bits bajos de mem_wdata y mem_addr.
  // wire [31:0] dpram_dout;  // [31:0] Dato leído del DPRAM hacia mem_rdata
  // peripheral_dpram u_dpram_p0 (
  //     .clk  (clk),              // Reloj del sistema
  //     .reset(!resetn),          // Reset activo alto (invertido desde resetn)
  //     .d_in (mem_wdata[15:0]),  // [15:0] Dato de entrada (solo 16 bits bajos)
  //     .cs   (cs[6]),            // Chip select del DPRAM (¡revisar conflicto con RAM!)
  //     .addr (mem_addr[15:0]),   // [15:0] Dirección interna (solo 16 bits bajos)
  //     .rd   (rd),               // Habilitación de lectura (activo alto)
  //     .wr   (wr),               // Habilitación de escritura (activo alto)
  //     .d_out(dpram_dout)        // [31:0] Dato leído hacia el bus mem_rdata
  // );

`ifdef BENCH
  //########################################
  //### SALIDA DE CONSOLA (MODO BENCH)   ###
  //########################################
  // Cuando el programa escribe en cs[5] (chip de consola en simulación),
  // se imprime el byte bajo de mem_wdata como carácter ASCII y se fuerza
  // el vaciado del buffer. Solo activo si se define BENCH.
  //   - cs[5] & wr : escritura al registro de consola
  //   - mem_wdata[7:0] : carácter ASCII a imprimir
  //   - $fflush(32'h8000_0001) : vacía el buffer de salida estándar (FD 1)
  always @(posedge clk) begin
    if (cs[5] & wr) begin
      $write("%c", mem_wdata[7:0]);  // Imprime el byte como carácter ASCII
      $fflush(32'h8000_0001);  // Fuerza el flush del buffer de salida (stdout)
    end
  end
`endif

endmodule
