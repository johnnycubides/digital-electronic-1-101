`include "./divFreqEn.v"
`include "./divFreq.v"
`include "./posEdgeDetector.v"
`include "./negEdgeDetector.v"

module i2c_master #(
    parameter integer FREQ_IN  = 20e6,
    parameter integer FREQ_OUT = 100e3
) (
    input  wire       clk,        // Reloj del sistema
    input  wire       reset,      // Reset activo alto
    input  wire       startTask,  // Señal para iniciar la comunicación
    input  wire [6:0] addr,       // Dirección del esclavo (7 bits)
    input  wire       rw,         // Bit de lectura/escritura (0: escritura, 1: lectura)
    input  wire [7:0] data_in,    // Dato a enviar (en modo escritura)
    output reg  [7:0] data_out,   // Dato recibido (en modo lectura)
    inout  wire       scl,        // Señal de reloj I2C
    inout  wire       sda,        // Señal de datos I2C (bidireccional)
    output wire       probe,
    output wire       D5,
    output wire       D4,
    output wire       D3,
    output wire       D2,
    output reg        busy        // Indicador de ocupado (1: ocupado, 0: libre)
);

  // INFO: scl_out ok, reset en bajo, busy ok
  assign D5 = sclGenerator;
  assign D4 = state[0];
  assign D3 = state[1];
  assign D2 = state[2];

  // Parametros de macros "presíntesis"
  // Valores posibles para SDA y SCL
  localparam reg ZMODE = 0;
  localparam reg OUTPUTMODE = 1;
  // Valores posibles para respuesta de datos transmitidos
  localparam reg ACK = 0;
  localparam reg NACK = 1;
  // Valores posibles para busy
  localparam reg NO = 0;
  localparam reg YES = 1;
  // Estados de la máquina de estados finitos (FSM)
  localparam reg [2:0] IDLE = 3'b000;  // Estado inactivo
  localparam reg [2:0] START = 3'b001;  // Generar condición de START
  localparam reg [2:0] ADDR = 3'b010;  // Enviar dirección del esclavo + bit R/W
  localparam reg [2:0] ACKADDR = 3'b011;  // Esperar ACK del esclavo después de la dirección
  localparam reg [2:0] WRITEDATA = 3'b100;  // Enviar dato (en modo escritura)
  localparam reg [2:0] READDATA = 3'b101;  // Recibir dato (en modo lectura)
  localparam reg [2:0] ACKDATA = 3'b110;  // Esperar/enviar ACK después del dato
  localparam reg [2:0] STOP = 3'b111;  // Generar condición de STOP

  // Declaración de registros para el funcionamiento del I2c
  reg [2:0] state;  // Declaración del registro de estado
  reg [2:0] next_state;  // Próximo estado
  reg [7:0] shift_reg;  // Registro de desplazamiento para datos/dirección
  reg [2:0] bit_cnt;  // Contador de bits enviados/recibidos
  reg       sda_reg;  // Valor de SDA (salida)
  reg       sdaMode;  // Control de salida SDA (1: salida, 0: entrada)
  reg       sclMode;  // Habilitación de SCL (1: generar SCL, 0: mantener Z impedancia)

  // Initial register states
  initial begin
    busy = NO;  // 0: Libre, 1: Ocupado
    state = IDLE;
    next_state = IDLE;
    shift_reg = 8'd0;
    bit_cnt = 3'd0;
    sda_reg = 1'b0;
    sdaMode = ZMODE;  // sda <- z
    sclMode = ZMODE;  // scl <- z
  end

  // Circuito para el generador de señal SCL
  wire sclGenerator;
`ifdef DEBUG
  // Parametros del clock para simulaciones a través de testbench
  localparam integer FreqInSim = 16;
  localparam integer FreqOutSim = 1;
  divFreq #(
      .FREQ_IN (FreqInSim),
      .FREQ_OUT(FreqOutSim)
  ) scl_gen (
      .CLK_IN(clk),
      .RST(reset),
      .CLK_OUT(sclGenerator)
  );
`else
  // Generador de clock con respecto al hardware clock
  divFreq #(
      .FREQ_IN (FREQ_IN),
      .FREQ_OUT(FREQ_OUT)  // Posibles valores de salida: 100KHz, 400KHz
  ) scl_gen (
      .CLK_IN(clk),
      .RST(reset),
      .CLK_OUT(sclGenerator)
  );
