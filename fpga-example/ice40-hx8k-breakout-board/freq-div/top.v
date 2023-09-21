// `include "./clk1hz.v"
// `include "./clk10hz.v"
// `include "./clk100hz.v"
`include "./clk50hz.v"

module top (input clock, output wire led);

// clk1hz clk0(.clk_in(clock), .clk_out(led));
// clk10hz clk0(.clk_in(clock), .clk_out(led));
clk50hz clk0(.clk_in(clock), .clk_out(led));

endmodule
