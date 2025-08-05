/* Machine-generated using Migen */
module top(
	input a,
	input b,
	output reg c,
	output reg d,
	input div_clk,
	input div_rst,
	input sys_clk,
	input sys_rst
);



always @(posedge div_clk) begin
	d <= b;
	if (div_rst) begin
		d <= 1'd0;
	end
end

always @(posedge sys_clk) begin
	c <= (a & b);
	if (sys_rst) begin
		c <= 1'd0;
	end
end

endmodule
