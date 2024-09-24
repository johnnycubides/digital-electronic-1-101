`include "./ControladorTrigger.v"
module top (
    // 25MHz clock input
    input  clk,
    // outputs
    output trigger,
    output probe
);

  ControladorTrigger top (
      .clk(clk),
      .trigger(trigger),
      .probe(probe)
  );

endmodule
