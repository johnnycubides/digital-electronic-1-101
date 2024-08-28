`default_nettype none
`define WIDTH 16

`include "./alu.v"
`include "./decode.v"
`include "./stack2.v"

module j1a (
    // Inputs and output ports
    input wire clk,
    input wire resetq,

    output wire io_rd,
    output wire io_wr,
    output wire [15:0] mem_addr,
    output wire mem_wr,
    output wire [`WIDTH-1:0] dout,

    input wire [`WIDTH-1:0] io_din,

    output wire [12:0] code_addr,
    input  wire [15:0] instruction
);

  // Declaración de señales [reg, wire]
  reg [3:0] dataStackPointer, dataStackPointerNew;  // data stack pointer
  reg [`WIDTH-1:0] topOfDataStack, topOfDataStackNew;  // top of data stack
  reg dataStackWrite;  // data stack write
  reg [12:0] pc  /* verilator public_flat */, pcNew;  // program counter
  reg               returnStackWrite;  // return stack write
  wire [`WIDTH-1:0] returnStackWriteData;  // return stack write value
  reg               reboot = 1;

  assign mem_addr  = topOfDataStack[15:0];
  assign code_addr = pcNew;

  // The D and R stacks
  wire [`WIDTH-1:0] secondItemOfDataStack, topOfReturnStack;
  reg [1:0] dspI, rspI;
  stack2 #(
      .DEPTH(4'd15)
  ) dstack (
      .clk(clk),
      .rd(secondItemOfDataStack),
      .we(dataStackWrite),
      .wd(topOfDataStack),
      .delta(dspI)
  );
  stack2 #(
      .DEPTH(5'd17)
  ) rstack (
      .clk(clk),
      .rd(topOfReturnStack),
      .we(returnStackWrite),
      .wd(returnStackWriteData),
      .delta(rspI)
  );

  decode decode (
      .instruction(instruction),
      .topOfDataStack(topOfDataStack),
      .pc(pc),
      .reboot(reboot),
      .secondItemOfDataStack(secondItemOfDataStack),
      .dataStackPointer(dataStackPointer),
      .topOfReturnStack(topOfReturnStack),
      .mem_wr(mem_wr),
      .dout(dout),
      .io_wr(io_wr),
      .io_rd(io_rd),
      .returnStackWriteData(returnStackWriteData),
      .dataStackWrite(dataStackWrite),
      .dataStackPointerNew(dataStackPointerNew),
      .dspI(dspI),
      .returnStackWrite(returnStackWrite),
      .rspI(rspI),
      .pcNew(pcNew)
  );

  alu alu (
      .instruction(instruction),
      .pc(pc),
      .topOfDataStack(topOfDataStack),
      .secondItemOfDataStack(secondItemOfDataStack),
      .topOfReturnStack(topOfReturnStack),
      .io_din(io_din),
      .dataStackPointer(dataStackPointer),
      .topOfDataStackNew(topOfDataStackNew)
  );

  // Descripción del comportamiento
  always @(negedge resetq or posedge clk) begin
    if (!resetq) begin
      reboot <= 1'b1;
      {pc, dataStackPointer, topOfDataStack} <= 0;
    end else begin
      reboot <= 0;
      {pc, dataStackPointer, topOfDataStack} <= {pcNew, dataStackPointerNew, topOfDataStackNew};
    end
  end

endmodule
