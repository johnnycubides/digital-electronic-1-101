module Memory (
    input             clk,
    input      [31:0] mem_addr,   // address to be read
    output reg [31:0] mem_rdata,  // data read from memory
    input             mem_rstrb,  // goes high when processor wants to read
    input      [31:0] mem_wdata,  // data to be written
    input      [ 3:0] mem_wmask   // masks for writing the 4 bytes (1=write byte)
);

  // Modificar .equ IO_HW_CONFIG_RAM, 8192  (2048 palabras de 32 bits = 2048 * 4 bytes) en libfemtorv/include/HardwareConfig_bits.inc
  reg [31:0] MEM[0:2047];

  initial begin
    $readmemh("./firmware.hex", MEM);
  end

  wire [29:0] word_addr = mem_addr[31:2];

  always @(posedge clk) begin
    if (mem_rstrb) begin
      mem_rdata <= MEM[word_addr];
    end
    if (mem_wmask[0]) MEM[word_addr][7:0] <= mem_wdata[7:0];
    if (mem_wmask[1]) MEM[word_addr][15:8] <= mem_wdata[15:8];
    if (mem_wmask[2]) MEM[word_addr][23:16] <= mem_wdata[23:16];
    if (mem_wmask[3]) MEM[word_addr][31:24] <= mem_wdata[31:24];
  end
endmodule
