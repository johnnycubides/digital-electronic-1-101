// filename: top_tb.v
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
`define TIME_UNIT 42
`endif
`include "./chronometer.v"
module chronometer_tb;
  parameter integer LIMIT_CNT = 1000;
  // Determinar el tamaño de los wire como de los estímulos
  // parameter integer INPUT_SIZE = 1;
  parameter integer OUTPUT_SIZE = $clog2(LIMIT_CNT);

  // STIMULUS 1
  // reg [INPUT_SIZE-1:0] inputs;
  // initial begin
  //   inputs = 0;
  //   #(`TIME_UNIT * 1) inputs = 1;
  //   #(`TIME_UNIT * 1) $finish();  // [stop(), $finish()]
  // end

  // Make a regular pulsing clock.
  reg clk = 0;
  always #(`TIME_UNIT) clk = !clk;

  // CLOCK STIMULUS
  initial begin
    #(`TIME_UNIT * 100000) $finish();  // [stop(), $finish()]
  end

  reg start = 0;
  reg enable = 0;
  initial begin
    #(`TIME_UNIT * 2) start = 1;  // [stop(), $finish()]
    #(`TIME_UNIT * 2) start = 0;  // [stop(), $finish()]
    #(`TIME_UNIT * 2) enable = 1;  // [stop(), $finish()]
    #(`TIME_UNIT * 1000) enable = 0;  // [stop(), $finish()]
  end

  // initial
  // begin
  //   #2E9 $finish(); // [stop(), $finish()]
  // end

  // // STIMULUS 1
  // reg a = 0, b = 0;
  // initial begin
  //   #(`TIME_UNIT * 17) a = 1;
  //   b = 1;
  //   #(`TIME_UNIT * 11) a = 1;
  //   b = 0;
  //   #(`TIME_UNIT * 29) a = 1;
  //   b = 1;
  //   #(`TIME_UNIT * 11) a = 1;
  //   b = 0;
  //   #(`TIME_UNIT * 100) $finish();  // [stop(), $finish()]
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
  // #(`TIME_UNIT * 1 );
  //   end
  // end

  // // STIMULUS ARGS
  // initial
  // begin
  //   if(! $value$plusargs("inputs=%b", inputs)) begin
  //     $display("ERROR: please specify +inputs=<value> to start.");
  //     $finish;
  //   end

  //   wait (outs) $display("outs = %d", outs);
  //   #1
  //   $finish;
  // end

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  wire [OUTPUT_SIZE-1:0] probe;

  // DEVICE/DESIGN UNDER TEST
  chronometer #(
      .FREQ_IN(12e6),
      .LIMIT_CNT(LIMIT_CNT),
      .UNITS(1)  // 0 -> mS, 1 -> uS, 2 -> nS
  ) dut (
      .clk(clk),
      .start(start),
      .enable(enable),
      .timer(probe)
  );

  // MONITOR
  // initial $monitor("Time: %t, out = %d", $time, probe);

  // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    $dumpvars(0, chronometer_tb);
  end
endmodule
