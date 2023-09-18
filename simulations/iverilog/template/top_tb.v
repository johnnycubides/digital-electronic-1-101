// `timescale 10ns/10ns // <time_unit>/<time_precision
module testbech;

  // Determinar el tamaño de los wire como de los estímulos
  parameter INPUT_SIZE = 1;
  parameter OUTPUT_SIZE = 1;

  // // STIMULUS 1
  reg [INPUT_SIZE-1:0] inputs;
  initial
  begin
    inputs = 0;
    #1 inputs = 1;
    #1 $finish(); // [stop(), $finish()]
  end

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

  // // CLOCK STIMULUS
  // Make a regular pulsing clock.
  // reg clk = 0;
  // always #5 clk = !clk;

  // initial
  // begin
  //   #2E9 $finish(); // [stop(), $finish()]
  // end

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  wire [OUTPUT_SIZE-1:0] value;

  // DEVICE/DESIGN UNDER TEST
  top dut (.a(inputs[0]), .y(value[0]));

  // // MONITOR
  initial
    $monitor("Time: %t, a = %d => y = %d",
      $time, inputs[0], value);

  // // WAVES IN VCD TO OPEN IN GTKWAVE
  initial
  begin
    $dumpfile("top.vcd");
    $dumpvars(0, testbech);
  end
endmodule
