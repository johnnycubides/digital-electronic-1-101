module half_adder (input x, y, output s, c);
  assign s = x ^ y;
  assign c = x & y;
endmodule
