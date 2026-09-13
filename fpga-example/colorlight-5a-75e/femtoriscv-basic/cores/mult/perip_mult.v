module peripheral_mult (
    clk,
    reset,
    d_in,
    cs,
    addr,
    rd,
    wr,
    d_out
);

  input clk;
  input reset;
  input [31:0] d_in;
  input cs;
  input [31:0] addr;  // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [31:0] d_out;

  //------------------------------------ regs and wires-------------------------------
  reg [4:0] s;  //selector mux_4  and write registers
  reg [15:0] A;  //---mult_32 input registers
  reg [15:0] B;
  reg init;
  wire [31:0] result;  //mult_32 output Regs
  wire done;
  //------------------------------------ regs and wires-------------------------------
  always @(*) begin  //------address_decoder------------------------------
    if (cs) begin
      case (addr[4:0])
        5'h04:   s = 5'b00001;  // A 
        5'h08:   s = 5'b00010;  // B
        5'h0C:   s = 5'b00100;  // init
        5'h10:   s = 5'b01000;  // result
        5'h14:   s = 5'b10000;  // done
        default: s = 5'b00000;
      endcase
    end else s = 5'b00000;
  end  //------------------address_decoder--------------------------------




  always @(posedge clk) begin  //-------------------- escritura de registros 

    if (reset) begin
      init = 0;
      A    = 0;
      B    = 0;
    end else begin
      if (cs && wr) begin
        A    = s[0] ? d_in[15:0]    : A; //Write Registers
        B    = s[1] ? d_in[15:0]    : B; //Write Registers
        init = s[2] ? d_in[0] : init;
      end
    end

  end  //------------------------------------------- escritura de registros


  always @(posedge clk) begin  //-----------------------mux_4 :  multiplexa salidas del periferico
    if (reset) d_out = 0;
    else if (cs && rd) begin
      case (s[4:0])
        5'b01000: d_out = result;
        5'b10000: d_out = {31'b0, done};
      endcase
    end
  end  //-----------------------------------------------mux_4




  mult mult1 (
      .reset(reset),
      .clk(clk),
      .init(init),
      .done(done),
      .result(result),
      .op_A(A),
      .op_B(B)
  );

endmodule
