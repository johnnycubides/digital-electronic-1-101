module top (
    input clk,
    output [3:0] leds
);

  localparam integer N = 26;
  reg [N:0] counter = 0;

  assign leds = {~counter[N], ~counter[N-1], ~counter[N-2], ~counter[N-3]};

  always @(posedge clk) begin
    counter <= counter + 1;
  end
endmodule
