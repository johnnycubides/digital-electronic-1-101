module and2_lut4(
  input wire [3:0] inputs,
  output wire out
);

  // reg [15:0] lut_table = 16'b1000100010001000;
  reg [15:0] lut_table = 16'b0000000000001000;
  assign out = lut_table[inputs];

endmodule
