`include "./counter8bits.v"
`timescale 1ms / 1ms

`ifndef SIZE
`define SIZE 8
`endif

// `timescale 10ns/10ns // <time_unit>/<time_precision
module counter8bits_tb;

  // // Determinar el tamaño de los wire como de los estímulos
  // parameter INPUT_SIZE = 3;
  localparam integer OutputSize = `SIZE;

  // // STIMULUS 1
  // reg a = 0, b = 0;
  // initial
  // begin
  //    # 17 a = 1; b = 1;
  //    # 11 a = 1; b = 0;
  //    # 29 a = 1; b = 1;
  //    # 11 a = 1; b = 0;
  //    # 100 $finish(); // [stop(), $finish()]
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
  localparam integer TICKS = 1;
  reg clk = 0;
  always #(TICKS) clk = !clk;

  initial begin
    #(2 * 257 * TICKS) $finish();  // [stop(), $finish()]
  end

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  wire [OutputSize-1:0] probe;

  // DEVICE/DESIGN UNDER TEST
  counter8bits dut (
      .clk  (clk),
      .count(probe)
  );

  // // MONITOR
  // initial
  // $monitor("Time: %t, a = %d, b = %d => out = %d",
  //   $time, a, b, value);

  // // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    $dumpvars(0, counter8bits_tb);
  end
endmodule
