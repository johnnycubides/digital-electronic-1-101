module top (
// Inputs and output ports
  clk,
  byte2send,
  tx_start,
  tx_done,
  tx_pin
);

input clk;
input [7:0] byte2send;
input tx_start;

output tx_done;
output tx_pin;

// Declaración de señales [reg, wire]

// Descripción del comportamiento
uart_tx_8n1 uart_tx(
  .clk(clk),
  .txbyte(byte2send),
  .senddata(tx_start),
  .txdone(tx_done),
  .tx(tx_pin)
);

endmodule
