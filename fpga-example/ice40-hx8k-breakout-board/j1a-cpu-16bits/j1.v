`default_nettype none
`define WIDTH 16

module j1 (
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

  reg [3:0] dataStackPointer, dataStackPointerNew;  // data stack pointer
  reg [`WIDTH-1:0] topOfDataStack, topOfDataStackNew;  // top of data stack
  reg dataStackWrite;  // data stack write

  reg [12:0] pc  /* verilator public_flat */, pcNew;  // program counter
  wire [      12:0] pc_plus_1 = pc + 13'd1;
  reg               returnStackWrite;  // return stack write
  wire [`WIDTH-1:0] returnStackWriteData;  // return stack write value
  reg               reboot = 1;

  assign mem_addr  = topOfDataStack[15:0];
  assign code_addr = pcNew;

  // The D and R stacks
  wire [`WIDTH-1:0] secondItemOfDataStack, topOfReturnStack;
  reg [1:0] dspI, rspI;
  stack2 #(
      .DEPTH(15)
  ) dstack (
      .clk(clk),
      .rd(secondItemOfDataStack),
      .we(dataStackWrite),
      .wd(topOfDataStack),
      .delta(dspI)
  );
  stack2 #(
      .DEPTH(17)
  ) rstack (
      .clk(clk),
      .rd(topOfReturnStack),
      .we(returnStackWrite),
      .wd(returnStackWriteData),
      .delta(rspI)
  );

  wire [16:0] minus = {1'b1, ~topOfDataStack} + secondItemOfDataStack + 1;
  wire signedless =
    topOfDataStack[15] ^ secondItemOfDataStack[15] ? secondItemOfDataStack[15] : minus[16];

  always @* begin
    // Compute the new value of st0
    casez ({
      pc[12], instruction[15:8]
    })
      9'b1_???_?????: topOfDataStackNew = instruction;  // literal
      9'b0_1??_?????: topOfDataStackNew = {{(`WIDTH - 15) {1'b0}}, instruction[14:0]};  // literal
      9'b0_000_?????: topOfDataStackNew = topOfDataStack;  // jump
      9'b0_010_?????: topOfDataStackNew = topOfDataStack;  // call
      9'b0_001_?????: topOfDataStackNew = secondItemOfDataStack;  // conditional jump
      9'b0_011_?0000: topOfDataStackNew = topOfDataStack;  // ALU operations...
      9'b0_011_?0001: topOfDataStackNew = secondItemOfDataStack;
      9'b0_011_?0010: topOfDataStackNew = topOfDataStack + secondItemOfDataStack;
      9'b0_011_?0011: topOfDataStackNew = topOfDataStack & secondItemOfDataStack;
      9'b0_011_?0100: topOfDataStackNew = topOfDataStack | secondItemOfDataStack;
      9'b0_011_?0101: topOfDataStackNew = topOfDataStack ^ secondItemOfDataStack;
      9'b0_011_?0110: topOfDataStackNew = ~topOfDataStack;

      9'b0_011_?0111: topOfDataStackNew = {`WIDTH{(minus == 0)}};  //  =
      9'b0_011_?1000: topOfDataStackNew = {`WIDTH{(signedless)}};  //  <

      9'b0_011_?1001: topOfDataStackNew = {topOfDataStack[`WIDTH-1], topOfDataStack[`WIDTH-1:1]};
      9'b0_011_?1010: topOfDataStackNew = {topOfDataStack[`WIDTH-2:0], 1'b0};
      9'b0_011_?1011: topOfDataStackNew = topOfReturnStack;
      9'b0_011_?1100: topOfDataStackNew = minus[15:0];
      9'b0_011_?1101: topOfDataStackNew = io_din;
      9'b0_011_?1110: topOfDataStackNew = {{(`WIDTH - 4) {1'b0}}, dataStackPointer};
      9'b0_011_?1111: topOfDataStackNew = {`WIDTH{(minus[16])}};  // u<
      default:        topOfDataStackNew = {`WIDTH{1'bx}};
    endcase
  end

  wire func_T_N = (instruction[6:4] == 1);
  wire func_T_R = (instruction[6:4] == 2);
  wire func_write = (instruction[6:4] == 3);
  wire func_iow = (instruction[6:4] == 4);
  wire func_ior = (instruction[6:4] == 5);

  wire is_alu = !pc[12] & (instruction[15:13] == 3'b011);
  assign mem_wr = !reboot & is_alu & func_write;
  assign dout = secondItemOfDataStack;
  assign io_wr = !reboot & is_alu & func_iow;
  assign io_rd = !reboot & is_alu & func_ior;

  assign returnStackWriteData  =
    (instruction[13] == 1'b0) ?
    {{(`WIDTH - 14) {1'b0}}, pc_plus_1, 1'b0} : topOfDataStack;

  always @* begin
    casez ({
      pc[12], instruction[15:13]
    })
      4'b1_???, 4'b0_1??: {dataStackWrite, dspI} = {1'b1, 2'b01};
      4'b0_001:           {dataStackWrite, dspI} = {1'b0, 2'b11};
      4'b0_011:           {dataStackWrite, dspI} = {func_T_N, {instruction[1:0]}};
      default:            {dataStackWrite, dspI} = {1'b0, 2'b00};
    endcase
    dataStackPointerNew = dataStackPointer + {dspI[1], dspI[1], dspI};

    casez ({
      pc[12], instruction[15:13]
    })
      4'b1_???: {returnStackWrite, rspI} = {1'b0, 2'b11};
      4'b0_010: {returnStackWrite, rspI} = {1'b1, 2'b01};
      4'b0_011: {returnStackWrite, rspI} = {func_T_R, instruction[3:2]};
      default:  {returnStackWrite, rspI} = {1'b0, 2'b00};
    endcase

    // Decode PC
    casez ({
      reboot, pc[12], instruction[15:13], instruction[7], |topOfDataStack
    })
      7'b1_0_???_?_?:                                 pcNew = 0;
      7'b0_0_000_?_?, 7'b0_0_010_?_?, 7'b0_0_001_?_0: pcNew = instruction[12:0];
      7'b0_1_???_?_?, 7'b0_0_011_1_?:                 pcNew = topOfReturnStack[13:1];
      default:                                        pcNew = pc_plus_1;
    endcase
  end

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
