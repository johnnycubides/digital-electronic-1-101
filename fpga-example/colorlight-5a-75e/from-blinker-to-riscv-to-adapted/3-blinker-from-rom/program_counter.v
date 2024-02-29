module Pc (
  // Inputs and output ports
  input wire clk,
  input wire resetn,
  output reg [4:0] out
);

// Declaración de señales [reg, wire]

// Descripción del comportamiento
  always @(posedge clk) begin
    out <= (!resetn || out==20) ? 0 : (out+1);
  end

endmodule
