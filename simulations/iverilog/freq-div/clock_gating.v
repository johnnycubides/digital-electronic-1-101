module clock_gating #(
    parameter integer N = 4  // N par, >= 2
) (
    input  wire       clk,
    input  wire       rst_n,
    output wire       clk_out,
    output reg  [7:0] cuenta
);
  localparam integer HALF = N / 2;
  localparam integer W = $clog2(HALF);

  reg [W-1:0] cont;
  reg         clk_div;

  // Genera clk/N usando un FF
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cont    <= '0;
      clk_div <= 1'b0;
    end else if (cont == HALF - 1) begin
      cont    <= '0;
      clk_div <= ~clk_div;
    end else begin
      cont <= cont + 1'b1;
    end
  end

  assign clk_out = clk_div;

  // >>> AQUÍ ESTÁ EL PROBLEMA <<<
  // cuenta se relojea con la señal dividida, no con clk
  always @(posedge clk_div or negedge rst_n) begin
    if (!rst_n) cuenta <= 8'd0;
    else cuenta <= cuenta + 1'b1;
  end
endmodule
