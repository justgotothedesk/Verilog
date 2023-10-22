//BCDtoDecimal.v와 결과값은 동일하나 behavior 명령어를 사용하여 특정 조건에서만 작동이 되게 구현하였음
module BCDtoDecimalBeh(
    output reg [9:0] DECOut,
    input [3:0] BCDIn,
    input nRST,
    input CLK);

initial
DECOut = 10'b00_0000_0000;

always @(posedge CLK)
begin
    if (nRST)
        begin
            DECOut = (BCDIn > 4'b1001) ? 10'b00_0000_0000 :
                (BCDIn == 4'b0000) ? 10'b00_0000_0001 :
                (BCDIn == 4'b0001) ? 10'b00_0000_0010 :
                (BCDIn == 4'b0010) ? 10'b00_0000_0100 :
                (BCDIn == 4'b0011) ? 10'b00_0000_1000 :
                (BCDIn == 4'b0100) ? 10'b00_0001_0000 :
                (BCDIn == 4'b0101) ? 10'b00_0010_0000 :
                (BCDIn == 4'b0110) ? 10'b00_0100_0000 :
                (BCDIn == 4'b0111) ? 10'b00_1000_0000 :
                (BCDIn == 4'b1000) ? 10'b01_0000_0000 :
                (BCDIn == 4'b1001) ? 10'b10_0000_0000 :
                10'b10_0000_0000;
        end
end

endmodule

module Top;
reg [3:0] BCDIn;
wire [9:0] DECOut;
reg CLK;
reg nRST;
BCDtoDecimalBeh temp(
    .DECOut(DECOut),
    .BCDIn(BCDIn),
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

initial
$monitor($time, " BCDIn = %d --> DECOut = %b", BCDIn, DECOut);

endmodule
