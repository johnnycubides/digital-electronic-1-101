module and3_tb;

reg a, b , c;
wire z;

and3 and3(a, b, c, z);

initial begin
  // $dumpfile("and3_tb.vcd");
  $dumpvars(0, and3_tb);
  a = 1;
  b = 1;
  c = 1;
  #1
  a = 0;
  b = 1;
  c = 1;
  #1
  a = 0;
  b = 1;
  c = 0;
  #1
  $finish();
end

endmodule
