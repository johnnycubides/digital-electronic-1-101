// filename: top_tb
// brief: testbench de un blink para la placa de desarrollo Blackice
// la cual tienen un reloj de hardware de 25 MHz (periodo 40 nS)

// CONFIGURACIÓN DEL TIMESCALE
// Tenga encuenta que: solo puede los enteros 1, 10, 100 en la escala de s, ms,
// us, ns, ps, fs.
// Para el time_unit se hará uso de 10 nS, en vista del perido del clock. el
// time_precision, se pone según interés
`timescale 10ns / 10ns  // <time_unit>/<time_precision

// CONFIGURACIÓN DE LOS PARÁMETROS DEL RELOJ
// Cada estado de reloj debe durar medio periodo, para este caso sería 20 nS,
// como el time_unit es de 10 ns, entonces con 2 tiempos se puede representar
// la duración de cada reloj.
`ifndef TIME_UNIT
`define TIME_UNIT 2
`endif

`include "./top.v"
module top_tb;

  // Determinar el tamaño de los wire como de los estímulos
  /* parameter INPUT_SIZE = 3; */
  parameter integer OUTPUT_SIZE = 1;

  // Make a regular pulsing clock.
  reg clk = 0;
  always #(`TIME_UNIT) clk = !clk;

  // CLOCK STIMULUS
  initial begin
    #(`TIME_UNIT*32) $finish();  // [stop(), $finish()]
  end

  // // STIMULUS 1
  // reg a = 0, b = 0;
  // initial
  // begin 
  //   # 17 a = 1, b = 1;
  //   # 11 a = 1, b = 0;
  //   # 29 a = 1, b = 1;
  //   # 11 a = 1, b = 0;
  //   # 100 $finish(); // [stop(), $finish()]
  // end

  // // STIMULUS 2
  // reg [INPUT_SIZE-1:0] inputs;
  // // inputs[2] inputs[1] inputs[1]
  // integer i;
  // initial
  // begin
  //   // inputs = 0;
  //   for (i=0; i<2**INPUT_SIZE; i=i+1) // 2 elevado a la INPUT_SIZE , en el ejemplo 2^3 = 8 combinaciones*/
  //   begin */
  //     inputs = i;
  //     #1;
  //   end
  // end

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  wire [OUTPUT_SIZE-1:0] probe;

  // DEVICE/DESIGN UNDER TEST
  top dut (
      .clk(clk),
      .led(probe)
  );

  // MONITOR
  initial $monitor("Time: %t, out = %d", $time, probe);

  // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    $dumpvars(0, top_tb);
  end
endmodule
