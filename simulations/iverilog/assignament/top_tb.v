// `timescale 10ns/10ns // <time_unit>/<time_precision
// `include "./top.v"
module top_tb;

  // Determinar el tamaño de los wire como de los estímulos
  // parameter integer INPUT_SIZE = 2;
  parameter integer OUTPUT_SIZE = 2;

  // // STIMULUS 1
  // reg [INPUT_SIZE-1:0] inputs;
  // initial
  // begin
  //   inputs = 0;
  //   #1 inputs = 1;
  //   #1 $finish(); // [stop(), $finish()]
  // end

  // // STIMULUS 2
  // reg [INPUT_SIZE-1:0] inputs;
  // inputs[2] inputs[1] inputs[1]
  // integer i;
  // initial
  // begin
  //   inputs = 0;
  //   for (i=0; i<2**INPUT_SIZE; i=i+1) // 2 elevado a la INPUT_SIZE , en el ejemplo 2^3 = 8 combinaciones
  //   begin
  //     inputs = i;
  //     #1;
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

  // CLOCK STIMULUS
  // Make a regular pulsing clock.
  reg clk = 0;
  always #1 clk = !clk;

  reg a = 0;
  always #4 a = !a;

  initial begin
    #10 $finish();  // [stop(), $finish()]
  end

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  wire [OUTPUT_SIZE-1:0] value;

  // DEVICE/DESIGN UNDER TEST
  top dut (
      .a  (a),
      .clk(clk),
      .z1 (value[1]),
      .z2 (value[0])
  );

  // // MONITOR
  // initial
  //   $monitor("Time: %t, a = %d => y = %d",
  //     $time, inputs[0], value);

  // // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    $dumpvars(0, top_tb);
  end
endmodule
