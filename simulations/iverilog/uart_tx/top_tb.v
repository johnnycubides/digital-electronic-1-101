// TEST BENCH

// En este testbech se simula el CLOCK requerido para transmitir
// información a 9600 baudios, como también el valor en el registro
// del dato a enviar, es importante ir a la sección de CLOCK STIMULUS
// para que pueda comprender los criterios para que la simulación
// sea coherente en la escala de tiempo real.
//
// Author: johnny Cubides
// 2023-11-21

`timescale 1us / 10ns  // <time_unit>/<time_precision>
// `include "./top.v"
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
  // Como 9600 baudios requiere una frecuencia de 9600 Hz * 2
  // Entonces: Frecuencia requerida 19200 Hz
  // Por tanto cada TICK es de 1/19200 = 52.083 uS
  // Cada TICK será de 52.083 y se configura la escala de tiempo 1us con una
  // precisión de 10ns
  parameter TICK = 52.083;
  reg clk = 0;
  always #TICK clk = !clk;

  reg [7:0] byte2send = 0;
  reg tx_start = 0;
  initial begin
    #TICK byte2send = 8'b10011010;
    tx_start = 1;
    #TICK tx_start = 0;
    #(60 * TICK) $finish();  // [stop(), $finish()]
  end

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  // wire [OUTPUT_SIZE-1:0] value;
  wire tx_done;
  wire tx_pin;

  // DEVICE/DESIGN UNDER TEST
  top dut (
      clk,
      byte2send,
      tx_start,
      tx_done,
      tx_pin
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
