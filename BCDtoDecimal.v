//2진수가 주어질 때, 삼항 연산자를 사용하여 특정 십진수로 변환하는 gate
module BCDtoDecimal(
    output [9:0] DECOut,
    input [3:0] BCDIn
);

assign DECOut = 
    (BCDIn > 4'b1001) ? 10'b11_1111_1111 :
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

endmodule

module Top;
reg [3:0] BCDIn;
wire [9:0] DECOut;
BCDtoDecimal decoder(
    .DECOut(DECOut),
    .BCDIn(BCDIn)
);

initial
begin
    BCDIn = 4'b0000;
    $monitor($time, " BCDIn = %d --> DECOut = %b", BCDIn, DECOut); //display를 계속해서 사용하는 것이 아닌 monitor를 사용하여 불필요한 코드를 줄였음
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
end

endmodule
