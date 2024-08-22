`include "./blink.v"
module top (
    // 25MHz clock input
    input  clk,
    // Led outputs
    output led
);

  blink my_blink (
      .clk(clk),
      .led(led)
  );

endmodule
