`timescale 10ns / 10ns  // <time_unit>/<time_precision
`include "./top.v"

module top_tb;

  // // Determinar el tamaño de los wire como de los estímulos
  // parameter INPUT_SIZE = 3;
  // parameter OUTPUT_SIZE = 1;

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
  reg clk2 = 0;
  always #5 clk2 = !clk2;

  initial begin
    #160 $finish();  // [stop(), $finish()]
  end

  // // RESULT FOR DEVICE/DESIGN UNDER TEST
  // wire [OUTPUT_SIZE-1:0] value;

  // // DEVICE/DESIGN UNDER TEST
  // top dut (.a(inputs[1]), .b(inputs[0]), .c(value[0]));
  //
  // wire [7:0] runner;
  wire [7:0] leds;

  // counter8bits counter (
  //     .clk  (clk2),
  //     .count(runner)
  // );

  // reg write_enable_A = 0;
  // reg write_enable_B = 0;
  // reg [7:0] data_in_A = 0;
  // reg [7:0] data_in_B = 0;
  // reg [7:0] address_A;
  // reg [7:0] address_B = 0;
  // wire [7:0] data_out_A;
  // wire [7:0] data_out_B;

  // dual_port_ram #("./file.hex") dut (
  // dual_port_ram ram0 (
  //     .clock(clk2),
  //     .write_enable_A(write_enable_A),
  //     .write_enable_B(write_enable_B),
  //     .data_in_A(data_in_A),
  //     .data_in_B(data_in_B),
  //     .address_A({4'b0000, runner[3:0]}),
  //     .address_B(address_B),
  //     .data_out_A(leds),
  //     .data_out_B(data_out_B)
  // );

  top dut (
      .clk (clk2),
      .leds(leds)
  );

  // // MONITOR
  // initial
  // $monitor("Time: %t, a = %d, b = %d => out = %d",
  //   $time, a, b, value);

  // // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    $dumpvars(0, top_tb);
  end
endmodule
