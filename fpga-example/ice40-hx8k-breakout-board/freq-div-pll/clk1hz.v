module clk1hz (
  input clk_in,
  output reg clk_out = 0
);

/* count = (clk_in / clk_out) */
/* Ejemplo 1 */
/* count = 25E6 = 25000000 = (25E6 Hz)/(1 Hz) */
/* SIZE = 2^25 = 33.5E6 lo contiene */
/* Ejemplo 2 */
/* count = (50E6 Hz)/(1 Hz) = 50E6 = 50000000 */
/* SIZE = 2^26 = 67.5E6 lo contiene */
/* Configuración a 1 Hz */
/* count = (12E6 Hz)/(1 Hz) = 12E6 = 12000000 */
/* SIZE = 2^24 = 16.777E6 lo contiene */

parameter SIZE = 24; 
parameter LIMIT = 24'd12000000;

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
    count <= count + 1;
  end
end
endmodule
