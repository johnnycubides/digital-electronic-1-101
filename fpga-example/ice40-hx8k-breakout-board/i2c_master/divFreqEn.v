// filename: divFreqEn.v
// Brief: este divisor de frecuencia no genera otros clocks
// Mitiga el impacto del uso de módulos SB_GB (Global Buffers)
module divFreqEn #(
    parameter integer FREQ_IN  = 1000,  // Frecuencia de entrada (en MHz, kHz, Hz, etc.)
    parameter integer FREQ_OUT = 100,   // Frecuencia de salida deseada (en MHz, kHz, Hz, etc.)
    parameter integer INIT     = 0      // Valor inicial del contador
) (
    // Inputs and output ports
    input      CLK_IN,     // Reloj de entrada
    input      RST,        // Reset (opcional, para reiniciar el contador)
    output reg ENABLE = 0  // Señal de habilitación
);

  // Cálculo del valor máximo del contador
  localparam integer COUNT = (FREQ_IN / FREQ_OUT);
  localparam integer SIZE = $clog2(COUNT);
  localparam integer LIMIT = COUNT - 1;

  // Declaración de señales [reg, wire]
  reg [SIZE-1:0] count = INIT;

  // Descripción del comportamiento
  always @(posedge CLK_IN or posedge RST) begin
    if (RST) begin
      count  <= INIT;  // Reinicia el contador si RST está activo
      ENABLE <= 0;  // Reinicia la señal de habilitación
    end else if (count == LIMIT) begin
      count  <= 0;  // Reinicia el contador cuando alcanza el límite
      ENABLE <= 1;  // Activa la señal de habilitación
    end else begin
      count  <= count + 1;  // Incrementa el contador
      ENABLE <= 0;  // Desactiva la señal de habilitación
    end
  end
endmodule

