module divider(
  input clkin,
  output clkout
);

parameter SLOW = 4;

reg [SLOW:0] count = 0;

always @(posedge clkin) begin
  count <= count + 1;
end

assign clkout = count[SLOW];

endmodule
