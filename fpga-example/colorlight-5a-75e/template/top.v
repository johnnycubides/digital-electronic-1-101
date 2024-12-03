module top (
    // Inputs and output ports
    input  a,
    output y
);

  // Declaración de señales [reg, wire]

  // Descripción del comportamiento
  assign y = ~a;

endmodule
