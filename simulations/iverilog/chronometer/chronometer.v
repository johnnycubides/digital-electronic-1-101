module chronometer #(
    parameter integer FREQ_IN = 10000,
    parameter integer LIMIT_RECORD_TIMER = 1000,  // Counter limit
    parameter integer SELECT_UNITS = 0,  // 0 -> mS, 1 -> uS
    parameter integer SIZE_RECORD_TIMER = $clog2(LIMIT_RECORD_TIMER) - 1
) (
    // Inputs and output ports
    input clk,
    input resetChronometer,
    input enableTimmerCounter,
    output reg [SIZE_RECORD_TIMER-1:0] recordTimer
);

  //### START PRESINTESIS ###
  // localparam integer FreqOfUnits = (SELECT_UNITS == 2) ? 1e9 : (SELECT_UNITS) ? 1e6 : 1e3;
  localparam integer FreqOfUnits = (SELECT_UNITS) ? 1e6 : 1e3;
  localparam integer CounterForAnUnit = (FREQ_IN / FreqOfUnits);
  localparam integer SizeOfCounterForAnUnit = $clog2(CounterForAnUnit);
  localparam integer LimitCounterForAnUnit = CounterForAnUnit - 1;
  //### END PRESINTESIS ###

  reg [SizeOfCounterForAnUnit-1:0] unitPartsCounter;
  reg pulseIndicatorUnit;

  // Declaración de señales [reg, wire]
  initial begin
    recordTimer = 0;
    unitPartsCounter = 0;
    pulseIndicatorUnit = 0;
  end

  // Descripción del comportamiento
  always @(posedge clk) begin
    if (resetChronometer) begin
      recordTimer <= 0;
      unitPartsCounter <= 0;
      pulseIndicatorUnit <= 0;
    end else begin
      if (enableTimmerCounter) begin  // Habilitador de cuenta
        unitPartsCounter <= unitPartsCounter + 1;
      end
      if (unitPartsCounter == LimitCounterForAnUnit) begin
        pulseIndicatorUnit <= 1;
        unitPartsCounter   <= 0;  // Reiniciar cuenta para la próxima unidad de tiempo
      end else begin
        pulseIndicatorUnit <= 0;
      end
      if (pulseIndicatorUnit) begin  // Si ha pasado una unidad de tiempo
        recordTimer <= recordTimer + 1;  // Sumar la unidad en el temporizador
      end
    end
  end

endmodule
