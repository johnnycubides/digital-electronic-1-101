`include "./pll.v"

`default_nettype none
`define WIDTH 16

module top (
    input  wire mclk,
    output wire clko
);

  wire clk;

  pll pll40hx (
      .clock_in (mclk),
      .clock_out(clk)
      // .locked(locked),
  );

  assign clko = clk;


endmodule
