/**
 * Step 3: Display a led pattern "animation" stored in BRAM.
 * DONE*
 */

`default_nettype none
`include "../general/clockworks.v"
`include "./program_counter.v"
`include "./ram.v"

module top (
    input  CLK,        // system clock 
    input  RESET,      // reset button
    output [4:0] LEDS // system LEDs
);

  wire clk;    // internal clock
  wire resetn; // internal reset signal, goes low on reset
  wire [4:0] PC;

  Pc pc(.clk(clk), .resetn(resetn), .out(PC));

  Ram ram(.address(PC), .clk(clk), .data(LEDS));

   // Gearbox and reset circuitry.
   Clockworks #(
     .SLOW(5'd19) // Divide clock frequency by 2^21
   )CW(
     .CLK(CLK),
     .RESET(RESET),
     .clk(clk),
     .resetn(resetn)
   );
   
endmodule
