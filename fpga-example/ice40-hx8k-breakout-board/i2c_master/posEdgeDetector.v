// filename: posEdgeDetector.v
// Brief:Detector de flanco positivo.Cuando signal pasa a flanco de bajada, se
// genera un pulso en el detector aprovechable para generar sincronía.
module posEdgeDetector (
    input clk,
    input rst,
    input signal,
    output reg detector
);

  reg signal_new;
  initial begin
    detector   = 0;
    signal_new = 0;
  end

  // signal   detector  signal_new  detector_new
  // 0        0         0           0
  // 0        0         1           0
  // 0        1         0           0
  // 0        1         1           0
  // 1        0         0           1
  // 1        0         1           0
  // 1        1         0           0
  // 1        1         1           0
  // detector  <= signal & ~detector & ~signal_new;
  // signal_new <= signal;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      detector   <= 0;
      signal_new <= 0;
    end else begin
      signal_new <= signal;
      detector   <= signal & ~detector & ~signal_new;
    end
  end
endmodule
