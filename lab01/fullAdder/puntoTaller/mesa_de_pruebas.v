module mesa_de_prueba;

// Genrador de señales
reg reg_a;
reg reg_b;
reg reg_c;
reg reg_d;
// Estimulos
initial
begin
reg_a = 0; reg_b = 0; reg_c = 0; reg_d = 0;
#1
reg_a = 0; reg_b = 0; reg_c = 0; reg_d = 0;
#1
reg_a = 0; reg_b = 0; reg_c = 0; reg_d = 1;
#1
reg_a = 0; reg_b = 0; reg_c = 1; reg_d = 0;
#1
$finish();
end

// Cables para conectar las salidas
wire cable_x;
puntoC dut (reg_a, reg_b, reg_c, reg_d, cable_x);

// MONITOR
initial
$monitor("Time: %t, a = %d, b = %d, c = %d, d = %d => x = %d", $time, reg_a, reg_b, reg_c, reg_d, cable_x);

initial
begin
    $dumpfile("my_design.vcd");
    $dumpvars(0, mesa_de_prueba);
end
endmodule
