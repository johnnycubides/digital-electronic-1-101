// filename: multiplier_tb.v
// brief: testbench de un blink para la placa de desarrollo Blackice
// la cual tienen un reloj de hardware de 25 MHz (periodo 40 nS)

// CONFIGURACIÓN DEL TIMESCALE
// Tenga encuenta que: solo puede usar los enteros 1, 10, 100 en la escala de
// s, ms, us, ns, ps, fs.
// Para el time_unit se hará uso de 10 nS, en vista del perido del clock. el
// time_precision, se pone según interés
`timescale 1ns / 1ns  // <time_unit>/<time_precision

// CONFIGURACIÓN DE LOS PARÁMETROS DEL RELOJ
// Cada estado de reloj debe durar medio periodo, para este caso sería 20 nS,
// como el time_unit es de 10 ns, entonces con 2 tiempos se puede representar
// la duración de cada reloj.
`ifndef TIME_UNIT
`define TIME_UNIT 2
`endif
// `include "./top.v"

module multiplier_tb;

  reg clk = 0;
  always #(`TIME_UNIT) clk = !clk;

  initial begin
    #(`TIME_UNIT * 1E2) $finish();  // [stop(), $finish()]
  end

  reg  [ 7:0] multiplicand = 0;
  reg  [ 7:0] multiplier = 32;
  wire [15:0] product;

  // DEVICE/DESIGN UNDER TEST
  multiplier multiplier1 (
      .clk(clk),
      .multiplicand(multiplicand),
      .multiplier(multiplier),
      .product(product)
  );

  // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    $dumpvars(0, multiplier_tb);
  end
endmodule
