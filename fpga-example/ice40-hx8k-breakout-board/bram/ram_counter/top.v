// `include "./clk10hz.v"
// `include "./counter8bits.v"
// `include "./dual_port_ram.v"

module top (
    input clk,
    output [7:0] leds
);

  wire clk2;
  wire [7:0] runner;

`ifndef SIM
  clk10hz clock (
      .clk_in (clk),
      .clk_out(clk2)
  );
`else
  assign clk2 = clk;
`endif
  counter8bits counter (
      .clk  (clk2),
      .count(runner)
  );

  reg write_enable_A = 0;
  reg write_enable_B = 0;
  reg [7:0] data_in_A = 0;
  reg [7:0] data_in_B = 0;
  // reg [7:0] address_A;
  reg [7:0] address_B = 0;
  // wire [7:0] data_out_A;
  wire [7:0] data_out_B;

  // dual_port_ram #("./file.hex") dut (
  dual_port_ram ram0 (
      .clock(clk2),
      .write_enable_A(write_enable_A),
      .write_enable_B(write_enable_B),
      .data_in_A(data_in_A),
      .data_in_B(data_in_B),
      .address_A({4'b0000, runner[3:0]}),
      .address_B(address_B),
      .data_out_A(leds),
      .data_out_B(data_out_B)
  );

endmodule
