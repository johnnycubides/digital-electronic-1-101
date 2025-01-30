`include "divFreq.v"
`include "pulse.v"
`include "ascii_a_z.v"
`include "./uart_8n1.v"

module top #(
    parameter integer HARDWARE_FREQ = 12e6,  // Hardware clock frequency 12 MHz
    parameter integer FREQ_OUT_UART = 9600,  // Hardware clock frequency 9600 Hz
    parameter integer SIZE_COUNTER = 14,
    parameter integer LIMIT_COUNTER = 14'd9600
) (
    // Inputs and output ports
    clk_hw,
    busyLed,
    test_pin,
    tx_pin
);

  input clk_hw;
  output busyLed;
  output tx_pin;
  output test_pin;

  // Declaración de señales [reg, wire]
  wire rst;
  wire pulse;
  wire [7:0] word;
  wire tx_start;
  wire busy;

  assign rst = 1'b0;
  assign test_pin = tx_pin;
  assign busyLed = busy;

  // Descripción del comportamiento

  // Pulso de uart
  pulse #(
`ifdef SIM
      .FREQ_IN (100),
      .FREQ_OUT(1)
`else
      .FREQ_IN (HARDWARE_FREQ),
      .FREQ_OUT(2)
`endif
  ) pulse_uart (
      .CLK_IN(clk_hw),
      .WIDTH_STOP(busy),
      .PULSE_OUT(pulse)
  );

  // Generador de caracteras de la "a" a la "z"
  ascii_a_z ascii_a_z (
      .newWord(pulse),
      .word(word),
      .start(tx_start)
  );

  uart_8n1 #(
`ifdef SIM
      .FREQ_IN (100),
      .FREQ_OUT(50)
`else
      .FREQ_IN (HARDWARE_FREQ),
      .FREQ_OUT(FREQ_OUT_UART)
`endif
  ) uart (
      .tx_data(word),
      .tx_start(tx_start),
      .tx_busy(busy),
      .tx(tx_pin),
      .rx(),
      .rx_data(),
      .rx_ready(),
      .rst(rst),
      .hclk(clk_hw)
  );

endmodule
