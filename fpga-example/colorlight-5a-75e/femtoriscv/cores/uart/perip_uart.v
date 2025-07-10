module peripheral_uart #(
    parameter clk_freq = 12000000,
    parameter baud     = 9600
) (
    input clk,
    input rst,
    input [31:0] d_in,
    input cs,
    input [4:0] addr,
    input rd,
    input wr,
    output [31:0] d_out,
    output uart_tx,
    input uart_rx,
    output ledout
);

  wire [1:0] s;
  wire [7:0] d_in_uart, uart_ctrl, rx_data;
  wire tx_busy, rx_error, rx_avail;
  // wire [31:0] d_out_mux;

  // 1. Address Decoder
  peripheral_uart_addr_decoder decoder (
      .cs  (cs),
      .addr(addr),
      .sel (s)
  );

  // 2. Internal Register Control
  peripheral_uart_register_control regs (
      .clk(clk),
      .rst(rst),
      .wr(wr),
      .sel(s),
      .d_in(d_in),
      .rx_data(rx_data),
      .tx_busy(tx_busy),
      .rx_error(rx_error),
      .rx_avail(rx_avail),
      .uart_ctrl(uart_ctrl),
      .d_in_uart(d_in_uart),
      // .d_out(d_out_mux),
      .d_out(d_out),
      .ledout(ledout)
  );

  // assign d_out = d_out_mux;

  uart #(
      .freq_hz(clk_freq),
      .baud   (baud)
  ) uart0 (
      .reset   (rst),
      .clk     (clk),
      .uart_rxd(uart_rx),
      .uart_txd(uart_tx),
      .rx_data (rx_data),
      .rx_avail(rx_avail),
      .rx_error(rx_error),
      .rx_ack  (uart_ctrl[1]),
      .tx_data (d_in_uart),
      .tx_wr   (uart_ctrl[0]),
      .tx_busy (tx_busy)
  );

endmodule


module peripheral_uart_addr_decoder (
    input            cs,
    input      [4:0] addr,
    output reg [1:0] sel
);
  always @(*) begin
    case (addr)
      5'h08:   sel = cs ? 2'b01 : 2'b00;  // IO_UART_DAT {24'b0, rx_data}
      5'h10:   sel = cs ? 2'b10 : 2'b00;  // IO_UART_CNTL {22'b0, tx_busy, rx_avail, rx_error, 7'b0}
      default: sel = 2'b00;
    endcase
  end
endmodule

module peripheral_uart_register_control (
    input             clk,
    input             rst,
    input             wr,
    input      [ 1:0] sel,        // Selector mux_4 and dmux_4
    input      [31:0] d_in,
    input      [ 7:0] rx_data,    // data received
    input             tx_busy,    // uart transmitting
    input             rx_error,   // reception error
    input             rx_avail,   // data received
    output reg [ 7:0] uart_ctrl,  // data in uart
    output reg [ 7:0] d_in_uart,  // data in uart
    output reg [31:0] d_out,
    output reg        ledout
);

  // Input registers
  always @(posedge clk) begin
    if (sel[0] && wr) d_in_uart <= d_in[7:0];  // data in uart

    if (sel[1] && wr) uart_ctrl <= d_in[7:0];  // data controller 5'b0, LED, tx_wr, rx_ack

    ledout <= uart_ctrl[2];  // Write ledout register
  end

  // Output registers
  always @(posedge clk) begin
    case (sel)
      2'b01:   d_out <= {24'b0, rx_data};
      2'b10:   d_out <= {22'b0, tx_busy, rx_avail, rx_error, 7'b0};
      default: d_out <= 0;
    endcase
  end
endmodule
