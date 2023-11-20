// finite state machine that 3 cycles to implement and 2 cycles to unactivate

module temp(
    input CLK,
    input nRST,
    input X_IN,
    output reg Y_OUT
);

parameter s0 = 3'd0,
          s1 = 3'd1,
          s2 = 3'd2;

reg [2:0] state;
reg [2:0] next_state;

always @(posedge CLK)
begin
    if (~nRST) begin
        state <= s0;
    end
    else begin
        state <= next_state;
    end
end

always @(state or X_IN)
begin
    case (state)
        s0: begin
            if (X_IN)
                next_state = s1;
            else
                next_state = s0;
        end
        s1: begin
            repeat(2) @(posedge CLK);
                next_state = s2;
        end
        s2: begin
            repeat (1) @(posedge CLK);
            begin
            if (X_IN)
                next_state = s1;
            else
                next_state = s0;
            end
        end
        default: next_state = s0;
    endcase
end

always @(state)
    case (state)
        s0: Y_OUT <= 1'b0;
        s1: Y_OUT <= 1'b1;
        s2: Y_OUT <= 1'b0;
        default: Y_OUT <= 1'b0;
    endcase

endmodule


module Top;

reg X_IN;
wire Y_OUT;
reg CLK, nRST;

temp fsm (
    .Y_OUT(Y_OUT),
    .X_IN(X_IN),
    .nRST(nRST),
    .CLK(CLK)
);

initial
begin
    CLK = 1'b0;
    forever #5 CLK = ~CLK;
end

initial
begin
    nRST = 1'b0;
    #20 nRST = 1'b1;
end

initial
begin
    X_IN = 1'b0;
    #40 X_IN = 1'b1;
    #100 X_IN = 1'b0;
    #50 X_IN = 1'b1;
    #10 X_IN = 1'b0;
end

endmodule
