// filename: blink.v
// brief: descripción del parpadeo de un led
// Como el led está conectado al bit más significativo (24)

// A tener en cuenta: Para poder ver un cambio de estado se debe llegar
// a 2^(24) - 1 por tanto, se recomienda que en la simulación definir a INIT
// 10 ciclos antes del cambio, es decir, 2^(24) - 10, lo cual se puede agregar
// como un parámetro de definición en iverilog como -DINIT=\(2**24-10\). En
// este ejemplo, se ha colocado en la definición de reglas del Makefile
// como: MACROS_SIM=-DINIT=\(2**24-10\)

`ifndef INIT
`define INIT 24'd0
`endif
module blink (
    input  clk,
    output led
);

  reg [24:0] count = `INIT;

  assign led = count[24];

  always @(posedge clk) count <= count + 1;

endmodule
