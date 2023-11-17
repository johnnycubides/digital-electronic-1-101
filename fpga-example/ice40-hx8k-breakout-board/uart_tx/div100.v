module div100 (
  input clk_in,
  output reg clk_out = 0
);

// SIZE = 2^7 = 128 lo contiene

parameter SIZE=7; 
parameter LIMIT=7'd100;

reg [SIZE-1:0] count = 0;

always@(posedge clk_in)
begin
  if(count == LIMIT)
  begin
    count <= 0;
    clk_out <= ~clk_out;
  end
  else
  begin
    count <= count + 1'd1;
  end
end
endmodule
