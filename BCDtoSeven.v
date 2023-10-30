//0부터 9까지 입력되는 숫자에 따라서 엘리베이터 안내 전광판에 층을 출력하는 코드(task 사용)
module BCDtoSevenSeg(
  input [3:0] BCDIn,
  output a, b, c, d, e, f, g
);

assign a = (BCDIn == 4'b0001 || BCDIn == 4'b0100|| BCDIn == 4'b1010 || BCDIn == 4'b1011 || BCDIn == 4'b1100 || BCDIn == 4'b1101 || BCDIn == 4'b1111 || BCDIn == 4'b1110) ? 1'b0 : 1'b1;
assign b = (BCDIn == 4'b0101 || BCDIn == 4'b0110 || BCDIn == 4'b1100 || BCDIn == 4'b1110  || BCDIn == 4'b1111|| BCDIn == 4'b1010 || BCDIn == 4'b1011 || BCDIn == 4'b1100 || BCDIn == 4'b1101 || BCDIn == 4'b1111 || BCDIn == 4'b1110) ? 1'b0 : 1'b1;
assign c = (BCDIn == 4'b0010 || BCDIn == 4'b1100 || BCDIn == 4'b1110  || BCDIn == 4'b1111 || BCDIn == 4'b1010 || BCDIn == 4'b1011 || BCDIn == 4'b1100 || BCDIn == 4'b1101 || BCDIn == 4'b1111 || BCDIn == 4'b1110) ? 1'b0 : 1'b1;
assign d = (BCDIn == 4'b0001 || BCDIn == 4'b0100 || BCDIn == 4'b0111 || BCDIn == 4'b1010 || BCDIn == 4'b1111 || BCDIn == 4'b1010 || BCDIn == 4'b1011 || BCDIn == 4'b1100 || BCDIn == 4'b1101 || BCDIn == 4'b1111 || BCDIn == 4'b1110) ? 1'b0 : 1'b1;
assign e = (BCDIn == 4'b0001 || BCDIn == 4'b0011 || BCDIn == 4'b0100 || BCDIn == 4'b0101 || BCDIn == 4'b0111 || BCDIn == 4'b1001 || BCDIn == 4'b1010 || BCDIn == 4'b1011 || BCDIn == 4'b1100 || BCDIn == 4'b1101 || BCDIn == 4'b1111 || BCDIn == 4'b1110) ? 1'b0 : 1'b1;
assign f = (BCDIn == 4'b0001 || BCDIn == 4'b0010 || BCDIn == 4'b0011 || BCDIn == 4'b1010 || BCDIn == 4'b1011 || BCDIn == 4'b1100 || BCDIn == 4'b1101 || BCDIn == 4'b1111 || BCDIn == 4'b1110) ? 1'b0 : 1'b1;
assign g = (BCDIn == 4'b0000 || BCDIn == 4'b0001 || BCDIn == 4'b0111  || BCDIn == 4'b1100  || BCDIn == 4'b1101 || BCDIn == 4'b1010 || BCDIn == 4'b1011 || BCDIn == 4'b1100 || BCDIn == 4'b1101 || BCDIn == 4'b1111 || BCDIn == 4'b1110) ? 1'b0 : 1'b1;

endmodule

module Top;
reg [3:0] BCDIn;
wire a, b, c, d, e, f, g;
BCDtoSevenSeg temp(
    .BCDIn(BCDIn),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g)
);

initial
begin
    BCDIn = 4'b0000;
    #10 BCDIn = 4'b0001;
    #10 BCDIn = 4'b0010;
    #10 BCDIn = 4'b0011;
    #10 BCDIn = 4'b0100;
    #10 BCDIn = 4'b0101;
    #10 BCDIn = 4'b0110;
    #10 BCDIn = 4'b0111;
    #10 BCDIn = 4'b1000;
    #10 BCDIn = 4'b1001;
    #10 BCDIn = 4'b1010;
    #10 BCDIn = 4'b1011;
    #10 BCDIn = 4'b1100;
    #10 BCDIn = 4'b1101;
    #10 BCDIn = 4'b1110;
    #10 BCDIn = 4'b1111;
    #10 BCDIn = 4'b0000;
    #10 $finish;
end

task displayBCDandSevenSeg;
  input [3:0] BCDValue;
  input a, b, c, d, e, f, g;

  begin
    $monitor($time, " BCDIn = %d --> a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b", BCDValue, a, b, c, d, e, f, g);
  end
endtask

always @(*)
begin
displayBCDandSevenSeg(BCDIn, a, b, c, d, e, f, g);
end

endmodule
