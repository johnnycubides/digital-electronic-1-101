module top (
// Inputs and output ports
input a, clk,
output z1, z2
);

// Descripción del comportamiento
no_bloqueante no_bl(.a(a), .clk(clk), .z1(z1));
bloqueante bl(.a(a), .clk(clk), .z2(z2));

endmodule
