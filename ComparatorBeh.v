//이전 ComparatorGate.v의 코드와 결과값은 동일하나, assign을 통해 코드의 가독성을 높이고 behavior 명령어를 사용하여 특정 조건일 때만 실행되게 하였음
module ComparatorBeh(
    output reg A_lt_B,
    output reg A_gt_B,
    output reg A_eq_B,
    input [3:0] A,
    input [3:0] B,
    input nRST,
    input CLK);

initial
begin
    A_lt_B = 1'b0;
    A_gt_B = 1'b0;
    A_eq_B = 1'b0;
end

always @(posedge CLK)
begin
    if (nRST)
    begin
        A_lt_B = 1'b0;
        A_gt_B = 1'b0;
        A_eq_B = 1'b0;
        if(A == B) A_eq_B = 1'b1;
        else if(A > B) A_gt_B = 1'b1;
        else A_lt_B = 1'b1;
    end
end

endmodule

module Top;
reg [3:0] A;
reg [3:0] B;
wire A_lt_B, A_gt_B, A_eq_B;
reg CLK;
reg nRST;
MyComparatorBeh temp(
    .A_lt_B(A_lt_B),
    .A_gt_B(A_gt_B),
    .A_eq_B(A_eq_B),
    .A(A),
    .B(B),
    .CLK(CLK),
    .nRST(nRST)
);

initial
    CLK = 1'b0;
always
    #5 CLK = ~CLK;

initial
begin
    nRST = 1'b0;
    #10 nRST = ~nRST;
end

initial
begin
    A = 4'h0; B = 4'h1;
    #10 A = 4'hf; B = 4'h3;
    #10 A = 4'ha; B = 4'hb;
    #10 A = 4'h0; B = 4'h0;
    #10 A = 4'h7; B = 4'h9;
    #10 A = 4'h9; B = 4'h9;
    #10 $finish;
end

initial
$monitor($time, " A = %x, B = %x, A_lt_B = %d, A_gt_B = %d, A_eq_B = %d", A, B, A_lt_B, A_gt_B, A_eq_B);

endmodule
