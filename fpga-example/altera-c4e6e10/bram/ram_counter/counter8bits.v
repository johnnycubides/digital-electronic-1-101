module counter8bits #(
  parameter SIZE = 8)
  (
// Inputs and output ports
  input clk,
  output reg [SIZE-1:0] count
);

// Descripción del comportamiento
// parameter LIMIT = 8'd255;

// reg [SIZE-1:0] count = 0;
initial
begin
  count = 0;
end

always@(posedge clk)
begin
  // if(count == LIMIT)
  // begin
    // count <= 0;
    // clk_out <= ~clk_out;
  // end
  // else
  // begin
    count <= count + 1;
  // end
end

endmodule
