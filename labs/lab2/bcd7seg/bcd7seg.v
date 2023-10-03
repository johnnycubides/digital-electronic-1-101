module bcd7seg (
// Inputs and output ports
  input a,
  input c,
  output b
);

// Declaración de señales [reg, wire]
assign b = a|c;
// Descripción del comportamiento

endmodule
