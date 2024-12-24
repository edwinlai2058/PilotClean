module uart_rx (
    input clk,
    input rst,
    input tx,                // UART signal (from HC-05 TXD)
    output reg [7:0] data   // data received from HC-05
);

    reg [3:0] bit_cnt = 0;
    reg [9:0] tx_shift = 0;  // 数据移位寄存器
    reg receiving = 0;
    reg baud_enable = 0;    // trigger baud_clk

    wire baud_tick;

    baud_clock baud_inst (clk, baud_enable, baud_tick);

    always @(posedge clk) begin
        if (rst) begin
            baud_enable <= 0;
            bit_cnt <= 0;
            tx_shift <= 0;
            receiving <= 0;
            data <= 0;
        end
        else begin
            if (!receiving) begin
                if (!tx) begin // 检测起始位;
                    baud_enable <= 1;
                    receiving <= 1;
                    bit_cnt <= 0;
                end
            end
            else if (baud_tick) begin
                if (bit_cnt == 9) begin
                    baud_enable <= 0;
                    receiving <= 0;
                    data <= tx_shift[8:1];
                end
                else begin
                    tx_shift <= {tx, tx_shift[9:1]}; // 移位采样数据
                    bit_cnt <= bit_cnt + 1;
                end
            end


        end
    end

endmodule