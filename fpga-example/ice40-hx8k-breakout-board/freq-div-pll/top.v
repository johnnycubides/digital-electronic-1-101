// `include "./clk1hz.v"
// `include "./clk10hz.v"
// `include "./clk100hz.v"
`include "./divFreq.v"
`include "./pll.v"

module top (
    input clock,
    output wire led
);

  wire pllClock;

  // clk1hz clk0(.clk_in(clock), .clk_out(led));
  // clk10hz clk0(.clk_in(clock), .clk_out(led));

  divFreq freq1hz (
      .CLK_IN (pllClock),
      // .CLK_IN (clock),
      .CLK_OUT(led)
  );

  
  pll pll (
    .clock_in(clock),
    .clock_out(pllClock)
  );
  

endmodule
