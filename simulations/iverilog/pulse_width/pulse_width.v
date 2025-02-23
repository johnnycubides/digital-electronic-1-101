// filename: ./pulse.v
// brief: A pulse with width selection

module pulse_width #(
    parameter integer FREQ_IN = 12e6,  // 12 Mhz frecuencia de entrada
    parameter real WIDTH_PULSE = 10e-6,  // 10 uS ancho del pulso
    parameter integer INIT = 0
) (
    // Inputs and output ports
    input clk,
    input start,
    output reg signal,
    output busy
);

  localparam integer COUNT = (FREQ_IN / (1 / WIDTH_PULSE));
  localparam integer SIZE = $clog2(COUNT);
  localparam integer LIMIT = COUNT - 1;

  initial begin
    signal = 0;
  end

  // Declaración de señales [reg, wire]
  reg [SIZE-1:0] cnt = INIT;

  // Descripción del comportamiento
  always @(posedge clk) begin
    if (start) begin
      cnt <= 0;
      signal <= 1;
    end else if (cnt == LIMIT) begin
      signal <= 0;
    end else begin
      cnt <= cnt + 1;
    end
  end

  assign busy = signal;

endmodule
