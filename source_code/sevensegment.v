//design for displaying sonic dis:
module SevenSegment_dist( 
    output reg [6:0] seg,
    output reg [3:0] AN,
    input wire [19:0] distance,
    input wire rst,
    input wire clk
    );
    
    reg [16:0] clk_divider;
    reg [3:0] display_num;
    
    always @ (posedge clk) begin
        if (rst) begin
            clk_divider <= 17'b0;
        end
        else begin
            clk_divider <= clk_divider + 1'b1;
        end
    end

    always @ (*) begin
        case(clk_divider[16:15])
            2'b00: begin
                AN = 4'b1110;
                display_num = (distance < 14'd9999 ? distance % 10 : 4'd9);
            end
            2'b01: begin
                AN = 4'b1101;
                display_num = (distance < 14'd9999 ? (distance / 10) % 10 : 4'd9);
            end
            2'b10: begin
                AN = 4'b1011;
                display_num = (distance < 14'd9999 ? (distance / 100) % 10 : 4'd9);
            end
            default: begin
                AN = 4'b0111;
                display_num = (distance < 14'd9999 ? (distance / 1000) % 10 : 4'd9);
            end
        endcase
    end
    
    always @ (*) begin
        case (display_num)
            0 : seg = 7'b1000000;	//0000
            1 : seg = 7'b1111001;   //0001                                                
            2 : seg = 7'b0100100;   //0010                                                
            3 : seg = 7'b0110000;   //0011                                             
            4 : seg = 7'b0011001;   //0100                                               
            5 : seg = 7'b0010010;   //0101                                               
            6 : seg = 7'b0000010;   //0110
            7 : seg = 7'b1111000;   //0111
            8 : seg = 7'b0000000;   //1000
            9 : seg = 7'b0010000;	//1001
            default : seg = 7'b1111111;
        endcase
    end
endmodule


module SevenSegment_speed(
    output reg [6:0] seg,
    output reg [3:0] AN,
    input wire [1:0] speed,
    input wire rst,
    input wire clk
    );
    
    always @ (*) begin
        AN = 4'b1110;
        case (speed)
            0 : seg = 7'b1000000;
            1 : seg = 7'b1111001;                                              
            2 : seg = 7'b0100100;                                               
            default : seg = 7'b1111111;
        endcase
    end
endmodule


//design for displaying sonic dis:
module SevenSegment_lfsr( 
    output reg [6:0] seg,
    output reg [3:0] AN,
    input wire [3:0] lfsr,
    input wire rst,
    input wire clk
    );
    
    reg [16:0] clk_divider;
    reg [3:0] display_num;
    
    always @ (posedge clk) begin
        if (rst) begin
            clk_divider <= 17'b0;
        end
        else begin
            clk_divider <= clk_divider + 1'b1;
        end
    end

    always @ (*) begin
        case(clk_divider[16:15])
            2'b00: begin
                AN = 4'b1110;
                display_num = lfsr[0];
            end
            2'b01: begin
                AN = 4'b1101;
                display_num = lfsr[1];
            end
            2'b10: begin
                AN = 4'b1011;
                display_num = lfsr[2];
            end
            default: begin
                AN = 4'b0111;
                display_num = lfsr[3];
            end
        endcase
    end
    
    always @ (*) begin
        case (display_num)
            0 : seg = 7'b1000000;	//0000
            1 : seg = 7'b1111001;   //0001                                                
            2 : seg = 7'b0100100;   //0010                                                
            3 : seg = 7'b0110000;   //0011                                             
            4 : seg = 7'b0011001;   //0100                                               
            5 : seg = 7'b0010010;   //0101                                               
            6 : seg = 7'b0000010;   //0110
            7 : seg = 7'b1111000;   //0111
            8 : seg = 7'b0000000;   //1000
            9 : seg = 7'b0010000;	//1001
            default : seg = 7'b1111111;
        endcase
    end
endmodule


module SS_speed(
    output reg [5:0] seg,
    input wire [1:0] speed
    );
    
    always @ (*) begin
        case (speed) //g(f)edcba
            0 : seg = 6'b111001;
            1 : seg = 6'b000100;                                              
            2 : seg = 6'b010000;                                               
            default : seg = 6'b111111;
        endcase
    end
endmodule