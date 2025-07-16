module peripheral_uart #(
    parameter clk_freq = 12000000,
    parameter baud     = 9600
) (
    input clk,
    input rst,
    input [31:0] d_in,
    input cs,
    input [31:0] addr,
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
      .addr(addr[4:0]),
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


  // //------------------------------------ regs and wires-------------------------------
  // reg  [1:0] s;  //selector mux_4  and demux_4
  // reg  [7:0] d_in_uart = 0;  // data in uart
  // reg  [7:0] uart_ctrl = 0;  // data in uart
  // wire [7:0] rx_data;  // data received
  // wire       tx_busy;  // uart transmitting
  // wire       rx_error;  // reception error
  // wire       rx_avail;  // data received
  // //------------------------------------ regs and wires-------------------------------
  //
  // //----address_decoder (one selection bit for register) ------------------
  // always @(*) begin
  //   case (addr)
  //     5'h08: begin
  //       s = (cs) ? 2'b01 : 2'b00;
  //     end  //{24'b0, rx_data}
  //     5'h10: begin
  //       s = (cs) ? 2'b10 : 2'b00;
  //     end  //{22'b0, tx_busy, rx_avail, rx_error, 7'b0}
  //     default: begin
  //       s = 2'b00;
  //     end
  //   endcase
  // end
  //
  // //Input Registers
  // always @(posedge clk) begin
  //   d_in_uart = (s[0] & wr) ? d_in[7:0] : d_in_uart; // data in uart
  //   uart_ctrl = (s[1] & wr) ? d_in[7:0] : uart_ctrl; // data controller 5'b0, LED, tx_wr, rx_ack
  //   ledout    = uart_ctrl[2]; // write ledout register
  // end
  //
  // //Output registers
  // always @(posedge clk) begin
  //   case (s)
  //     2'b01:   d_out = {24'b0, rx_data};
  //     2'b10:   d_out = {22'b0, tx_busy, rx_avail, rx_error, 7'b0};
  //     default: d_out = 0;
  //   endcase
  // end
  //
  // uart #(
  //     .freq_hz(clk_freq),
  //     .baud   (baud)
  // ) uart0 (
  //     .reset   (rst),
  //     .clk     (clk),
  //     .uart_rxd(uart_rx),
  //     .uart_txd(uart_tx),
  //     .rx_data (rx_data),
  //     .rx_avail(rx_avail),
  //     .rx_error(rx_error),
  //     .rx_ack  (uart_ctrl[1]),
  //     .tx_data (d_in_uart),
  //     .tx_wr   (uart_ctrl[0]),
  //     .tx_busy (tx_busy)
  // );
endmodule


module peripheral_uart_addr_decoder (
    input            cs,
    input      [4:0] addr,
    output reg [1:0] sel
);
  always @(*) begin
    case (addr)
      5'h08:   sel = cs ? 2'b01 : 2'b00;
      5'h10:   sel = cs ? 2'b10 : 2'b00;
      default: sel = 2'b00;
    endcase
  end
endmodule

module peripheral_uart_register_control (
    input             clk,
    input             rst,
    input             wr,
    input      [ 1:0] sel,
    input      [31:0] d_in,
    input      [ 7:0] rx_data,
    input             tx_busy,
    input             rx_error,
    input             rx_avail,
    output reg [ 7:0] uart_ctrl,
    output reg [ 7:0] d_in_uart,
    output reg [31:0] d_out,
    output reg        ledout
);
  always @(posedge clk) begin
    if (sel[0] && wr) d_in_uart <= d_in[7:0];

    if (sel[1] && wr) uart_ctrl <= d_in[7:0];

    ledout <= uart_ctrl[2];
  end

  always @(posedge clk) begin
    case (sel)
      2'b01:   d_out <= {24'b0, rx_data};
      2'b10:   d_out <= {22'b0, tx_busy, rx_avail, rx_error, 7'b0};
      default: d_out <= 0;
    endcase
  end
endmodule
