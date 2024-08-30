`include "./dual_port_ram.v"

module dual_port_ram_tb;

  reg clock;
  reg write_enable_A;
  reg write_enable_B;
  reg [7:0] data_in_A;
  reg [7:0] data_in_B;
  reg [7:0] address_A;
  reg [7:0] address_B;
  wire [7:0] data_out_A;
  wire [7:0] data_out_B;

  // dual_port_ram #("./file.hex") dut (
  dual_port_ram dut (
      .clock(clock),
      .write_enable_A(write_enable_A),
      .write_enable_B(write_enable_B),
      .data_in_A(data_in_A),
      .data_in_B(data_in_B),
      .address_A(address_A),
      .address_B(address_B),
      .data_out_A(data_out_A),
      .data_out_B(data_out_B)
  );

  initial begin
    clock = 0;
    write_enable_A = 0;
    write_enable_B = 0;

    #10;
    address_A = 4'h3;

    #10;
    address_A = 4'h4;

    // write_enable_A = 1;
    // write_enable_B = 1;
    // data_in_A = 4'hF;
    // data_in_B = 4'h0;
    // address_A = 4'h0;
    // address_B = 4'hF;

    // #10;
    // write_enable_A = 0;
    // write_enable_B = 0;

    // #10;
    // address_A = 4'h2;
    // data_in_A = 4'h5;
    // address_B = 4'hD;
    // data_in_B = 4'hA;

    // #10;
    // write_enable_A = 1;
    // write_enable_B = 1;
    // address_A = 4'hF;
    // address_B = 4'h0;

    // #10;
    // write_enable_A = 0;
    // write_enable_B = 0;

    // #10;
    // address_A = 4'hF;
    // address_B = 4'h0;

    #10;
    $finish;
  end

  always begin
    clock = 0;
    #5;
    clock = 1;
    #5;
  end

  // WAVES IN VCD TO OPEN IN GTKWAVE
  initial begin
    // $dumpfile("top.vcd");
    $dumpvars(0, dual_port_ram_tb);
  end

endmodule
