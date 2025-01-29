`include "./uart_8n1.v"

module topSendData ();

  uart_8n1 uart (
      .hclk(hclk),
      .rst(rst),
      .rx(rx),
      .tx(tx),
      .tx_data(tx_data),
      .tx_start(tx_start),
      .tx_busy(tx_busy),
      .rx_data(rx_data),
      .rx_ready(rx_ready)
  );

endmodule
