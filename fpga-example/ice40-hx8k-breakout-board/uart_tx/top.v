`include "divFreq.v"
`include "pulse.v"
`include "ascii_a_z.v"
`include "uart_tx_8n1.v"

module top #(
  parameter integer FREQ_IN_UART = 12E6, // Hardware clock frequency 12 MHz
  parameter integer FREQ_OUT_UART = 9600, // Hardware clock frequency 9600 Hz
  parameter SIZE_COUNTER=14,
  parameter LIMIT_COUNTER=14'd9600
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
// wire clk_100hz;
wire clk_uart;
wire pulse;
wire [7:0] word;
wire tx_start;

assign test_pin = tx_pin;

// Descripción del comportamiento

// Clock de uart
divFreq #(
  .FREQ_IN(FREQ_IN_UART),
  .FREQ_OUT(FREQ_OUT_UART)
) clkuart (
  .CLK_IN(clk_hw), 
  .CLK_OUT(clk_uart)
);

// Pulso de uart
pulse #(
  .FREQ_IN(FREQ_OUT_UART),
  .FREQ_OUT(2)
)pulse_uart(
  .CLK_IN(clk_uart),
  .PULSE_OUT(pulse)
);

// Generador de caracteras de la "a" a la "z"
ascii_a_z ascii_a_z (
  .newWord(pulse),
  .word(word),
  .start(tx_start)
);

// Periferico TX Uart
uart_tx_8n1 uart_tx(
  .clk(clk_uart),
  .txbyte(word),
  .senddata(tx_start),
  .txdone(tx_done),
  .tx(tx_pin)
);

endmodule
