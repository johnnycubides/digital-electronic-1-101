`include "./i2c_master.v"
`include "./control.v"

module top (
    input  wire hwclk,
    inout  wire sda_pin,
    inout  wire scl_pin,
    output wire busy_led,
    inout  wire D9,
    output wire D5,
    output wire D4,
    output wire D3,
    output wire D2
);

  wire rst = 1'b0;
  wire i2c_start, i2c_rw, i2c_busy;
  wire [6:0] i2c_slave_addr;
  wire [7:0] i2c_data_in, i2c_data_out;

  assign busy_led = i2c_busy;

  i2c_master #(
      .FREQ_IN (12e6),
      .FREQ_OUT(1)
  ) master (
      .clk(hwclk),
      .reset(rst),
      .startTask(i2c_start),
      .addr(i2c_slave_addr),
      .rw(i2c_rw),  // r = 1, w = 0
      .data_in(i2c_data_in),
      .data_out(i2c_data_out),
      .scl(scl_pin),
      .sda(sda_pin),
      .probe(D9),
      .D5(D5),
      .D4(D4),
      .D3(D3),
      .D2(D2),
      .busy(i2c_busy)
  );

  control control (
      .clk(hwclk),
      .i2c_busy(i2c_busy),
      .receivedData(i2c_data_out),
      .i2c_start(i2c_start),
      .i2c_slave_addr(i2c_slave_addr),
      .i2c_rw(i2c_rw),
      .data2send(i2c_data_in)
  );

endmodule
