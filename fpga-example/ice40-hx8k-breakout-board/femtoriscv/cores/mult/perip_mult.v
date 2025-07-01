module peripheral_mult (
    input clk,
    input reset,
    input [15:0] d_in,
    input cs,
    input [4:0] addr,
    input rd,
    input wr,
    output [31:0] d_out
);

  wire [4:0] s;
  wire [31:0] result;
  wire done;

  reg [15:0] A, B;
  reg init;

  // 1. Decoder
  peripheral_mult_addr_decoder decoder (
      .cs  (cs),
      .addr(addr),
      .sel (s)
  );

  // 2. Register block
  peripheral_mult_register_block regs (
      .clk(clk),
      .reset(reset),
      .wr(wr),
      .sel(s),
      .d_in(d_in),
      .result(result),
      .done(done),
      .A(A),
      .B(B),
      .init(init),
      .d_out(d_out)
  );

  // 3. Multiplier module
  mult mult (
      .reset(reset),
      .clk(clk),
      .init(init),
      .done(done),
      .op_A(A),
      .op_B(B),
      .result(result)
  );

endmodule

module peripheral_mult_register_block (
    input             clk,
    input             reset,
    input             wr,
    input      [ 4:0] sel,
    input      [15:0] d_in,
    input      [31:0] result,
    input             done,
    output reg [15:0] A,
    output reg [15:0] B,
    output reg        init,
    output reg [31:0] d_out
);

  always @(posedge clk) begin
    if (sel[0] && wr) A <= d_in;
    if (sel[1] && wr) B <= d_in;
    if (sel[2] && wr) init <= d_in[0];  // sólo bit 0 usado
  end

  always @(posedge clk) begin
    case (sel)
      5'b01000: d_out <= result;
      5'b10000: d_out <= {31'b0, done};
      default:  d_out <= 32'b0;
    endcase
  end
endmodule

module peripheral_mult_addr_decoder (
    input            cs,
    input      [4:0] addr,
    output reg [4:0] sel
);
  always @(*) begin
    if (cs) begin
      case (addr)
        5'h04:   sel = 5'b00001;  // A
        5'h08:   sel = 5'b00010;  // B
        5'h0C:   sel = 5'b00100;  // init
        5'h10:   sel = 5'b01000;  // result
        5'h14:   sel = 5'b10000;  // done
        default: sel = 5'b00000;
      endcase
    end else begin
      sel = 5'b00000;
    end
  end
endmodule
