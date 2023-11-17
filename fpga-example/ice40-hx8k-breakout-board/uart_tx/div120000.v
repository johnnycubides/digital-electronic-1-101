/* count = (clk_in / clk_out) */
/* count = (12E6 Hz)/(100 Hz) = 12E4 = 120000 */
/* SIZE = 2^17 = 131.072E3 lo contiene */

module div120000 #(
  parameter SIZE=17,
  parameter LIMIT=17'd120000
)(
  input clk_in,
  output reg clk_out = 0
);

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
