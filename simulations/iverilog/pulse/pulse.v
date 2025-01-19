module pulse 
#(
  parameter integer FREQ_IN = 1000,
  parameter integer FREQ_OUT = 100
)(
  // Inputs and output ports
  input wire CLK_IN,
  output reg PULSE_OUT = 0
);

  localparam integer DIVIDER = FREQ_IN / FREQ_OUT;
  localparam integer SIZE_COUNTER = $clog2(DIVIDER);
  localparam integer COUNTER_LIMIT = DIVIDER -1;

  // Declaración de señales [reg, wire]
  reg [SIZE_COUNTER-1:0] counter = 0;

  // Descripción del comportamiento
  always @(posedge CLK_IN) begin
    if(counter == COUNTER_LIMIT) begin 
      counter <= 0;
      PULSE_OUT <= 1;
    end else begin
      counter <= counter + 1;
      PULSE_OUT <= 0;
    end
  end

endmodule
