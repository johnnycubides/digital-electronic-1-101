module i2c_master (
    input  wire       clk,       // Reloj del sistema
    input  wire       reset,     // Reset activo alto
    input  wire       start,     // Señal para iniciar la comunicación
    input  wire [6:0] addr,      // Dirección del esclavo (7 bits)
    input  wire       rw,        // Bit de lectura/escritura (0: escritura, 1: lectura)
    input  wire [7:0] data_in,   // Dato a enviar (en modo escritura)
    output reg  [7:0] data_out,  // Dato recibido (en modo lectura)
    output reg        scl,       // Señal de reloj I2C
    inout  wire       sda,       // Señal de datos I2C (bidireccional)
    output reg        busy       // Indicador de ocupado (1: ocupado, 0: libre)
);

  // Estados de la máquina de estados finitos (FSM)
  localparam reg [2:0] IDLE = 3'b000;  // Estado inactivo
  localparam reg [2:0] START = 3'b001;  // Generar condición de START
  localparam reg [2:0] ADDR = 3'b010;  // Enviar dirección del esclavo + bit R/W
  localparam reg [2:0] ACKADDR = 3'b011;  // Esperar ACK del esclavo después de la dirección
  localparam reg [2:0] WRITEDATA = 3'b100;  // Enviar dato (en modo escritura)
  localparam reg [2:0] READDATA = 3'b101;  // Recibir dato (en modo lectura)
  localparam reg [2:0] ACKDATA = 3'b110;  // Esperar/enviar ACK después del dato
  localparam reg [2:0] STOP = 3'b111;  // Generar condición de STOP

  // Declaración del registro de estado
  reg [2:0] state;
  reg [7:0] shift_reg;  // Registro de desplazamiento para datos/dirección
  reg [2:0] bit_cnt;  // Contador de bits enviados/recibidos
  reg       sda_out;  // Valor de SDA (salida)
  reg       sda_oe;  // Control de salida SDA (1: salida, 0: entrada)
  reg       scl_en;  // Habilitación de SCL (1: generar SCL, 0: mantener SCL alto)

  // Asignación de SDA (bidireccional)
  assign sda = sda_oe ? sda_out : 1'bz;

  // Generación de SCL
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      scl <= 1;  // SCL en reposo (alto)
      scl_en <= 0;  // Deshabilitar SCL
    end else if (scl_en) begin
      scl <= ~scl;  // Generar SCL (alternar entre 0 y 1)
    end else begin
      scl <= 1;  // Mantener SCL alto
    end
  end

  // Máquina de estados principal
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      sda_out <= 1;
      sda_oe <= 0;
      busy <= 0;
      bit_cnt <= 0;
      shift_reg <= 0;
      data_out <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (start) begin
            state  <= START;
            busy   <= 1;
            scl_en <= 1;  // Habilitar SCL
          end
        end

        START: begin
          sda_out <= 0;  // Generar condición de START (SDA baja mientras SCL está alto)
          sda_oe <= 1;
          state <= ADDR;
          shift_reg <= {addr, rw};  // Cargar dirección + bit R/W
          bit_cnt <= 7;  // Contador de bits (8 bits: 7 de dirección + 1 de R/W)
        end

        ADDR: begin
          if (scl == 0) begin
            sda_out <= shift_reg[bit_cnt];  // Enviar bit actual
            if (bit_cnt == 0) begin
              state <= ACKADDR;
            end else begin
              bit_cnt <= bit_cnt - 1;
            end
          end
        end

        ACKADDR: begin
          if (scl == 0) begin
            sda_oe <= 0;  // Liberar SDA para recibir ACK
            if (sda == 0) begin  // Verificar ACK del esclavo
              if (rw) begin
                state <= READDATA;
              end else begin
                state <= WRITEDATA;
                shift_reg <= data_in;  // Cargar dato a enviar
                bit_cnt <= 7;
              end
            end else begin
              state <= STOP;  // Si no hay ACK, terminar la comunicación
            end
          end
        end

        WRITEDATA: begin
          if (scl == 0) begin
            sda_out <= shift_reg[bit_cnt];  // Enviar bit actual
            if (bit_cnt == 0) begin
              state <= ACKDATA;
            end else begin
              bit_cnt <= bit_cnt - 1;
            end
          end
        end

        READDATA: begin
          if (scl == 0) begin
            shift_reg[bit_cnt] <= sda;  // Leer bit actual
            if (bit_cnt == 0) begin
              state <= ACKDATA;
              data_out <= shift_reg;  // Almacenar dato recibido
            end else begin
              bit_cnt <= bit_cnt - 1;
            end
          end
        end

        ACKDATA: begin
          if (scl == 0) begin
            if (rw) begin
              sda_out <= 1;  // Enviar NACK después de la lectura
            end else begin
              sda_oe <= 0;  // Liberar SDA para recibir ACK
            end
            state <= STOP;
          end
        end

        STOP: begin
          if (scl == 0) begin
            sda_out <= 0;  // Preparar SDA para condición de STOP
            sda_oe  <= 1;
          end else if (scl == 1) begin
            sda_out <= 1;  // Generar condición de STOP (SDA sube mientras SCL está alto)
            busy <= 0;
            scl_en <= 0;  // Deshabilitar SCL
            state <= IDLE;
          end
        end
        default: state <= IDLE;
      endcase
    end
  end

endmodule
