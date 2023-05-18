module and3_tb;

reg [3:0] a;
wire z;


and3 and3(a[2], a[1], a[0], z);

initial begin
  $dumpvars(0, and3_tb);
  
  a = 0;
  while (a <= 7) begin
    #1;
    a = a + 1;
  end
  $finish();
end

endmodule
