module freqDivPlusCounter (
    input mclk,
    output [7:0] countTop
);

  wire enableFromFreqDiv;
  freqDivEnable freqDiv1 (
      .mclk  (mclk),
      .enable(enableFromFreqDiv)
  );
  counter count1 (
      .clk(mclk),
      .enable(enableFromFreqDiv),
      .count(countTop)
  );

endmodule
