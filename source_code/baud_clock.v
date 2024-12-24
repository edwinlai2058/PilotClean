module baud_clock (
    input clk,
    input set,
    output reg baud_tick
);
    parameter integer CLK_FREQ = 100_000_000;
    parameter integer BAUD_RATE = 9600;
    localparam integer BAUD_TICKS = CLK_FREQ / BAUD_RATE;
    localparam integer MID_BAUD_TICKS = (BAUD_TICKS / 2);

    reg [31:0] counter;

    always @(posedge clk) begin
        if (!set) begin
            counter <= 0;
            baud_tick <= 0;
        end
         else begin
            if (counter >= BAUD_TICKS - 1) begin
                counter <= 0;         
                baud_tick <= 0;       
            end
            else begin
                counter <= counter + 1;
                if (counter == MID_BAUD_TICKS) begin
                    baud_tick <= 1;   
                end
                else begin
                    baud_tick <= 0;   
                end
            end
        end
    end
endmodule