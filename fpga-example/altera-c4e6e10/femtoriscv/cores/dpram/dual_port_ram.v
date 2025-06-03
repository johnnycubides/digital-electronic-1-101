`timescale 1ns / 1ps
module dual_port_ram #(
    parameter mem_filename = "./file.hex"
) (
    input clock,
    input write_enable_A,
    input write_enable_B,
    input [31:0] data_in_A,
    input [31:0] data_in_B,
    input [11:0] address_A,
    input [11:0] address_B,
    output reg [31:0] data_out_A,
    output reg [31:0] data_out_B
);

  (* ramstyle = "M9K" *) reg [31:0] mem[0:4095];

  always @(posedge clock) begin
    if (write_enable_A) begin
      mem[address_A] <= data_in_A;
    end
    data_out_A <= mem[address_A];
  end
  always @(posedge clock) begin
    if (write_enable_B) begin
      mem[address_B] <= data_in_B;
    end
    data_out_B <= mem[address_B];
  end

  // assign data_out_A = mem[address_A];
  // assign data_out_B = mem[address_B];

  initial begin
    // if (mem_filename != "none")
    // begin
    $readmemh(mem_filename, mem);
    // end
  end

endmodule
