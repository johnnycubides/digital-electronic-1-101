module freqDiv2 (
    input  wire clk,
    output reg  clk_out
);
  // Valores iniciales
  initial begin
    clk_out = 0;
  end
  always @(posedge clk) begin
    clk_out <= ~clk_out;
  end
endmodule
