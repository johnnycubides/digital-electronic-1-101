module uart_tx_8n1 (
    input  wire       baud_tick,   // Baud tick generado externamente
    input  wire [7:0] tx_data,     // Dato a transmitir
    input  wire       tx_start,    // Señal para iniciar transmisión
    input  wire       rst,         // Reset
    output reg        tx = 1,      // Línea de transmisión
    output reg        tx_busy = 0  // Indicador de transmisor ocupado
);
  // Transmisor
  reg [9:0] tx_shift_reg;  // Start bit + 8 bits de datos + Stop bit
  reg [3:0] tx_bit_count;

  // Transmisor
  always @(posedge baud_tick or posedge rst) begin
    if (rst) begin
      tx <= 1'b1;  // Línea inactiva IDLE
      tx_busy <= 0;
      tx_shift_reg <= 10'b1111111111;
      tx_bit_count <= 0;
    end else if (tx_start && !tx_busy) begin
      tx_shift_reg <= {1'b1, tx_data, 1'b0};  // Stop + Data + Start
      tx_bit_count <= 0;
      tx_busy <= 1;
    end else if (tx_busy) begin
      tx <= tx_shift_reg[0];
      tx_shift_reg <= {1'b1, tx_shift_reg[9:1]};  // Shift
      tx_bit_count <= tx_bit_count + 1;
      if (tx_bit_count == 10) begin
        tx_busy <= 0;  // Transmisión completa
      end
    end
  end
endmodule
