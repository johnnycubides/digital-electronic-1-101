`include "./clock_divider.v"

module top #(
    parameter INIT = 0
) (
    // 25MHz clock input
    input  clk,
    // Led outputs
    /* output [3:0] led */
    output led
);

  // turn other leds off (active low)
  /* assign led[2:0] = 3'b111; */

  clock_divider #(
      .INIT(INIT)
  ) div (
      .clk_in (clk),
      .clk_out(led)
  );

endmodule
