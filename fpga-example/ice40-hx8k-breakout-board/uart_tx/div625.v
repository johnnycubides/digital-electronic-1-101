/* count = (clk_in / clk_out) */
/* Configuración a 115200 Hz */
/* count = (12E6 Hz)/(2 * 9600 bps) = 625 */
/* SIZE = 2^10 = 2048 lo contiene */

module div625 #(
  parameter SIZE=10,
  parameter LIMIT=10'd625
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
