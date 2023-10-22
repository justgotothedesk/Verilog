module D_latch(D, En, Q, Q_);
input D, En;
output Q, Q_;

wire R, S;

nand na0(S, D, En);
nand na1(R, S, En);
nand na2(Q, Q_, S);
nand na3(Q_, Q, R);

endmodule

module Top;
reg D, En;
wire Q, Q_;

D_latch temp(D, En, Q, Q_);

initial
    D = 1'b0;
always
    #5 D = ~D;

initial
begin
    En = 1'b0;
    #12 En = ~En;
    #15 En = ~En;
    #3 $finish;
end

initial
    $monitor($time, " D =  %d, En = %d, Q = %d, Qbar = %d", D, En, Q, Q_);

endmodule
