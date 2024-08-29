// filename: divFreq.v
`ifndef FREQ_IN
`define FREQ_IN 24000000
`endif
`ifndef FREQ_OUT
`define FREQ_OUT 1
`endif
`ifndef INIT
`define INIT 0
`endif

module divFreq (
    // Inputs and output ports
    input CLK_IN,
    output reg CLK_OUT = 0
);

  localparam integer COUNT = (`FREQ_IN / `FREQ_OUT) / 2;
  localparam integer SIZE = $clog2(COUNT);
  localparam integer LIMIT = COUNT - 1;

  // Declaración de señales [reg, wire]
  reg [SIZE-1:0] count = `INIT;

  // Descripción del comportamiento
  always @(posedge CLK_IN) begin
    if (count == LIMIT) begin
      count   <= 0;
      CLK_OUT <= ~CLK_OUT;
    end else begin
      count <= count + 1;
    end
  end
endmodule
