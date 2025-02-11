module control (
    // Inputs and output ports
    input  wire       clk,
    input  wire       i2c_busy,
    input  wire [7:0] receivedData,
    output reg        i2c_start = 0,
    output reg  [6:0] i2c_slave_addr,
    output reg        i2c_rw,
    output reg  [7:0] data2send
);

  // INFO: hola
  // assign test = i2c_start;

  // Declaración de señales [reg, wire]
  reg [1:0] counter = 2'd0;
  reg [6:0] i2c_addresses[0:1];
  reg [7:0] dataOut[0:1];
  reg [7:0] dataIn[0:1];

  initial begin
    i2c_addresses[0] = 8'h64;
    i2c_addresses[1] = 8'h65;
    dataOut[0] = 8'h12;
    dataOut[1] = 8'h12;
  end

  // Descripción del comportamiento
  always @(posedge clk) begin
    if (i2c_busy) begin
      i2c_start <= 1'b0;
    end else begin
      i2c_slave_addr <= i2c_addresses[0];
      data2send <= dataOut[0];
      i2c_rw <= 1'b0;
      i2c_start <= 1'b1;
    end
  end

endmodule
