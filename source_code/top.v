module Sweeper (
    input clk,
    input reset,
    input tx,                // signal received from HC-05
    input [1:0] echo,        //front, back
    input enable_switch,
    input enable_sonic,

    output left_motor,
    output right_motor,
    output reg [1:0] left,
    output reg [1:0] right,

    output [7:0] led,        // data received from HC-05
    output reg [1:0] fan,        // in1, in2
    // output reg enable,
    output reg en_led,
    output [1:0] trig,       //front, back
    output [3:0] AN, 
    output [6:0] seg,
    output [5:0] seg_speed,
    output [1:0] LED_mode    //RANDOM, CONTROL
);
    wire [19:0] dis [1:0];
    wire stop_front, stop_back, isStuck;
    wire rst, rst_pb, clk_tick, clk_tick_17, clk_slow_17;
    wire [7:0] en_sig_pb;
    
    reg [2:0] state, next_state;
    reg [1:0] speed;
    reg [7:0] lfsr; 
    reg enable, mode;
    reg [26:0] cnt;
    reg [1:0] cnt_led;

    //motor behavior
    parameter BACK = 3'b000;
    parameter LEFT = 3'b001;
    parameter RIGHT = 3'b010;
    parameter FORWARD = 3'b011;
    parameter STOP = 3'b100;

    //motor speed
    parameter SLOW = 2'b00;
    parameter MID = 2'b01;
    parameter FAST = 2'b10;

    //sweeper mode
    parameter CONTROL = 1'b0;
    parameter RANDOM = 1'b1;

    assign LED_mode = { mode, ~mode }; 

    debounce #(.WIDTH(1)) d0 (reset, clk, rst_pb);
    onepulse #(.WIDTH(1)) o0(rst_pb, clk, rst);

    clk_divider #(.WIDTH(26)) clk_26(clk, rst, clk_tick, clk_slow);
    clk_divider #(.WIDTH(17)) clk_17(clk, rst, clk_tick_17 ,clk_slow_17);

    debounce #(.WIDTH(8)) d1(led, clk, en_sig_pb);
    onepulse #(.WIDTH(8)) en(led, clk_slow_17, en_signal);

    sonic_top sonic_former(.clk(clk), .rst(rst), .Echo(echo[1]), .Trig(trig[1]), .stop(stop_front), .dis(dis[1]) );
    sonic_top sonic_latter(.clk(clk), .rst(rst), .Echo(echo[0]), .Trig(trig[0]), .stop(stop_back), .dis(dis[0]) );

    motor M(.clk(clk), .rst(rst), .speed(speed), .isStuck(isStuck), .pwm({left_motor, right_motor}));
 
    uart_rx u0(clk, rst, tx, led);

    SS_speed sss(seg_speed, speed);
    // SevenSegment_dist ssd(seg, AN, dis[1], rst, clk);
    SevenSegment_lfsr ssd2(seg, AN, lfsr[3:0], rst, clk);

    // LFSR create random number
    always @(posedge clk) begin
        if (rst) begin
            lfsr <= 8'b10111101; // random seed initialize
        end else begin
            if (clk_tick)
                lfsr <= {lfsr[6:0], ( (lfsr[1] ^ lfsr[2]) ^ (lfsr[3] ^ lfsr[7]) ) };
            else
                lfsr <= lfsr;
        end
    end


    always @(posedge clk)begin
        if (rst) 
            cnt <= 0;
        else 
            cnt <= cnt + 1;
    end

    always @ (posedge clk) begin
        if (rst) begin
            en_led <= 0;
        end else if (cnt[24:0] == 25'd0) begin
            if (enable) begin
                case(speed)
                    FAST: en_led <= ~en_led;
                    MID:  en_led <= (cnt[25]? ~en_led : en_led);
                    SLOW: en_led <= (cnt[26]? ~en_led : en_led);
                endcase
            end else begin
                en_led <= 0;
            end
        end
    end
    //moore machine: control motor direction
    always @ (posedge clk) begin
        if(rst) begin
            state <= STOP;
        end else begin
            state <= next_state;
        end
    end
    
    always @ (*) begin
        if (mode == CONTROL) begin
            case(led)
                8'b11000000: next_state = FORWARD;
                8'b11100000: next_state = BACK;
                8'b11110000: next_state = LEFT;
                8'b11111000: next_state = RIGHT;
                default: next_state = STOP;
            endcase
        end else begin // RANDOM
            case({lfsr[3],lfsr[0]})
                2'b00: next_state = FORWARD;
                2'b01: next_state = RIGHT;
                2'b10: next_state = LEFT;
                2'b11: next_state = BACK;
                default: next_state = STOP;
            endcase
        end
    end

    //define motor behaviors
    always @(*) begin
        if (~enable) begin
            {left, right} = 4'b0000;
        end
        else begin
            case (state)
                BACK: begin
                    if (enable_sonic && stop_back && mode == RANDOM) 
                        {left, right} = 4'b1010; //b0000
                    else 
                        {left, right} = 4'b0101;
                end
                LEFT: begin
                    {left, right} = 4'b0010;
                end
                RIGHT: begin
                    {left, right} = 4'b1000;
                end
                FORWARD: begin
                    if (enable_sonic && stop_front && mode == RANDOM)
                        {left, right} = 4'b0101; //b0000
                    else 
                        {left, right} = 4'b1010;
                end
                STOP: begin
                    {left, right} = 4'b0000;
                end
            endcase
        end
    end

    //control enable signal: triangle
    always @(posedge clk)begin
        if (rst || ~enable_switch) begin
            enable <= 0;
        end else begin
            if ((led == 8'b10101000) && (~cnt == 27'd0) ) //led
                enable <= ~enable;
            else
                enable <= enable;
        end
    end

    //control motor speed: circle
    always @(posedge clk) begin
        if (rst || ~enable_switch) begin
            speed <= SLOW;
        end else begin
            if ((led == 8'b10000110) && (~cnt == 27'd0) ) 
                speed <= ( (speed < 2'd2) ? (speed + 1) : 0 );
            else
                speed <= speed;
        end
    end
    assign isStuck = ( enable_sonic && (stop_front && state == FORWARD) || (stop_back && state == BACK) );
    
   
    //control sweeper mode: X
    
    always @(posedge clk)begin
        if (rst || ~enable_switch) begin
            mode <= CONTROL;
        end else begin
            if ( (led == 8'b10110000) && (~cnt == 27'd0) ) //led
                mode <= ~mode; // CONTROL <-> RANDOM
            else
                mode <= mode;
        end
    end
    
    //control enable signal: square
    always @(posedge clk)begin
        fan[0] <= 0;
        if (rst || ~enable_switch || ~enable) begin
            fan[1] <= 0;
        end else begin
            if ((led == 8'b10100110)  && (~cnt == 27'd0) ) //led
                fan[1] <= ~fan[1];
            else
                fan[1] <= fan[1];
        end
    end

    
endmodule