module ascii_a_z #(
  parameter SIZE = 8,
  parameter LIMIT = 8'd122
)(
// Inputs and output ports
  input newWord,
  output reg [SIZE-1:0] word,
  output start
);

// Descripción del comportamiento
assign start = newWord;

initial
begin
  word = 8'd97;
end

always@(posedge newWord)
begin
  if(word == LIMIT)
  begin
    word <= 8'd97;
  end
  else
  begin
    word <= word + 1'd1;
  end
end

endmodule
