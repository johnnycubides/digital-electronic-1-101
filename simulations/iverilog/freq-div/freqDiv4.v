module freqDiv4 (
    input  wire clk_in,
    output wire clk_out
);

  wire clk_out1;

  freqDiv2 div1 (
      .clk(clk_in),
      .clk_out(clk_out1)
  );
  freqDiv2 div2 (
      .clk(clk_out1),
      .clk_out(clk_out)
  );
endmodule
