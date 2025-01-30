`ifndef INIT
`define INIT 24'd0
`endif
module blink (
    input  clk,
    output led
);

  reg [24:0] count = `INIT;

  assign led = count[24];

  always @(posedge clk) count <= count + 1;

endmodule
