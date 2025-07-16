module chip_select (
    input [31:0] mem_addr,
    input [31:0] chip0_dout,
    input [31:0] chip1_dout,
    input [31:0] chip2_dout,
    input [31:0] chip3_dout,
    input [31:0] chip4_dout,
    input [31:0] chip5_dout,
    input [31:0] chip6_dout,
    output reg [6:0] cs,
    output reg [31:0] mem_rdata
);

  localparam integer CHIP0ADDR = 16'h0040;
  localparam integer CHIP1ADDR = 16'h0041;
  localparam integer CHIP2ADDR = 16'h0042;
  localparam integer CHIP3ADDR = 16'h0043;
  localparam integer CHIP4ADDR = 16'h0044;
  localparam integer CHIP5ADRR = 16'h0045;

  localparam integer CHIP0CS = 7'b0000001;
  localparam integer CHIP1CS = 7'b0000010;
  localparam integer CHIP2CS = 7'b0000100;
  localparam integer CHIP3CS = 7'b0001000;
  localparam integer CHIP4CS = 7'b0010000;
  localparam integer CHIP5CS = 7'b0100000;
  localparam integer CHIP6CS = 7'b1000000;

  // ============== Chip_Select (Addres decoder) ========================
  // se hace con los 8 bits mas significativos de mem_addr
  // Se asigna el rango de la memoria de programa 0x00000000 - 0x003FFFFF
  // ====================================================================
  // reg [6:0] cs;  // CHIP-SELECT
  always @(*) begin
    case (mem_addr[31:16])  // direcciones - chip_select
      CHIP0ADDR: cs = CHIP0CS;  // RAM
      CHIP1ADDR: cs = CHIP1CS;  // xxx
      CHIP2ADDR: cs = CHIP2CS;  // xxx
      CHIP3ADDR: cs = CHIP3CS;  // mult
      CHIP4ADDR: cs = CHIP4CS;  // xxx
      CHIP5ADRR: cs = CHIP5CS;  // uart
      default:   cs = CHIP6CS;  // xxx
    endcase
  end

  // ============== MUX ========================  // se encarga de lecturas del RV32
  always @(*) begin
    case (cs)
      CHIP0CS: mem_rdata = chip0_dout;
      CHIP1CS: mem_rdata = chip1_dout;
      CHIP2CS: mem_rdata = chip2_dout;
      CHIP3CS: mem_rdata = chip3_dout;
      CHIP4CS: mem_rdata = chip4_dout;
      CHIP5CS: mem_rdata = chip5_dout;
      CHIP6CS: mem_rdata = chip6_dout;
      default: mem_rdata = 32'h66666666;
    endcase
  end
  // ============== MUX ========================  //

endmodule
