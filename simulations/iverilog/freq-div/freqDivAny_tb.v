`timescale 1ns / 1ns  // <time_unit>/<time_precision

module freqDivAny_tb;

  // Generador
  reg  clk_sonda;
  // Probe
  wire probe_clk_out;
  //DUT
  freqDivAny dut (
      .mclk(clk_sonda),
      .clk_out(probe_clk_out)
  );
  // Transición
  always #1 clk_sonda = ~clk_sonda;
  initial begin
    clk_sonda = 0;
    #100 $finish();
  end
  initial begin
    $dumpvars(0, freqDivAny_tb);
  end

endmodule
