module half_adder_tb;

reg [2:0] a;
wire s, c;

half_adder half_adder(a[1], a[0], z, c);

initial begin
  $dumpvars(0, half_adder_tb);
  a = 0;
  while (a <= 3) begin
    #1;
    a = a + 1;
  end
  $finish();
end

endmodule

