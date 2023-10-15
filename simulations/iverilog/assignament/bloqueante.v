module bloqueante (
  // Inputs and output ports
  input a, clk,
  output reg z2
);

// Declaración de señales [reg, wire]
reg q2;

// Descripción del comportamiento
// Si en este proceso se desea que la salida cambie inmediatamente,
// se debe utilizar una asignación bloqueante =
// Modela una salida combinacional
// Importa el orden en que se efectúa las asignaciones bloqueantes
// ya que en un proceso las acciones se ejecutan secuencialmente
always @ (posedge clk)
begin
  q2 = a;
  z2 = q2;
end

endmodule
