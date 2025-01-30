// `include "./divFreq.v"
`include "./uart_rx_8n1.v"
`include "./uart_tx_8n1.v"

module uart_8n1 #(
    parameter integer FREQ_IN  = 20e6,
    parameter integer FREQ_OUT = 9600
) (
    // Inputs and output ports
    input  wire       hclk,      // Baud tick generado externamente
    input  wire       rst,       // Reset
    input  wire       rx,        // Línea de recepción
    output wire       tx,        // Línea de transmisión
    input  wire [7:0] tx_data,   // Dato a transmitir
    input  wire       tx_start,  // Señal para iniciar transmisión
    output wire       tx_busy,   // Indicador de transmisor ocupado
    output wire [7:0] rx_data,   // Dato recibido
    output wire       rx_ready   // Indicador de dato recibido
);

  // Declaración de señales [reg, wire]
  wire baud_clk;

  // Descripción del comportamiento
`ifdef DEBUG
  assign baud_clk = hclk;
`else
  divFreq #(
      .FREQ_IN (FREQ_IN),
      .FREQ_OUT(FREQ_OUT)
  ) baud (
      .CLK_IN (hclk),
      .CLK_OUT(baud_clk)
  );
`endif

  uart_tx_8n1 uart_tx (
      .baud_tick(baud_clk),
      .rst(rst),
      .tx(tx),
      .tx_data(tx_data),
      .tx_start(tx_start),
      .tx_busy(tx_busy)
  );

  uart_rx_8n1 uart_rx (
      .baud_tick(baud_clk),
      .rst(rst),
      .rx(rx),
      .rx_data(rx_data),
      .rx_ready(rx_ready)
  );

endmodule
