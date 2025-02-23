`include "./pulse.v"
module top (
    input  clk,
    output pin_pulse
);

  // Declaración de señales [reg, wire]
  pulse #(
      .FREQ_IN(10000),
      .WIDTH_PULSE(100e-4)
  ) pulse (
      .start(start),
      .clk  (clk),
      .pulse(pulse)
  );

  // Descripción del comportamiento

endmodule
