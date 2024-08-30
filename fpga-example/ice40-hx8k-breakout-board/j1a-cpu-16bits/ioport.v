module ioport (
    input clk,
    inout [7:0] pins,
    input we,
    input [7:0] wd,
    output [7:0] rd,
    input [7:0] dir
);

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : io
      // 1001   PIN_OUTPUT_REGISTERED_ENABLE 
      //     01 PIN_INPUT 
      SB_IO #(
          .PIN_TYPE(6'b1001_01)
      ) _io (
          .PACKAGE_PIN(pins[i]),
          .CLOCK_ENABLE(we),
          .OUTPUT_CLK(clk),
          .D_OUT_0(wd[i]),
          .D_IN_0(rd[i]),
          .OUTPUT_ENABLE(dir[i])
      );
    end
  endgenerate

endmodule