`endif

  // Control del SCL
  // sclMode  sclGenerator  output
  // 0        0             z
  // 0        1             z
  // 1        0             0
  // 1        1             z
  // producto de sumas
  // output = ~sclMode | sclGenerator
  assign scl   = (~sclMode | sclGenerator) ? 1'bz : 1'b0;
  // assign scl   = (sclMode == 1'b1 && sclGenerator == 1'b0) ? 1'b0 : 1'bz;
  // assign scl_out = sclGenerator ? 1'bz : 1'b0;  // Cambiar de 1 y 0 a z y 0
  // assign scl = sclMode ? scl_out : 1'bz;  // Activar SCL

  // Asignación de SDA (bidireccional)
  // sdaMode  sda_reg       output
  // 0        0             z
  // 0        1             z
  // 1        0             0
  // 1        1             z
  // producto de sumas
  // output = ~sdaMode | sda_reg
  assign sda   = (~sdaMode | sda_reg) ? 1'bz : 1'b0;
  // assign sda   = (sdaMode == 1'b1 && sda_reg == 1'b0) ? 1'b0 : 1'bz;
  // assign sda_out = sda_reg ? 1'bz : 1'b0;  // Exponer el valor del registro como 0 o Z
  // assign sda = sdaMode ? sda_out : 1'bz;  // Habilitar la salida del sda

  assign probe = sda;

  // reg  scl_new = 1;
  // reg  enable = 0;

  // // Transición de estados
  // always @(posedge clk or posedge reset) begin
  //   if (reset) begin
  //     state <= IDLE;
  //     sclMode <= ZMODE;
  //     sdaMode <= ZMODE;
  //     busy <= 0;
  //     bit_cnt <= 0;
  //     shift_reg <= 0;
  //     data_out <= 0;
  //   end else begin
  //     state <= next_state;
  //   end
  // end

  // Circuito detector de pulsos de bajada usado
  // para realizar cambios en la máquina de estados
  wire enableState;
  negEdgeDetector sclNegEdgeDetector (
      .clk(clk),
      .rst(reset),
      .signal(sclGenerator),
      .detector(enableState)
  );

  // Circuito detector de pulsos de subida para el scl.
  // Es usado principalmente para la lectura de datos en el bus
  wire sclPosEdge;
  posEdgeDetector sclPosEdgeDetector (
      .clk(clk),
      .rst(reset),
      .signal(scl),
      .detector(sclPosEdge)
  );


  reg data = 0;  // 1 -> ACK, 0 -> NACK
  reg dataReceived = 0;
  // Máquina de estados principal
  always @(posedge clk) begin

    // Reset de la FSM
    if (reset) begin
      state <= IDLE;
      sclMode <= ZMODE;
      sdaMode <= ZMODE;
      busy <= NO;
      bit_cnt <= 0;
      shift_reg <= 0;
      data_out <= 0;
    end else begin
      // Task 1, 2 y 3 simultaneas
      // Task 1: Detector de datos de entrada recibidos
      if (sclPosEdge && sdaMode == ZMODE) begin
        dataReceived <= 1;
        data <= sda;
      end else if (enableState) begin
        dataReceived <= 0;
      end
      // Task 2: Actualizar a nuevo estado
      state <= next_state;
      // Task 3: Máquina de estados FSM
      case (state)
        IDLE: begin
          if (startTask & enableState) begin
            next_state <= START;
            busy <= YES;
          end
        end

        START: begin
          if (enableState) begin
            sclMode <= ZMODE;
            sdaMode <= OUTPUTMODE;
            sda_reg <= 0;  // Generar condición de START (SDA baja mientras SCL está alto)
            shift_reg <= {addr, rw};  // Cargar dirección + bit R/W
            bit_cnt <= 7;  // Contador de bits (8 bits: 7 de dirección + 1 de R/W)
            next_state <= ADDR;
          end
        end

        ADDR: begin
          if (enableState) begin
            sda_reg <= shift_reg[bit_cnt];  // Enviar bit actual
            sclMode <= OUTPUTMODE;
            if (bit_cnt == 0) begin
              sdaMode <= ZMODE;  // Modo in
              next_state <= ACKADDR;
            end else begin
              bit_cnt <= bit_cnt - 1;
            end
          end
        end

        // TODO: requiere revisión
        ACKADDR: begin
          if (dataReceived) begin
            if (data == NACK) begin  // Verificar ACK del esclavo
              if (rw) begin
                next_state <= READDATA;
                sdaMode <= ZMODE;
              end else begin
                next_state <= WRITEDATA;
                shift_reg <= data_in;  // Cargar dato a enviar
                bit_cnt <= 7;
                sdaMode <= OUTPUTMODE;
              end
            end else begin
              next_state <= STOP;  // Si no hay ACK, terminar la comunicación
            end
          end
        end

        WRITEDATA: begin
          if (enableState) begin
            sda_reg <= shift_reg[bit_cnt];  // Enviar bit actual
            if (bit_cnt == 0) begin
              next_state <= ACKDATA;
              sdaMode <= ZMODE;
            end else begin
              bit_cnt <= bit_cnt - 1;
            end
          end
        end

        READDATA: begin
          if (dataReceived) begin
            shift_reg[bit_cnt] <= data;  // Leer bit actual
            if (bit_cnt == 0) begin
              next_state <= ACKDATA;
              data_out   <= shift_reg;  // Almacenar dato recibido
            end else begin
              bit_cnt <= bit_cnt - 1;
            end
          end
        end

        ACKDATA: begin
          if (dataReceived) begin
            if (rw) begin  // Si lectura
              sda_reg <= NACK;  // Enviar NACK después de la lectura
            end else begin
              sdaMode <= ZMODE;  // Liberar SDA para recibir ACK
            end
            next_state <= STOP;
          end
        end

        STOP: begin
          if (enableState) begin
            sda_reg <= 1;  // Generar condición de STOP (SDA sube mientras SCL está alto)
            busy <= NO;
            sclMode <= ZMODE;  // Deshabilitar SCL
            next_state <= IDLE;
          end
        end
        default: next_state <= IDLE;
      endcase

    end
  end

endmodule
