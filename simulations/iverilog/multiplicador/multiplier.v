module multiplier (
    input clk,
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output reg [15:0] product = 0
);

  reg [15:0] tmp_product = 0;
  reg [ 7:0] counter = 0;

  always @(posedge clk) begin
    if (counter < multiplier) begin
      tmp_product <= tmp_product + multiplicand;
      counter <= counter + 1;
    end else begin
      product <= tmp_product;
    end
  end

endmodule
