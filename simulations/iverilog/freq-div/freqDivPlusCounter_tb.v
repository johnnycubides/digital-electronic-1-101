`timescale 1ns / 1ns  // <time_unit>/<time_precision

module freqDivPlusCounter_tb;

  // Generador
  reg clk_sonda;
  // Probe
  wire [7:0] probe_enable;
  //DUT
  freqDivPlusCounter dut (
      .mclk(clk_sonda),
      .countTop(probe_enable)
  );
  // Transición
  always #1 clk_sonda = ~clk_sonda;
  initial begin
    clk_sonda = 0;
    #100 $finish();
  end
  initial begin
    $dumpvars(0, freqDivPlusCounter_tb);
  end

endmodule
