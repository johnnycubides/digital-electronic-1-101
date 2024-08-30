`include "./gate_or.v"
module top (
    input  wire a,
    input  wire b,
    output wire c
);

  wire wc;
  gate_or gate_or (
      ~a,
      ~b,
      wc
  );

  assign c = ~wc;
endmodule
