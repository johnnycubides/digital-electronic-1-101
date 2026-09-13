// filename: soc_tb.v
// brief: testbench de un blink para la placa de desarrollo Blackice
// la cual tienen un reloj de hardware de 25 MHz (periodo 40 nS)

// CONFIGURACIÓN DEL TIMESCALE
// Tenga encuenta que: solo puede usar los enteros 1, 10, 100 en la escala de
// s, ms, us, ns, ps, fs.
// Para el time_unit se hará uso de 10 nS, en vista del perido del clock. el
// time_precision, se pone según interés
`timescale 10ns / 10ns  // <time_unit>/<time_precision

// CONFIGURACIÓN DE LOS PARÁMETROS DEL RELOJ
// Cada estado de reloj debe durar medio periodo, para este caso sería 20 nS,
// como el time_unit es de 10 ns, entonces con 2 tiempos se puede representar
// la duración de cada reloj.
`ifndef TIME_UNIT
`define TIME_UNIT 40
`endif
// `include "./SOC.v"
module SOC_tb;

  // % octave
  // hclk = 12E6
  // baud = 9600
  // C_BIT_PERIOD = hclk/baud

  parameter integer C_BIT_PERIOD = 1250;

  reg CLK;
  reg i;
  reg RESET;
  wire [0:0] LEDS;
  reg RXD = 1'b0;
  wire TXD;

  // Takes in input byte and serializes it 
  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer ii;
    begin

      // Send Start Bit
      RXD <= 1'b0;
      #(C_BIT_PERIOD);
      #1000;

      // Send Data Byte
      for (ii = 0; ii < 8; ii = ii + 1) begin
        RXD <= i_Data[ii];
        #(C_BIT_PERIOD);
      end

      // Send Stop Bit
      RXD <= 1'b1;
      #(C_BIT_PERIOD);
    end
  endtask  // UART_WRITE_BYTE

  SOC uut (
      .clk(CLK),
      .resetn(RESET),
      .LEDS(LEDS),
      .RXD(RXD),
      .TXD(TXD)
  );

  reg clk = 0;
  always #(`TIME_UNIT / 2) CLK = !CLK;

  reg [4:0] prev_LEDS = 0;
  initial begin
    if (LEDS != prev_LEDS) begin
      $display("LEDS = %b", LEDS);
    end
    prev_LEDS <= LEDS;

  end

  integer idx;
  initial begin

    // $dumpfile("bench.vcd");
    $dumpvars(-1, SOC_tb);
    // for (idx = 0; idx < 32; idx = idx + 1) $dumpvars(0, soc_tb.uut.CPU.registerFile[idx]);
    //$dumpvars(0, bench.uut.CPU.registerFile[10],bench);

    // for (idx = 0; idx < 50; idx = idx + 1) $dumpvars(0, soc_tb.uut.dpram_p0.dpram0.ram[idx]);
    //$dumpvars(0, bench.uut.CPU.registerFile[10],bench);

    #0 RXD = 1;
    #0 RESET = 0;
    #80 RESET = 0;
    #160 RESET = 1;
    // Send a command to the UART (exercise Rx)
    @(posedge CLK);
    #(`TIME_UNIT * 50000) UART_WRITE_BYTE(8'h34);
    #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h35);
    #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h2A);  // Operator *
    #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h34);
    #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h32);
    #(`TIME_UNIT * 100000) UART_WRITE_BYTE(8'h39);
    #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h39);
    #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h2A);  // operator /
    // #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h2F);  // operator /
    #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h30);
    #(`TIME_UNIT * 2500) UART_WRITE_BYTE(8'h33);
    @(posedge CLK);
    #(`TIME_UNIT * 50000) $finish;
  end

endmodule
