// filename: ./pulse.v
// brief: A pulse with width selection

module pulse #(
    parameter integer FREQ_IN = 1000,
    parameter integer WIDTH_PULSE = 100,
    parameter integer INIT = 0
) (
    // Inputs and output ports
    input  clk,
    input  start,
    output pulse
);

  localparam integer COUNT = (FREQ_IN / (1 / WIDTH_PULSE)) / 2;
  localparam integer SIZE = $clog2(COUNT);
  localparam integer LIMIT = COUNT - 1;

  reg [SIZE-1:0] count = INIT;

  // Declaración de señales [reg, wire]
  always @(posedge clk) begin
    if (start) begin
      count <= 0;
      pulse <= 1;
    end else if (counter == LIMIT) begin
      pulse <= 0;
    end else begin
      count <= count + 1;
    end
  end

  // Descripción del comportamiento

endmodule
