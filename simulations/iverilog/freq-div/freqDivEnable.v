module freqDivEnable (
    input mclk,
    output reg enable
);

  localparam integer LIMIT = 11;
  reg [23:0] counter;
  initial begin
    enable  = 0;
    counter = 0;
  end
  always @(posedge mclk) begin
    if (counter == LIMIT) begin
      counter <= 0;
      enable  <= 1;
    end else begin
      counter <= counter + 1;
      enable  <= 0;
    end
  end
endmodule
