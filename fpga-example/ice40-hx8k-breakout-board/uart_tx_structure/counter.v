// count = (clk_in / clk_out)
// Configuración a 2 Hz
// count = (19200 Hz)/(2 Hz) = 9600
// SIZE = 2^14 = 16384 lo contiene 
// LIMIT = 9600

module counter #(
  parameter SIZE=14,
  parameter LIMIT=14'd9600,
  parameter WIDTH_PULSE=14'd1
)(
  input clk_in,
  output reg pulse = 0
);

reg [SIZE-1:0] count = 0;

always@(posedge clk_in)
begin
  count <= count + 1'd1;
  if(count < WIDTH_PULSE)
  begin
    pulse <= 1'd1;
  end
  else
  begin
    pulse <= 1'd0;
  end
  if(count == LIMIT)
  begin
    count <= 0;
  end
end

endmodule
