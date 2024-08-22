// Se incluye el divisor de frecuencia
`include "./clk10hz.v"
// Se incluye el contador de 8 bits
`include "./counter8bits.v"
module top (
    input clk,
    output [7:0] leds
);

  wire clk2;

  clk10hz clock (
      .clk_in (clk),
      .clk_out(clk2)
  );
  counter8bits counter (
      .clk  (clk2),
      .count(leds)
  );

endmodule
