`include "pll.v"

module clockworks (
// Inputs and output ports
  input clki,
  output clko
);

`ifdef BENCH
  assign clko = clki;
`else
  wire locked;
  pll pll(.inclk0(clki), .c0(clko), .locked(locked));
`endif

endmodule
