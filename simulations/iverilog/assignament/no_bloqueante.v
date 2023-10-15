module no_bloqueante (
  // Inputs and output ports
  input a, clk,
  output reg z1
);

// Declaración de señales [reg, wire]
reg q1;

// Descripción del comportamiento
// La asignación NO Bloqueante modela las escrituras de flip-flops
// Se calcula primero los valores de la derecha de todas las asignaciones,
// tras lo anterior se asignan todas simultaneamente
// No importa el orden de las asignaciones no bloqueantes
always @ (posedge clk)
begin
  q1 <= a;
  z1 <= q1;
end

endmodule
