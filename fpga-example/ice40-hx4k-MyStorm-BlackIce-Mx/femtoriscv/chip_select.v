module chip_select (
    input [6:0] cs,
    // input  [31:0] mem_addr,
    // input  [31:0] mem_wdata,
    input [31:0] dpram_dout,
    input [31:0] uart_dout,
    input [31:0] gpio_dout,
    input [31:0] mult_dout,
    input [31:0] div_dout,
    input [31:0] bin2bcd_dout,
    input [31:0] RAM_rdata,
    output reg [31:0] mem_rdata
);

  // ============== MUX ========================  // se encarga de lecturas del RV32
  always @(*) begin
    case (cs)
      7'b1000000: mem_rdata = dpram_dout;
      7'b0100000: mem_rdata = uart_dout;
      7'b0010000: mem_rdata = gpio_dout;
      7'b0001000: mem_rdata = mult_dout;
      7'b0000100: mem_rdata = div_dout;
      7'b0000010: mem_rdata = bin2bcd_dout;
      7'b0000001: mem_rdata = RAM_rdata;
      default: mem_rdata = 32'h66666666;
    endcase
  end
  // ============== MUX ========================  //

endmodule

