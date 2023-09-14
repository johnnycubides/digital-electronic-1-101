module half_adder (input x, y, output s, c);
  assign s = x ^ y;
  assign c = x & y;
endmodule

module full_adder (input x, y, z, output s, c);
  wire s1, c1;
  half_adder half_adder1(x, y, s1, c1);
  wire c2;
  half_adder half_adder2(s1, z, s, c2);
  assign c = c2 | c1 ;
endmodule
