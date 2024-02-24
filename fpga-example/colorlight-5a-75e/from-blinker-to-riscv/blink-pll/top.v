/**
 * Step 2: Blinker (slower version)
 * DONE*
 */

`default_nettype none
`include "clockworks.v"
`include "divider.v"

module top (
    input  CLK,        // system clock 
    input  RESET,      // reset button
    output [4:0] LEDS, // system LEDs
    input  RXD,        // UART receive
    output TXD         // UART transmit
);

  wire clk;    // internal clock
  wire resetn; // internal reset signal, goes low on reset

  assign LEDS[0] = 1'b0;
  assign LEDS[1] = 1'b0;
  assign LEDS[2] = 1'b0;
  assign LEDS[3] = 1'b0;

  // A blinker that counts on 5 bits, wired to the 5 LEDs
  // reg [4:0] count = 0;
  // always @(posedge clk) begin
  //   count <= !resetn ? 0 : count + 1;
  // end

  // Clock gearbox (to let you see what happens)
  // and reset circuitry (to workaround an
  // initialization problem with Ice40)
  // Clockworks #(
  //   .SLOW(21) // Divide clock frequency by 2^21
  // )CW(
  //   .CLK(CLK),
  //   .RESET(RESET),
  //   .clk(clk),
  //   .resetn(resetn)
  // );
  //

  clockworks clkw(.clki(CLK), .clko(clk));

  divider #(.SLOW(5'd22)) div(.clkin(clk), .clkout(LEDS[4]));

  // assign LEDS = count;
  assign TXD  = 1'b0; // not used for now   

  // femtoPLL #(.freq(40)) pll(.pclk(CLK), .clk(clko));

endmodule
