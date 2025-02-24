module chronometer #(
    parameter integer FREQ_IN = 10000,
    parameter integer LIMIT_CNT = 1000,  // Counter limit
    parameter integer UNITS = 0,  // 0 -> mS, 1 -> uS, 2 -> nS
    parameter integer SizeCounterMS = $clog2(LIMIT_CNT) - 1
) (
    // Inputs and output ports
    input clk,
    input start,
    input enable,
    output reg [SizeCounterMS-1:0] timer
);

  //### START PRESINTESIS ###
  localparam integer FreqMs = (UNITS == 2) ? 1e9 : (UNITS) ? 1e6 : 1e3;
  localparam integer COUNT = (FREQ_IN / FreqMs);
  localparam integer SIZE = $clog2(COUNT);
  localparam integer LIMIT = COUNT - 1;
  //### END PRESINTESIS ###

  reg [SizeCounterMS-1:0] unitCnt;
  reg pulse;

  // Declaración de señales [reg, wire]
  initial begin
    timer   = 0;
    unitCnt = 0;
    pulse   = 0;
  end


  // Descripción del comportamiento
  always @(posedge clk) begin
    if (start) begin
      timer   <= 0;
      unitCnt <= 0;
      pulse   <= 0;
    end else begin
      if (enable) begin  // Habilitador de cuenta
        if (unitCnt == LIMIT) begin  // Una cuenta de unidad
          unitCnt <= 0;
        end else begin
          unitCnt <= unitCnt + 1;
        end
      end
      if (unitCnt == 0) begin
        pulse <= 1;
      end else begin
        pulse <= 0;
      end
      if (pulse) begin
        timer <= timer + 1;
      end
    end
  end

endmodule
