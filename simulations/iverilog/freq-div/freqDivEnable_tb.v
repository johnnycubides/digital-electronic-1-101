`timescale 1ns / 1ns  // <time_unit>/<time_precision

module freqDivEnable_tb;

  // Generador
  reg  clk_sonda;
  // Probe
  wire probe_enable;
  //DUT
  freqDivEnable dut (
      .mclk  (clk_sonda),
      .enable(probe_enable)
  );
  // Transición
  always #1 clk_sonda = ~clk_sonda;
  initial begin
    clk_sonda = 0;
    #100 $finish();
  end
  initial begin
    $dumpvars(0, freqDivEnable_tb);
  end

endmodule
