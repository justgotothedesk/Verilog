// module that controls which signal turns on whether highway or country way using signal counter instead of repeat
module sig_control(
    hwy, cntry, X, clock, clear, y2rdelay, r2gdelay);

output reg [1:0] hwy, cntry;

input X;
input clock, clear;
input [2:0] y2rdelay, r2gdelay;

parameter RED = 2'd0,
        YELLOW = 2'd1,
        GREEN = 2'd2;

parameter s0 = 3'd0,
        s1 = 3'd1,
        s2 = 3'd2,
        s3 = 3'd3,
        s4 = 3'd4;

reg [2:0] state;
reg [2:0] next_state;
reg [2:0] y2r_counter;
reg [2:0] r2g_counter;

always @(posedge clock)
    if (clear)
        state <= s0;
    else
        state <= next_state;

always @(state)
begin
    hwy = GREEN;
    cntry = RED;
    case(state)
        s0: ;
        s1:hwy = YELLOW;
        s2:hwy = RED;
        s3: begin
                hwy = RED;
                cntry = GREEN;
            end
        s4: begin
                hwy = RED;
                cntry = YELLOW;
            end
    endcase
end

always @(state or X or y2r_counter or r2g_counter)
begin
    case (state)
        s0: if(X)
                next_state = s1;
            else
                next_state = s0;
        s1: begin
                if (y2r_counter == y2rdelay) @(posedge clock)
                begin
                    next_state <= s2;
                    y2r_counter <= 0;
                end
                else
                    y2r_counter <= y2r_counter + 1;
            end
        s2: begin
                if (r2g_counter == r2gdelay) @(posedge clock)
                begin
                    next_state <= s3;
                    r2g_counter <= 0;
                end
                else
                    r2g_counter <= r2g_counter + 1;
            end
        s3: if(X)
                next_state = s3;
            else
                next_state = s4;
        s4: begin
                if (y2r_counter == y2rdelay) @(posedge clock)
                begin
                    next_state <= s0;
                    y2r_counter <= 0;
                end
                else
                    y2r_counter <= y2r_counter + 1;
            end
        default: next_state = s0;
    endcase
end

initial
begin
    y2r_counter <= 0;
    r2g_counter <= 0;
end
endmodule


module Top;

wire [1:0] MAIN_SIG, CNTRY_SIG;
reg CAR_ON_CNTRY_RD;
reg CLOCK, CLEAR;


parameter Y2R_DELAY = 3'b011;
parameter R2G_DELAY = 3'b011;

sig_control sc(MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD, CLOCK, CLEAR, Y2R_DELAY, R2G_DELAY);

initial
    $monitor($time, " Main Sig = %b Country Sig = %b Car_on_cntry = %b", MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);

initial
begin
    CLOCK = 1'b0;
    forever #5 CLOCK = ~CLOCK;
end

initial
begin
    CLEAR = 1'b1;
    repeat (5) @(negedge CLOCK);
    CLEAR = 1'b0;
end


initial
begin
    CAR_ON_CNTRY_RD = 1'b0;
    
    repeat(20)@(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b1;
    repeat(10)@(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b0;
    
    repeat(20)@(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b1;
    repeat(10)@(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b0;
    
    repeat(20)@(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b1;
    repeat(10)@(negedge CLOCK); CAR_ON_CNTRY_RD = 1'b0;
    
    repeat(10)@(negedge CLOCK); $stop;
    
end
endmodule


