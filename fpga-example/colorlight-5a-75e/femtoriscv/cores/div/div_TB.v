`timescale 1ns / 1ps
`define SIMULATION
module div_TB;
   reg  clk;
   reg  reset;
   reg  init;
   reg  [15:0] op_A;
   reg  [15:0] op_B;
   wire [31:0] result;
   wire done;

   div uut (
      .clk(clk), 
      .reset(reset), 
      .init(init), 
      .op_A(op_A), 
      .op_B(op_B), 
      .result(result), 
      .done(done)
   );

   parameter PERIOD = 20;
   initial begin  // Initialize Inputs
      clk = 0; reset = 0; init = 0; op_A = 16'hC86C; op_B = 16'h00CA;
   end
   // clk generation
   initial         clk <= 0;
   always #(PERIOD/2) clk <= ~clk;

   initial begin // Reset the system, Start the image capture process
        // Reset 
        @ (negedge clk);
	     reset = 1;
	     @ (negedge clk);
	     reset = 0;
        #(PERIOD*4)
        init = 0;
        @ (posedge clk);
        init = 1;
        #(PERIOD*2)
        init = 0;
        #(PERIOD*50);
   end
	 

   initial begin: TEST_CASE
     $dumpfile("div_TB.vcd");
     $dumpvars(-1, div_TB);
     #(PERIOD*60) $finish;
   end

endmodule

