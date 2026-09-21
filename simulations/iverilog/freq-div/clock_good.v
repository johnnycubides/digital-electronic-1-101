module clock_good #(
    parameter integer N = 4  // N par, >= 2  (idéntico)
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
  reg         tick_rise;  // pulso de 1 ciclo cuando clk_div va a subir

  // Mismo contador que antes
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cont      <= '0;
      clk_div   <= 1'b0;
      tick_rise <= 1'b0;
    end else if (cont == HALF - 1) begin
      cont      <= '0;
      clk_div   <= ~clk_div;
      tick_rise <= ~clk_div;  // se activa si clk_div pasa de 0 a 1
    end else begin
      cont      <= cont + 1'b1;
      tick_rise <= 1'b0;
    end
  end

  assign clk_out = clk_div;

  // >>> TODO SIGUE EN clk <<<
  // cuenta se incrementa solo cuando hay flanco de subida "virtual"
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cuenta <= 8'd0;
    else if (tick_rise) cuenta <= cuenta + 1'b1;
  end
endmodule
