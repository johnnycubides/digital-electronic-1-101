module pulse #(
    parameter integer FREQ_IN  = 1000,
    parameter integer FREQ_OUT = 100
) (
    // Inputs and output ports
    input  wire CLK_IN,
    input  wire WIDTH_STOP,
    output reg  PULSE_OUT = 0
);

  localparam integer DIVIDER = FREQ_IN / FREQ_OUT;
  localparam integer SizeCounter = $clog2(DIVIDER);
  localparam integer CounterLimit = DIVIDER - 1;

  // Declaración de señales [reg, wire]
  reg [SizeCounter-1:0] counter = 0;

  // Descripción del comportamiento
  always @(posedge CLK_IN) begin
    if (counter == CounterLimit) begin
      counter   <= 0;
      PULSE_OUT <= 1;
    end else begin
      counter <= counter + 1;
      if (WIDTH_STOP) begin  // Ancho del pulso en alto
        PULSE_OUT <= 0;
      end
    end
  end

endmodule
