// This code is finite state machine. If state is S3(1, 1), then result is 1. Else is 0.
module temp(
    input CLK,
    input nRST,
    input X,
    output reg Y);

initial
    Y = 1'b0;

parameter s0 = 2'b00,
    s1 = 2'b01,
    s2 = 2'b10,
    s3 = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

initial
begin
    state = 2'b00;
    next_state = 2'b00;
end

always @(posedge CLK)
    if (nRST)
        state <= next_state;
    else
        state <= s0;

always @(state)
begin
    Y = 1'b0;
    case(state)
        s0: Y = 1'b0;
        s1: Y = 1'b0;
        s2: Y = 1'b0;
        s3: Y = 1'b1;
    endcase
end

always @(state or X)
begin
    case (state)
        s0:if(X)
            next_state = s1;
            else
            next_state = s0;
        s1:if(X)
            next_state = s2;
            else
            next_state = s0;
        s2:if(X)
            next_state = s3;
            else
            next_state = s0;
        s3:if(X)
            next_state = s3;
            else
            next_state = s0;
        default: next_state = s0;
    endcase
end

endmodule


module Top;
reg CLK, nRST, X;
wire Y;
temp temp1(
    .CLK(CLK),
    .nRST(nRST),
    .X(X),
    .Y(Y));

initial
begin
nRST = 1'b0;
CLK = 1'b0;
X = 1'b0;
end

always
    #5 CLK = ~CLK;

initial
    #20 nRST = ~nRST;

initial
begin
#40 X = ~X;
#30 X = ~X;
#20 X = ~X;
#10 X = ~X;
#20 X = ~X;
#40 X = ~X;
end

endmodule
