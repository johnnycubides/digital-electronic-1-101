module uart_rx_8n1 (
    input wire baud_tick,    // Baud tick generado externamente
    input wire rst,          // Reset
    input wire rx,           // Línea de recepción
    output reg [7:0] rx_data,// Dato recibido
    output reg rx_ready      // Indicador de dato recibido
);
    // Receptor
    reg [9:0] rx_shift_reg;  // Para capturar el start bit, data y stop bit
    reg [3:0] rx_bit_count;
    reg rx_sampled;

    // Receptor
    always @(posedge baud_tick or posedge rst) begin
        if (rst) begin
            rx_ready <= 0;
            rx_data <= 8'b0;
            rx_bit_count <= 0;
            rx_shift_reg <= 10'b1111111111;
            rx_sampled <= 1;
        end else if (!rx && rx_sampled) begin
            rx_sampled <= 0; // Detecta inicio
            rx_bit_count <= 0;
        end else if (!rx_sampled) begin
            rx_shift_reg <= {rx, rx_shift_reg[9:1]}; // Shift
            rx_bit_count <= rx_bit_count + 1;
            if (rx_bit_count == 10) begin
                rx_sampled <= 1;
                if (rx_shift_reg[9] == 1 && rx_shift_reg[0] == 0) begin
                    rx_data <= rx_shift_reg[8:1]; // Extrae los datos
                    rx_ready <= 1; // Dato listo
                end
            end
        end else if (rx_ready) begin
            rx_ready <= 0; // Reinicia la bandera cuando se lee
        end
    end
endmodule
