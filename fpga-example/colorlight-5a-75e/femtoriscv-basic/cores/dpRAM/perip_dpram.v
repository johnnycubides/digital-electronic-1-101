module peripheral_dpram( 
  input clk,
  input reset,
  input [15:0]d_in,
  input cs,
  input [15:0]addr, // 8 LSB from j1_io_addr
  input rd,
  input wr,
  output [15:0]d_out
  );

//------------------------------------ regs and wires-------------------------------
  reg [15:0]counter;
//------------------------------------ regs and wires-------------------------------



dp_ram dpram0 (
  .clk_a(clk),
  .en_a(cs),
  .adr_a(addr),
  .dat_a(d_in),
  .we_a(wr),

  .clk_b(clk),
  .en_b(cs),
  .re_b(rd),
  .adr_b(counter - 1),
  .dat_b(d_out)
);

always @(posedge clk or posedge reset)
begin
  if(reset)
    counter = 0;
  else if (wr == 1)
    if(cs==1)
      counter = counter +1;
end



endmodule
