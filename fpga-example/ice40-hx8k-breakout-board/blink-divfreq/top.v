// `include "./freqDiv.v"

module top (
    // 12MHz clock input
    input  clk,
    // Led outputs
    output led
);

  freqDiv #(
`ifdef SIM  // Macros de presíntesis
      .FREQ_IN (10),    // 10 Tikcs
      .FREQ_OUT(1)      // 1 Tikcs
`else
      .FREQ_IN (12e6),  // 12 MHz
      .FREQ_OUT(1)      // 1 Hz
`endif
  ) frequencyDivider (
      .CLK_IN (clk),
      .CLK_OUT(led)
  );

endmodule
