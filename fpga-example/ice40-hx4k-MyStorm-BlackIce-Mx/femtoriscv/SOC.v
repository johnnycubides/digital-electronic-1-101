module SOC (
    input             clk,     // system clock
    input             resetn,  // reset button
    output wire [0:0] LEDS,    // system LEDs
    input             RXD,     // UART receive
    output            TXD      // UART transmit
);

  //##########################
  //### DESCRIPCIÓN DE CPU ###
  //##########################
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

  //#################################
  //### DESCRIPCIÓN DE CHIPSELECT ###
  //#################################
  wire [6:0] cs;
  wire cs_uart = cs[0];  // cs_chip0
  wire cs_chip1 = cs[1];  // cs_chip1
  wire cs_mult = cs[2];  // cs_chip2
  wire cs_chip3 = cs[3];  // cs_chip3
  wire cs_chip4 = cs[4];  // cs_chip4
  wire cs_chip5 = cs[5];  // cs_chip5
  wire cs_ram = cs[6];  // cs_chip6
  chip_select chip_select (
      .mem_addr(mem_addr),
      .chip0_dout(uart_dout),  // 0x00400000
      .chip1_dout(),  // 0x00410000
      .chip2_dout(mult_dout),  // 0x00420000
      .chip3_dout(),  // 0x00430000
      .chip4_dout(),  // 0x00440000
      .chip5_dout(),  // 0x00450000
      .chip6_dout(RAM_rdata),  // default
      .cs(cs),
      .mem_rdata(mem_rdata)
  );

  //##########################
  //### DESCRIPCIÓN DE RAM ###
  //##########################
  wire [31:0] RAM_rdata;
  wire wr = |mem_wmask;
  wire rd = mem_rstrb;
  Memory RAM (
      .clk(clk),
      .mem_addr(mem_addr),
      .mem_rdata(RAM_rdata),
      .mem_rstrb(cs_ram & rd),
      .mem_wdata(mem_wdata),
      .mem_wmask({4{cs_ram}} & mem_wmask)
  );

  //######################################
  //### DESCRIPCIÓN DE PERIFERICO UART ###
  //######################################
  wire [31:0] uart_dout;
  peripheral_uart #(
      .clk_freq(25000000),
      .baud    (57600)
  ) per_uart (
      .clk(clk),
      .rst(!resetn),
      .d_in(mem_wdata),
      .cs(cs_uart),
      .addr(mem_addr),
      .rd(rd),
      .wr(wr),
      .d_out(uart_dout),
      .uart_tx(TXD),
      .uart_rx(RXD),
      .ledout(LEDS[0])
  );

  //######################################
  //### DESCRIPCIÓN DE PERIFERICO MULT ###
  //######################################
  wire [31:0] mult_dout;
  peripheral_mult mult1 (
      .clk(clk),
      .reset(!resetn),
      .d_in(mem_wdata),
      .cs(cs_mult),
      .addr(mem_addr),
      .rd(rd),
      .wr(wr),
      .d_out(mult_dout)
  );

  //######################################
  //### DESCRIPCIÓN DE PERIFERICO DPRAM ###
  //######################################
  // wire [31:0] dpram_dout;
  //
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

`ifdef BENCH
  always @(posedge clk) begin
    if (cs[5] & wr) begin
      $write("%c", mem_wdata[7:0]);
      $fflush(32'h8000_0001);
    end
  end
`endif

endmodule
