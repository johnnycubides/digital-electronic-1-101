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
`define TIME_UNIT 2
`endif
`include "./top.v"

module top_tb;
  // Determinar el tamaño de los wire como de los estímulos
  parameter integer INPUT_SIZE = 1;
  parameter integer OUTPUT_SIZE = 1;

  // // STIMULUS 1
  // reg [INPUT_SIZE-1:0] inputs;
  // initial begin
  //   inputs = 0;
  //   #(`TIME_UNIT * 1) inputs = 1;
  //   #(`TIME_UNIT * 1) $finish();  // [stop(), $finish()]
  // end

  // // Make a regular pulsing clock.
  // reg clk = 0;
  // always #(`TIME_UNIT) clk = !clk;
  //
  // // CLOCK STIMULUS
  // initial begin
  //   #(`TIME_UNIT * 32) $finish();  // [stop(), $finish()]
  // end

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

  // initial begin
  //   inputs = 0;
  //   #(`TIME_UNIT * 1) inputs = 1;
  //   #(`TIME_UNIT * 1) $finish();  // [stop(), $finish()]
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
  // wire [OUTPUT_SIZE-1:0] probe;

  reg clk = 0;
  reg rst;

  // Transmisor
  reg [7:0] tx_data;
  reg tx_start;
  wire tx;
  wire tx_busy;

  // Receptor
  reg rx;
  wire [7:0] rx_data;
  wire rx_ready;

  // Make a regular pulsing clock.
  always #(`TIME_UNIT) clk = !clk;

  initial begin
    rst = 0;
    tx_data = 8'd68;
    tx_start = 0;
    #(`TIME_UNIT * 1) tx_start = 1;
    #(`TIME_UNIT * 2) tx_start = 0;
    #(`TIME_UNIT * 24) tx_data = 8'd92;
    #(`TIME_UNIT * 10) tx_start = 1;  // Pasado 10 ticks tx_start = 1
    #(`TIME_UNIT * 2) tx_start = 0;
    #(`TIME_UNIT * 24) $finish();  // [stop(), $finish()]
  end

  // // CLOCK STIMULUS
  // initial begin
  //   #(`TIME_UNIT * 32) $finish();  // [stop(), $finish()]
  // end

  // DEVICE/DESIGN UNDER TEST
  top dut (
      .hclk(clk),
      .rst(rst),
      .rx(rx),
      .tx(tx),
      .tx_data(tx_data),
      .tx_start(tx_start),
      .tx_busy(tx_busy),
      .rx_data(rx_data),
      .rx_ready(rx_ready)
  );

  // MONITOR
  // initial $monitor("Time: %t, out = %d", $time, probe);

  // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    $dumpvars(0, top_tb);
  end
endmodule
