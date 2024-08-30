`default_nettype none
`define WIDTH 16

module decode (
    // Inputs and output ports
    input wire [15:0] instruction,
    input wire [`WIDTH-1:0] topOfDataStack,
    input wire [12:0] pc,
    input wire reboot,
    input wire [`WIDTH-1:0] secondItemOfDataStack,
    input wire [3:0] dataStackPointer,
    input wire [`WIDTH-1:0] topOfReturnStack,
    output wire mem_wr,
    output wire [`WIDTH-1:0] dout,
    output wire io_wr,
    output wire io_rd,
    output wire [`WIDTH-1:0] returnStackWriteData,
    output wire dataStackWrite,
    output wire [3:0] dataStackPointerNew,
    output wire [1:0] dspI,
    output wire returnStackWrite,
    output wire [1:0] rspI,
    output wire [12:0] pcNew
);

  // Declaración de señales [reg, wire]
  wire func_T_N = (instruction[6:4] == 1);
  wire func_T_R = (instruction[6:4] == 2);
  wire func_write = (instruction[6:4] == 3);
  wire func_iow = (instruction[6:4] == 4);
  wire func_ior = (instruction[6:4] == 5);

  wire is_alu = !pc[12] & (instruction[15:13] == 3'b011);
  assign mem_wr = !reboot & is_alu & func_write;
  assign dout   = secondItemOfDataStack;
  assign io_wr  = !reboot & is_alu & func_iow;
  assign io_rd  = !reboot & is_alu & func_ior;

  wire [12:0] pc_plus_1 = pc + 13'd1;

  assign returnStackWriteData  =
    (instruction[13] == 1'b0) ?
    {{(`WIDTH - 14) {1'b0}}, pc_plus_1, 1'b0} : topOfDataStack;

  // Descripción del comportamiento
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

endmodule
