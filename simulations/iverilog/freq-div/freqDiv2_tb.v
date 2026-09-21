`timescale 1ns / 1ns  // <time_unit>/<time_precision

module freqDiv2_tb;

  // Generador
  reg  clk_sonda;
  // Probe
  wire probe_clk_out;

  // DUT
  freqDiv2 dut (
      .clk(clk_sonda),
      .clk_out(probe_clk_out)
  );
  initial begin
    $dumpvars(0, freqDiv2_tb);
  end
  // Transición
  always #1 clk_sonda = ~clk_sonda;
  initial begin
    clk_sonda = 0;
    #100 $finish();
  end
endmodule
