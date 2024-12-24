// module onepulse (
//     input pb_db,
//     input clk,
//     output reg pb_op
// );
//     reg db_delay;

//     always @(posedge clk) begin
//         pb_op <= pb_db & (~db_delay);
//         db_delay <= pb_db;
//     end
// endmodule

// module onepulse_eight_bit (
//     input [7:0] pb_db,
//     input clk,
//     output reg [7:0] pb_op
// );
//     reg [7:0] db_delay;

//     always @(posedge clk) begin
//         pb_op <= pb_db & (~db_delay);
//         db_delay <= pb_db;
//     end
// endmodule

module onepulse #(parameter WIDTH = 1) (
    input [WIDTH-1:0] pb_db,
    input clk,
    output reg [WIDTH-1:0] pb_op
);
    reg [WIDTH-1:0] db_delay;

    always @(posedge clk) begin
        pb_op <= pb_db & (~db_delay);
        db_delay <= pb_db;
    end
endmodule