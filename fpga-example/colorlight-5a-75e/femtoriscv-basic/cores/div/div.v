module div (
	input              reset,
	input              clk,
	// Control lines
	input              init,
	output reg         done,
	// 
	output reg [31:0]  result,
	input      [15:0]  op_A,
	input      [15:0]  op_B 
);

parameter START          = 3'b000;
parameter CHECK_GREATER  = 3'b001;
parameter CHECK_END      = 3'b011;
parameter SHIFT          = 3'b010;
parameter END            = 3'b100;
parameter START1         = 3'b101;

reg  [2:0]  state;
reg  [31:0] A;
reg  [15:0] B;
reg  [15:0] opB;
wire [15:0] A_minus_B;
initial begin
	result = 0;
	done   = 0;
end 
reg [4:0] count;

assign  A_minus_B = A[31:16] + (~B + 1) ;     // 2-complement

always @(posedge clk or posedge reset)
begin
	if (reset) begin
		done   <= 0;
		result <= 0;
		state   = START;
	end else begin
		case(state)
			START: begin				
				count  =  16;
				done   <= 0;
				result =  0;
				if(init)
					state = START1;
				else
					state = START;
			end
    
			START1:begin
				A      <= {16'b0,op_A}; // {A'',op_A}
				B      <= op_B;
				done   <= 0;
				result =  0;
				state  =  SHIFT;
			end

			SHIFT: begin
				A     = A << 1;
				count = count - 1;
				done  = 0;			
				state = CHECK_GREATER;
			end

			CHECK_GREATER: begin
				if(A_minus_B[15])
					A[0]     = 0;
				else begin
					A[0]  = 1;
					A[31:16] = A_minus_B;
				end
				done  = 0;
				state = CHECK_END;
			end
     
			CHECK_END: begin
				if(count == 0) begin
					state   = END;
				end
				else begin
					state   = SHIFT;
				end
			end

			END:begin
				done = 1;
				//count = count + 1;
				//state = (count>29) ? START : END ; // hace falta de 10 ciclos de reloj, para que lea el done y luego cargue el resultado
				state = START;
			end

			default: state = START;
     
		endcase
	end
end

`ifdef BENCH
reg [8*40:1] state_name;
always @(*) begin
  case(state)
    START            : state_name = "START";
    START1           : state_name = "START1";
    CHECK_GREATER    : state_name = "CHECK_GREATER";
    SHIFT            : state_name = "SHIFT";
    CHECK_END        : state_name = "CHECK_END";
    END              : state_name = "END";
  endcase
end
`endif

endmodule
