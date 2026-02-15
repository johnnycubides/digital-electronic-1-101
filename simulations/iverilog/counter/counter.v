module counter (
    out,
    clk,
    reset
);

  parameter integer WIDTH = 8;

  output [WIDTH-1 : 0] out;
  input clk, reset;

  reg [WIDTH-1 : 0] out;
  wire clk, reset;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out <= 0;
    end else begin
      out <= out + 1'd1;
    end
  end

endmodule  // counter
