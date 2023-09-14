module mihermosaprueba;

  // STIMULUS
  /* Make a reset that pulses once. */
  reg a = 0;
  reg b = 0;
  reg ci = 0;
  initial
  begin
     # 1 ci = 0; b = 0; a=0;
     # 1 ci = 0; b = 0; a=1;
     # 1 ci = 0; b = 1; a=0;
     # 1 ci = 0; b = 1; a=1;
     # 1 ci = 1; b = 0; a=0;
     # 1 ci = 1; b = 0; a=1;
     # 1 ci = 1; b = 1; a=0;
	 # 1 ci = 1; b = 1; a=1;
     #1 $finish(); // [stop(), $finish()]
  end
   // RESULT FOR DEVICE/DESIGN UNDER TEST
  wire s;
  wire cout;
  // DEVICE/DESIGN UNDER TEST
  sumadorCompleto dut (ci, b, a, cout, s);

  // MONITOR
  initial
    $monitor("Time: %t, cin = %d, b = %d, a = %d => cout = %d, s = %d", $time, ci, b, a, cout, s);
  // SAVES FORM
  initial
  begin
    $dumpfile("my_design.vcd");
    $dumpvars(0, mihermosaprueba);
  end
endmodule // test

