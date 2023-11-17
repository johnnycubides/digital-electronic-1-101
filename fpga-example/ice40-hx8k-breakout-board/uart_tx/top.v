module top #(
  parameter SIZE_DIV625=10,
  parameter LIMIT_DIV625=10'd625,
  parameter SIZE_COUNTER=14,
  parameter LIMIT_COUNTER=14'd19200
)(
// Inputs and output ports
  clk_hw,
  tx_done,
  test_pin,
  tx_pin
);

input clk_hw;

output tx_done;
output tx_pin;
output test_pin;

// Declaración de señales [reg, wire]
wire clk_100hz;
wire clk_uart;
wire pulse;
wire [7:0] word;
wire tx_start;

assign test_pin = tx_pin;

// Descripción del comportamiento

div625 #(
  .SIZE(SIZE_DIV625),
  .LIMIT(LIMIT_DIV625)
) f19200hz(
  .clk_in(clk_hw),
  .clk_out(clk_uart)
);

counter #(
  .SIZE(SIZE_COUNTER),
  .LIMIT(LIMIT_COUNTER)
) trigger(
  .clk_in(clk_uart),
  .pulse(pulse)
);

ascii_a_z ascii_a_z (
  .newWord(pulse),
  .word(word),
  .start(tx_start)
);

uart_tx_8n1 uart_tx(
  .clk(clk_uart),
  .txbyte(word),
  .senddata(tx_start),
  .txdone(tx_done),
  .tx(tx_pin)
);

endmodule
