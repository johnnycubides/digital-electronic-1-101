`timescale 10ns/10ns
module testbech;
  /* // Determinar el tamaño de los wire como de los estímulos */
  /* parameter INPUT_SIZE = 3; */
  parameter OUTPUT_SIZE = 1;

  /* // STIMULUS 1 */
  /* reg a = 0, b = 0; */
  /* initial */
  /* begin */
  /*    # 17 a = 1, b = 1; */
  /*    # 11 a = 1, b = 0; */
  /*    # 29 a = 1, b = 1; */
  /*    # 11 a = 1, b = 0; */
  /*    # 100 $finish(); // [stop(), $finish()] */
  /* end */

  /* // STIMULUS 2 */
  /* reg [INPUT_SIZE-1:0] inputs; */
  /* /1* inputs[2] inputs[1] inputs[1] *1/ */
  /* integer i; */
  /* initial */
  /* begin */
  /*   /1* inputs = 0; *1/ */
  /*   for (i=0; i<2**INPUT_SIZE; i=i+1) // 2 elevado a la INPUT_SIZE , en el ejemplo 2^3 = 8 combinaciones*/
  /*   begin */
  /*     inputs = i; */
  /*     #1; */
  /*   end */
  /* end */

  // CLOCK STIMULUS
  // Make a regular pulsing clock.
  reg clk = 0;
  always #2 clk = !clk;

  initial
  begin
    #1.01E8 $finish(); // [stop(), $finish()]
  end

  /* // RESULT FOR DEVICE/DESIGN UNDER TEST */
  wire [OUTPUT_SIZE-1:0] value;

  // DEVICE/DESIGN UNDER TEST
  top dut (.clk(clk), .led(value[0]));

  // MONITOR
  initial
    $monitor("Time: %t, out = %d",
      $time, value[0]);

  // WAVES IN VCD TO OPEN IN GTKWAVE
  initial
  begin
    $dumpfile("top.vcd");
    $dumpvars(0, testbech);
  end


endmodule
