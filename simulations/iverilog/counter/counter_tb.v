module test;

  // STIMULUS
  /* Make a reset that pulses once. */
  reg reset = 0;
  initial
  begin
     # 17 reset = 1;
     # 11 reset = 0;
     # 29 reset = 1;
     # 11 reset = 0;
     # 100 $finish(); // [stop(), $finish()]
  end

  // CLOCK STIMULUS
  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #5 clk = !clk;

  // RESULT FOR DEVICE/DESIGN UNDER TEST
  wire [7:0] value;
  // DEVICE/DESIGN UNDER TEST
  counter dut (value, clk, reset);

  // MONITOR
  initial
    $monitor("Time: %t, value = %h (%0d)",
      $time, value, value);

  // SAVES FORM
  initial
  begin
    $dumpfile("top.vcd");
    $dumpvars(0, test);
  end

  // SCOREBOARD
  reg [7:0] value_old = 0;
  always @(posedge clk or posedge reset)
  begin
    if (reset == 1 && value != 0)
    begin
      $display("Time: %t, error: Reset = %d, out = %d, se esperaba en out = 0", $time, reset, value);
      value_old = value;
    end
    else
      if ((value_old + 1) != value)
      begin
        $display("Time: %t, error: value: %d, se esperaba value = %d", $time, value, value_old + 1);
        value_old <= value;
      end
  end
endmodule // test
