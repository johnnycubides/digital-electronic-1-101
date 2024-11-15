`include "./blink.v"

module top (
    // 25MHz clock input
    input  clk,
    // Led output
    output led
);

  blink my_blink (
      .clk(clk),
      .led(led)
  );

endmodule
