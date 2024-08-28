`default_nettype none
`define WIDTH 16

module alu (
    input wire [15:0] instruction,
    input wire [12:0] pc,
    input wire [`WIDTH-1:0] topOfDataStack,
    input wire [`WIDTH-1:0] secondItemOfDataStack,
    input wire [`WIDTH-1:0] topOfReturnStack,
    input wire [`WIDTH-1:0] io_din,
    input wire [3:0] dataStackPointer,
    output wire [`WIDTH-1:0] topOfDataStackNew
);

  // Declaración de señales [reg, wire]
  wire [16:0] minus = {1'b1, ~topOfDataStack} + secondItemOfDataStack + 1;
  wire signedless =
    topOfDataStack[15] ^ secondItemOfDataStack[15] ? secondItemOfDataStack[15] : minus[16];

  // Descripción del comportamiento
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

endmodule
