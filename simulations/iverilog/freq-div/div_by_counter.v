module div_by_counter (
    input  mclk,    // Cable
    output clk_out  // cable
);

  reg [7:0] counter;
  initial begin
    counter = 0;
  end
  always @(posedge mclk) begin
    counter <= counter + 1;
  end
  assign clk_out = counter[3];
endmodule
