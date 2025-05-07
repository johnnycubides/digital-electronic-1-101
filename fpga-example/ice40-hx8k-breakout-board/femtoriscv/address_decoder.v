module address_decoder (
    input [31:0] mem_addr,
    output reg [6:0] cs
);
  // ============== Chip_Select (Addres decoder) ========================
  // se hace con los 8 bits mas significativos de mem_addr
  // Se asigna el rango de la memoria de programa 0x00000000 - 0x003FFFFF
  // ====================================================================
  // reg [6:0] cs;  // CHIP-SELECT
  always @(*) begin
    case (mem_addr[31:16])  // direcciones - chip_select
      16'h0040: cs = 7'b0100000;  //uart
      16'h0041: cs = 7'b0010000;  //gpio
      16'h0042: cs = 7'b0001000;  //mult
      16'h0043: cs = 7'b0000100;  //div
      16'h0044: cs = 7'b0000010;  //bin_to_bcd
      16'h0045: cs = 7'b1000000;  //dpRAM
      default:  cs = 7'b0000001;  //RAM
    endcase
  end
endmodule
