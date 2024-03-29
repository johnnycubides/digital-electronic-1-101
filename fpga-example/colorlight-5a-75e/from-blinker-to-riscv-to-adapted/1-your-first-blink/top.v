`default_nettype none

module top (
  input  CLK,        // system clock 
  output [4:0] LEDS // system LEDs
);


  // A blinker that counts on 5 bits, wired to the 5 LEDs
  reg [4:0] count = 0;
  always @(posedge CLK) begin
    count <= count + 1;
  end
  assign LEDS = count;

endmodule
