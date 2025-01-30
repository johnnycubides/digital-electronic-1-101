// `timescale 1ns/1ns // <time_unit>/<time_precision
`include "top.v"
module top_tb;

  // Determinar el tamaño de los wire como de los estímulos
  // parameter INPUT_SIZE = 1;
  // parameter OUTPUT_SIZE = 1;

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

  // reg [7:0] byte2send = 0;
  // reg tx_start = 0;
  initial begin
    // #1
    // byte2send = 8'b10011010;
    // tx_start = 1;
    // #1
    // tx_start = 0;
    #200000 $finish();  // [stop(), $finish()]
  end

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  // wire [OUTPUT_SIZE-1:0] value;
  wire busyLed;
  wire tx_pin;
  wire test_pin;

  // DEVICE/DESIGN UNDER TEST
  top #(
      .SIZE_COUNTER (4),
      .LIMIT_COUNTER(15)
  ) dut (
      .clk_hw  (clk),
      .busyLed (busyLed),
      .test_pin(test_pin),
      .tx_pin  (tx_pin)
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
