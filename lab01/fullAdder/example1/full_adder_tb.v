module full_adder_tb;

reg [3:0] a;
wire s, c;

full_adder full_adder (a[2], a[1], a[0], z, c);

initial begin
  $dumpvars(0, full_adder_tb);
  a = 0;
  while (a <= 7) begin
    #1;
    a = a + 1;
  end
  $finish();
end

endmodule
