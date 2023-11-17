/* count = (clk_in / clk_out) */
/* Configuración a 115200 Hz */
/* count = (12E6 Hz)/(2 * 9600 bps) = 625 */
/* SIZE = 2^10 = 2048 lo contiene */

module counter #(
  parameter SIZE=10,
  parameter LIMIT=10'd625,
  parameter WIDTH=10'd1
)(
  input clk_in,
  output reg pulse = 0
);

reg [SIZE-1:0] count = 0;

always@(posedge clk_in)
begin
  count <= count + 1'd1;
  if(count < WIDTH)
  begin
    pulse <= 1'd1;
  end
  else
  begin
    pulse <= 1'd0;
  end
end
endmodule
