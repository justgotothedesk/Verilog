module ComparatorGate(A_lt_B, A_gt_B, A_eq_B, a, b); //두 가지의 수가 주어졌을 때, 대소 비교를 나타내는 gate(단, assign을 사용하지 않고 코드를 구성하였음)
output A_lt_B, A_gt_B, A_eq_B;
input [3:0] a;
input [3:0] b;

wire an0, bn0, an1, bn1, an2, bn2, an3, bn3;
wire aband0, aband00, aband1, aband11, aband2, aband22, aband3, aband33;
wire x0, x1, x2, x3;
wire xa0, xa1, xa2, xa3, xa4, xa5, xa6;

not not0 (an0, a[0]);
not not1 (bn0, b[0]);
not not2 (an1, a[1]);
not not3 (bn1, b[1]);
not not4 (an2, a[2]);
not not5 (bn2, b[2]);
not not6 (an3, a[3]);
not not7 (bn3, b[3]);

and and0 (aband0, an0, b[0]);
and and1 (aband00, a[0], bn0);
and and2 (aband1, an1, b[1]);
and and3 (aband11, a[1], bn1);
and and4 (aband2, an2, b[2]);
and and5 (aband22, a[2], bn2);
and and6 (aband3, an3, b[3]);
and and7 (aband33, a[3], bn3);

nor nor0 (x0, aband0, aband00);
nor nor1 (x1, aband1, aband11);
nor nor2 (x2, aband2, aband22);
nor nor3 (x3, aband3, aband33);

and and00 (xa0, x0, x1, x2, x3);
and and01 (xa1, aband00, x1, x2, x3);
and and02 (xa2, aband0, x1, x2, x3);
and and03 (xa3, aband11, x2, x3);
and and04 (xa4, aband1, x2, x3);
and and05 (xa5, aband22, x3);
and and06 (xa6, aband2, x3);

or or0 (A_lt_B, aband3, xa6, xa4, xa2);
or or1 (A_gt_B, aband33, xa5, xa3, xa1);
and or2 (A_eq_B, x0, x1, x2, x3);
endmodule

module Top;
reg [3:0] A;
reg [3:0] B;
wire A_lt_B, A_gt_B, A_eq_B;
MyComparatorGate temp(
    .A_lt_B(A_lt_B),
    .A_gt_B(A_gt_B),
    .A_eq_B(A_eq_B),
    .a(A),
    .b(B)
);

initial
begin
    A = 4'h0; B = 4'h1;
    $display($time, " A = %x, B = %x, A_lt_B = %d, A_gt_B = %d, A_eq_B = %d", A, B, A_lt_B, A_gt_B, A_eq_B);
    A = 4'hf; B = 4'h3;
    #10 $display($time, " A = %x, B = %x, A_lt_B = %d, A_gt_B = %d, A_eq_B = %d", A, B, A_lt_B, A_gt_B, A_eq_B);
    A = 4'ha; B = 4'hb;
    #10 $display($time, " A = %x, B = %x, A_lt_B = %d, A_gt_B = %d, A_eq_B = %d", A, B, A_lt_B, A_gt_B, A_eq_B);
    A = 4'h0; B = 4'h0;
    #10 $display($time, " A = %x, B = %x, A_lt_B = %d, A_gt_B = %d, A_eq_B = %d", A, B, A_lt_B, A_gt_B, A_eq_B);
    A = 4'h7; B = 4'h9;
    #10 $display($time, " A = %x, B = %x, A_lt_B = %d, A_gt_B = %d, A_eq_B = %d", A, B, A_lt_B, A_gt_B, A_eq_B);
    A = 4'h9; B = 4'h9;
    #10 $display($time, " A = %x, B = %x, A_lt_B = %d, A_gt_B = %d, A_eq_B = %d", A, B, A_lt_B, A_gt_B, A_eq_B);
end

endmodule
