module Memory #(
    parameter ADDR_WIDTH = 12,                // 2^12 = 4096 words = 16KB
    parameter MEM_DEPTH  = (1 << ADDR_WIDTH)  // número de palabras de 32 bits
) (
    input             clk,
    input      [31:0] mem_addr,   // dirección byte-addressed
    output reg [31:0] mem_rdata,  // datos leídos
    input             mem_rstrb,  // solicitud de lectura
    input      [31:0] mem_wdata,  // datos a escribir
    input      [ 3:0] mem_wmask   // máscara de escritura por byte
);

  wire [ADDR_WIDTH-1:0] word_addr = mem_addr[ADDR_WIDTH+1:2];

  // Señales intermedias para RAM
  reg write_enable;
  reg [31:0] write_data;
  wire [31:0] read_data;

  // Generar datos a escribir con máscara (sin bucle for)
  always @(*) begin
    write_enable = |mem_wmask;
    write_data   = read_data;

    if (mem_wmask[0]) write_data[7:0] = mem_wdata[7:0];
    if (mem_wmask[1]) write_data[15:8] = mem_wdata[15:8];
    if (mem_wmask[2]) write_data[23:16] = mem_wdata[23:16];
    if (mem_wmask[3]) write_data[31:24] = mem_wdata[31:24];
  end

  // Conexión a RAM de doble puerto, usamos solo el puerto A
  dual_port_ram #(
      .mem_filename("firmware.hex")
  ) ram_inst (
      .clock(clk),
      .write_enable_A(write_enable),
      .write_enable_B(1'b0),
      .data_in_A(write_data),
      .data_in_B(32'b0),
      .address_A(word_addr),
      .address_B(12'b0),
      .data_out_A(read_data),
      .data_out_B()
  );

  // Lógica de lectura
  always @(posedge clk) begin
    if (mem_rstrb) mem_rdata <= read_data;
  end

endmodule
