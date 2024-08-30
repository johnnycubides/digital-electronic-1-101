`include "./top.v"
module top_tb;

  // Determinar el tamaño de los buses de comunicación como de los estímulos
  parameter INPUT_SIZE = 2;
  parameter OUTPUT_SIZE = 1;

  // STIMULUS 1
  /* reg a = 0, b = 0; */
  /* initial */
  /* begin */
  /*    # 17 a = 1, b = 1; */
  /*    # 11 a = 1, b = 0; */
  /*    # 29 a = 1, b = 1; */
  /*    # 11 a = 1, b = 0; */
  /*    # 100 $finish(); // [stop(), $finish()] */
  /* end */

  // STIMULUS 2
  reg [INPUT_SIZE-1:0] inputs;
  /* inputs[0] inputs[1] inputs[2] */
  integer i;
  initial begin
    /* inputs = 0; */
    for (
        i = 0; i < 2 ** INPUT_SIZE; i = i + 1
    )  // 2 elevado a la INPUT_SIZE
        begin
      inputs = i;
      #1;
    end
  end

  /* // CLOCK STIMULUS */
  /* Make a regular pulsing clock. */
  /* reg clk = 0; */
  /* always #5 clk = !clk; */

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  wire [OUTPUT_SIZE-1:0] outputs;

  // DEVICE/DESIGN UNDER TEST
  top dut (
      .a(inputs[1]),
      .b(inputs[0]),
      .c(outputs[0])
  );

  /* // MONITOR */
  /* initial */
  /*   $monitor("Time: %t, a = %d, b = %d => out = %d", */
  /*     $time, a, b, value); */

  // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    // $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);
  end


endmodule
