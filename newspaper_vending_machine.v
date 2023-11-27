// User should pay for only 5 or 10 dollars
// Newspaper is 15 dollars
// If user pay 15 dollars or 20 dollars then, can receive newspaper.
// If user pay for 20 dollars by 2 of 10 dollars, and it would not receive change.

'timescale 1ns/1ps
module vend(coin, clock, reset, newspaper);
  input [1:0] coin;
  input clock;
  input reset;
  output wire newspaper;

  wire [1:0] NEXT_STATE;
  reg [1:0] PRES_STATE;

  parameter s0 = 2'b00;
  parameter s5 = 2'b01;
  parameter s10 = 2'b10;
  parameter s15 = 2'b11;
  
  function [2:0] fsm;
      input [1:0] fsm_coin;
      input [1:0] fsm_PRES_STATE;
      
      reg fsm_newspaper;
      reg [1:0] fsm_NEXT_STATE;

      begin
          case (fsm_PRES_STATE)
                s0:
                begin
                  if(fsm_coin == 2'b10)
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s10;
                  end
                  else if (fsm_coin == 2'b01)
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s5;
                  end
                  else
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s0;
                  end
              end
              s5:
              begin
                  if (fsm_coin == 2'b10)
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s15;
                  end
                  else if (fsm_coin == 2'b01)
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s10;
                  end
                  else
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s5;
                  end
              end
              s10:
              begin
                  if (fsm_coin == 2'b10)
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s15;
                  end
                  else if (fsm_coin == 2'b01)
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s15;
                  end
                  else
                  begin
                      fsm_newspaper = 1'b0;
                      fsm_NEXT_STATE = s10;
                  end
              end
              s15:
              begin
                  fsm_newspaper = 1'b1;
                  fsm_NEXT_STATE = s0;
              end
              endcase
              fsm = {fsm_newspaper, fsm_NEXT_STATE};
      end
  endfunction
  
  
  assign {newspaper, NEXT_STATE} = fsm(coin, PRES_STATE);

  always @(posedge clock)
  begin
      if (reset == 1'b1)
          PRES_STATE <= s0;
      else
          PRES_STATE <= NEXT_STATE;
  end

endmodule


'timescale 1ns/1ps
module Top;
reg clock;
reg [1:0] coin;
reg reset;
wire newspaper;

vend vendY (coin, clock, reset, newspaper);
initial
begin
    $display("\t\tTime Reset Newspaper\n");
    $monitor("%d %d %d", $time, reset, newspaper);
end

initial
begin
    clock = 0;
    coin = 0;
    reset = 1;
    #50 reset = 0;
    @(negedge clock);
    
    #80 coin = 1; #40 coin = 0;
    #80 coin = 1; #40 coin = 0;
    #80 coin = 1; #40 coin = 0;
    
    #180 coin = 1; #40 coin = 0;
    #80 coin = 2; #40 coin = 0;
    
    #180 coin = 2; #40 coin = 0;
    #80 coin = 2; #40 coin = 0;
    
    #180 coin = 2; #40 coin = 0;
    #80 coin = 1; #40 coin = 0;
    
    #80 $finish;
end

always
begin
    #20 clock = ~clock;
end
endmodule
