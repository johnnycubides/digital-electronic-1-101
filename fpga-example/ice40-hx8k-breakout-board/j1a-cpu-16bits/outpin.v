module outpin (
    input  clk,
    output pin,
    input  we,
    input  wd,
    output rd
);

  SB_IO #(
      .PIN_TYPE(6'b0101_01)
  ) _io (
      .PACKAGE_PIN(pin),
      .CLOCK_ENABLE(we),
      .OUTPUT_CLK(clk),
      .D_OUT_0(wd),
      .D_IN_0(rd)
  );
endmodule
