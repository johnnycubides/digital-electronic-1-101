/* `include "./halfadder.v" */
module fulladder (
  // Inputs and output ports; 3 in, 2 out
  input in_b, in_a, in_ci,
  output out_co, out_s
);


// Declaración de señales
wire s_s1_to_b_s2; // Un cable del s del sumador 1 al a del sumador2
wire co_s1_to_or; // Un cable desde co del sumador 1 a la compuerta or
wire co_s2_to_or; // Un cable desde co del sumador 2 a la compuerta or

// Declaración de submodules
// halfadder(b,a,co,s)
halfadder halfadder1(in_b, in_a, co_s1_to_or, s_s1_to_b_s2);
halfadder halfadder2(s_s1_to_b_s2, in_ci, co_s2_to_or, out_s);

// Descripción del comportamiento
assign out_co = co_s1_to_or | co_s2_to_or; // co_s1 or co_s2
endmodule

// Declaración del módulo
module halfadder (
  input b, a,
  output co, s
);

// Declaración de señales
// ...

// Descripción del comportamiento
assign s = a ^ b; // s = a xor b
assign co = a & b; // a and b

endmodule
