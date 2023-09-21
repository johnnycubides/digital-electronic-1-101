module top(input clk, output [7:0] leds);

wire clk2;

clk10hz clock(.clk_in(clk), .clk_out(clk2));
counter8bits counter(.clk(clk2), .count(leds));

endmodule
