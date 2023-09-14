//  A testbench for myxor_testbech_tb
`timescale 1us/1ns

module myxor_testbech_tb;
    reg a;
    reg b;
    wire z;

  myxor myxor0 (
    .a(a),
    .b(b),
    .z(z)
  );

    reg [2:0] patterns[0:1];
    integer i;

    initial begin
      patterns[0] = 3'b0_0_0;
      patterns[1] = 3'b0_1_1;

      for (i = 0; i < 2; i = i + 1)
      begin
        a = patterns[i][2];
        b = patterns[i][1];
        #10;
        if (patterns[i][0] !== 1'hx)
        begin
          if (z !== patterns[i][0])
          begin
            $display("%d:z: (assertion error). Expected %h, found %h", i, patterns[i][0], z);
            $finish;
          end
        end
      end

      $display("All tests passed.");
    end
    endmodule
