module clk_divider #(parameter WIDTH = 26) (
    input clk,
    input reset,
    output tick,
    output clk_slow
);
    reg [WIDTH-1:0] clk_divider;
    always @ (posedge clk) begin
        if (reset) begin
            clk_divider <= 26'd0;
        end
        else begin
            clk_divider <= clk_divider + 26'd1;
        end
    end
    assign tick =( (~clk_divider == 26'd0)? 1 : 0 ); 
    assign clk_slow = (clk_divider[WIDTH-1]);
endmodule