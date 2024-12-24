// module debounce (
//     input pb,
//     input clk,
//     output pb_db
// );
//     reg [3:0] dff;

//     always @(posedge clk) begin
//         dff <= {dff[3:1], pb};
//     end

//     assign pb_db = (&dff);
// endmodule

module debounce #(parameter WIDTH = 1) (
    input [WIDTH-1:0]pb,
    input clk,
    output [WIDTH-1:0]pb_db
);
    reg [WIDTH-1:0] dff [3:0] ;

    always @(posedge clk) begin
        dff[3] <= dff[2];
        dff[2] <= dff[1];
        dff[1] <= dff[0];
        dff[0] <= pb;
    end

    assign pb_db = (dff[3] & dff[2] & dff[1] & dff[0]);
endmodule