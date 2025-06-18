//------------------------------------------------------------------
// Dual port memory (one read and one write port, same width)
//------------------------------------------------------------------

module dp_ram #(
	parameter adr_width = 13,
	parameter dat_width = 16,
	parameter mem_file_name = "init_dpram.ini"
) (
	// write port a 
	input                       clk_a,
	input                       en_a,
	input      [adr_width-1:0]  adr_a,
	input 	   [dat_width-1:0]  dat_a,
	input                       we_a,
	// read port b
	input                       clk_b,
	input                       en_b,
	input						re_b,
	input      [adr_width-1:0]  adr_b,
	output reg [dat_width-1:0]  dat_b,
	output reg [dat_width-1:0]  dat_a_out
);

parameter depth = (1 << adr_width);
// actual ram cells
reg [dat_width-1:0] ram [0:4095];
initial begin
	$readmemh(mem_file_name, ram);
end
//------------------------------------------------------------------
// read port B
//------------------------------------------------------------------
always @(posedge clk_b)
begin
	if (en_b)
		if(re_b)
			dat_b <= ram[adr_b];
end

//------------------------------------------------------------------
// write port A
//------------------------------------------------------------------
always @(posedge clk_a)
begin
	if (en_a) begin
		if (we_a) begin
			ram[adr_a] <= dat_a;
		end else  dat_a_out<=ram[adr_a];
	end 
end



endmodule
