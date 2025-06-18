module SOC (
    input             clk,     // system clock
    input             resetn,  // reset button
    output wire [0:0] LEDS,    // system LEDs
    input             RXD,     // UART receive
    output            TXD      // UART transmit
);
  wire [31:0] mem_addr;
  wire [31:0] mem_rdata;
  wire mem_rstrb;
  wire [31:0] mem_wdata;
  wire [3:0] mem_wmask;

  FemtoRV32 CPU (
      .clk(clk),
      .reset(resetn),
      .mem_addr(mem_addr),
      .mem_rdata(mem_rdata),
      .mem_rstrb(mem_rstrb),
      .mem_wdata(mem_wdata),
      .mem_wmask(mem_wmask),
      .mem_rbusy(1'b0),
      .mem_wbusy(1'b0)
  );
  wire [31:0] RAM_rdata;
  wire wr = |mem_wmask;
  wire rd = mem_rstrb;

  Memory RAM (
      .clk(clk),
      .mem_addr(mem_addr),
      .mem_rdata(RAM_rdata),
      .mem_rstrb(cs[0] & rd),
      .mem_wdata(mem_wdata),
      .mem_wmask({4{cs[0]}} & mem_wmask)
  );

  wire [31:0] uart_dout;
  wire [31:0] gpio_dout;
  wire [31:0] mult_dout;
  wire [31:0] div_dout;
  wire [31:0] bin2bcd_dout;
  wire [31:0] dpram_dout;

  peripheral_uart #(
      .clk_freq(25000000),  // 27000000 for gowin
      .baud    (57600)      // 57600 for gowin
  ) per_uart (
      .clk(clk),
      .rst(!resetn),
      .d_in(mem_wdata),
      .cs(cs[5]),
      .addr(mem_addr[4:0]),
      .rd(rd),
      .wr(wr),
      .d_out(uart_dout),
      .uart_tx(TXD),
      .uart_rx(RXD),
      .ledout(LEDS[0])
  );

  peripheral_mult mult1 (
      .clk(clk),
      .reset(!resetn),
      .d_in(mem_wdata[15:0]),
      .cs(cs[3]),
      .addr(mem_addr[4:0]),
      .rd(rd),
      .wr(wr),
      .d_out(mult_dout)
  );

  // peripheral_dpram dpram_p0 (
  //     .clk(clk),
  //     .reset(!resetn),
  //     .d_in(mem_wdata[15:0]),
  //     .cs(cs[6]),
  //     .addr(mem_addr[15:0]),
  //     .rd(rd),
  //     .wr(wr),
  //     .d_out(dpram_dout)
  // );

  wire [6:0] cs;
  address_decoder address_decoder (
      .mem_addr(mem_addr),
      .cs(cs)
  );

  chip_select chip_select (
      .cs(cs),
      .dpram_dout(dpram_dout),
      .uart_dout(uart_dout),
      .gpio_dout(gpio_dout),
      .mult_dout(mult_dout),
      .div_dout(div_dout),
      .bin2bcd_dout(bin2bcd_dout),
      .RAM_rdata(RAM_rdata),
      .mem_rdata(mem_rdata)
  );

`ifdef BENCH
  always @(posedge clk) begin
    if (cs[5] & wr) begin
      $write("%c", mem_wdata[7:0]);
      $fflush(32'h8000_0001);
    end
  end
`endif

endmodule
