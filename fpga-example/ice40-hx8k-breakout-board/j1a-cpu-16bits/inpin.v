module inpin (
    input  clk,
    input  pin,
    output rd
);

  SB_IO #(
      .PIN_TYPE(6'b0000_00)
  ) _io (
      .PACKAGE_PIN(pin),
      .INPUT_CLK(clk),
      .D_IN_0(rd)
  );
endmodule

