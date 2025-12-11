// `include "./and2_lut4.v"
module top (
    input  a,
    input  b,
    output s
);

  and2_lut4 and2 (
      .inputs({1'b0, 1'b0, b, a}),
      .out(s)
  );

endmodule
