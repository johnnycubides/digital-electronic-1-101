module freqDivAny (
    input mclk,
    output reg clk_out
);

  localparam integer LIMIT = 5;
  reg [23:0] counter;
  initial begin
    clk_out = 0;
    counter = 0;
  end
  always @(posedge mclk) begin
    if (counter == LIMIT) begin
      counter <= 0;
      clk_out <= ~clk_out;
    end else begin
      counter <= counter + 1;
    end
  end
endmodule
