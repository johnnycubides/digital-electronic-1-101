`timescale 1ns / 1ps
module dual_port_ram #(
  parameter mem_filename = "./file.mem"
)
(
    input clock,
    input write_enable_A,
    input write_enable_B,
    input [7:0] data_in_A,
    input [7:0] data_in_B,
    input [7:0] address_A,
    input [7:0] address_B,
    output [7:0] data_out_A,
    output [7:0] data_out_B
);

reg [7:0] mem [0:15];

always @(posedge clock) begin
    if (write_enable_A) begin
        mem[address_A] <= data_in_A;
    end
    if (write_enable_B) begin
        mem[address_B] <= data_in_B;
    end
end

assign data_out_A = mem[address_A];
assign data_out_B = mem[address_B];

initial 
begin
	// if (mem_filename != "none")
	// begin
		$readmemh("file.mem", mem);
	// end
end

endmodule
