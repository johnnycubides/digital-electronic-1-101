/*
 *  The PLL, that generates the internal clock (high freq) from the 
 * external one (lower freq).
 *  Trying to make something that is portable between different boards
 *  For now, ICEStick, ULX3S, ECP5 evaluation boards, FOMU supported.
 *  WIP: IceFeather
 */ 

`ifdef BENCH_OR_LINT
 `define PASSTHROUGH_PLL
`endif

/**********************************************************************/

`ifdef PASSTHROUGH_PLL
module femtoPLL #(
 parameter freq = 60
) (
 input 	pclk,
 output clk	   
);
   assign clk = pclk;   
endmodule
`else
 `ifdef ECP5_COLORLIGHT
  `include "pll_ecp5_25Mhz.v"
 `endif
`endif
