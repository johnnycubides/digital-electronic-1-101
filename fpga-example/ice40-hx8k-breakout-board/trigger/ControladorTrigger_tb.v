`timescale 1ns / 1ps
`include "./ControladorTrigger.v"

module ControladorTrigger_tb ();
  // Señales del testbench
  reg  clk_tb;  // Señal de reloj para la simulación
  wire trigger_tb;  // Señal de salida del trigger
  wire probe;  // Señal de salida del trigger

  // Instancia del módulo a probar (UUT - Unit Under Test)
  ControladorTrigger UUT (
      .clk(clk_tb),
      .trigger(trigger_tb)
  );

  // Generador de señal de reloj (25 MHz)
  initial begin
    clk_tb = 0;
    forever #20 clk_tb = ~clk_tb;  // Período de 40 ns (25 MHz)
  end

  // Proceso de simulación
  initial begin
    // Inicialización de la simulación
    // Mensajes de inicio
    $display("Iniciando la simulación...");

    $display("Fin de la simulación.");
    #20000 $finish;
  end

  initial begin
    // $dumpfile("ControladorTrigger_tb.vcd");
    $dumpvars(0, ControladorTrigger_tb);
  end
endmodule
