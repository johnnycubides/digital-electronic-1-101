`include "./i2c_master.v"
`include "./control.v"

module top (
    input  wire hwclk,
    inout  wire sda_pin,
    output wire scl_pin,
    output wire busy_led,
    output wire led4,
    output wire led3,
    output wire led2,
    output wire led1
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
      .start(i2c_start),
      .addr(i2c_slave_addr),
      .rw(i2c_rw),  // r = 1, w = 0
      .data_in(i2c_data_in),
      .data_out(i2c_data_out),
      .scl(scl_pin),
      .sda(sda_pin),
      .test4(led4),
      .test3(led3),
      .test2(led2),
      .test1(led1),
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
