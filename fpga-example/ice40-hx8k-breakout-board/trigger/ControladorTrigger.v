module DivisorFrecuencia (
    input wire clk,  // Señal de reloj de 25 MHz
    output reg pulso_start = 0  // Señal de 20 Hz
);
  reg [22:0] contador = 23'b0;  // Contador para dividir la frecuencia
  // parameter limite= 23'b2500000

  always @(posedge clk) begin
    contador <= contador + 23'd1;
    if (contador <= 23'd1) begin  // 25 MHz / 20 Hz = 1.25e6 ciclos
      pulso_start <= 23'd1;
    end else begin
      pulso_start <= 23'b0;
    end
  end
endmodule

module GeneradorPulso (
    input  wire clk,            // Señal de reloj de 25 MHz
    input  wire start,
    output reg  trigger = 1'b0  // Señal de trigger del sensor HCSR04
);

  reg [9:0] contador_us = 10'b0;  // Contador para los 10 microsegundos
  reg init = 1'b0;
  always @(posedge clk) begin

    // Si se percibe la señal de start hacer
    if (start == 1'b1) begin
      // Inicializar el conteo del trigger
      init <= 1'b1;
      // En caso contrario de no tener la señal de start debe verificar el init
    end else begin
      // Si init está en 1 debe empezar a contar
      if (init == 1'b1) begin
        // Contando
        contador_us = contador_us + 1;
        // Si la cuenta supera el límite debe poner en cero el triger y apagar
        // el init para que deje de hacer cuentas.
        if (contador_us > 10'd249) begin
          // Poner trigger en cero
          trigger <= 1'b0;
          // Detener cuenta
          init <= 1'b0;
          // En caso de que aún no se supere la cuenta debe mantener el
          // trigger en alto (1)
        end else begin
          // Trigger en 1
          trigger <= 1'b1;
        end
        // Debido a que el init está en cero, no debe contar más
      end else begin
        // Contador siempre en cero por no tener nueva cuenta
        contador_us <= 10'b0;
      end
    end

  end
endmodule

module ControladorTrigger (
    input  wire clk,     // Señal de reloj de 25 MHz
    output wire trigger,  // Señal de trigger del sensor HCSR04
    output wire probe
);

  wire pulso;
  // Una sonda de pruebas
  assign probe = pulso;

  // Instancia divisor de frecuencia
  DivisorFrecuencia divisor (
      .clk(clk),
      .pulso_start(pulso)
      // conexión de la señal lógica
  );

  // Instancia del generador de pulso
  GeneradorPulso generador (
      .clk(clk),
      .start(pulso),
      .trigger(trigger)
  );

endmodule
