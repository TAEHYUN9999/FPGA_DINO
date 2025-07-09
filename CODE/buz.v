`timescale 1ns / 1ps

module buz(
input CLK,
input RESET,
input DIP_SW0,
input DIP_SW1,
input DIP_SW2,
output reg Buzz,
output reg Relay
 );

reg [25:0]cnt_RB = 0;

reg [2:0] DIP;

always@(posedge CLK or posedge RESET)
begin
if(RESET)
begin
DIP <= 3'd0;
end
else DIP<={DIP_SW2, DIP_SW1, DIP_SW0};
end 

always@(posedge CLK or posedge RESET)
begin
   if(RESET==1'b1)
   begin
      Relay <= 1'b0;
      Buzz <= 1'b0;
      cnt_RB <= 32'd0;
   end 
   
   else begin
   case(DIP) 
   3'b001:
   begin
      if(cnt_RB==26'd50000000) // 1 
         begin
         cnt_RB <= 26'd0;
         Relay <= ~Relay;
         Buzz <= ~Buzz;
         end
      else cnt_RB <= cnt_RB +1'b1;
   end
   
   3'b010:
   begin
      if(cnt_RB==26'd25000000) // 0.5 
         begin
         cnt_RB <= 26'd0;
         Relay <= ~Relay;
         Buzz <= ~Buzz;
         end
   
      else cnt_RB <= cnt_RB +1'b1;
   end
   
   3'b100:
   begin
      if(cnt_RB==26'd12500000) // 0.25 
         begin
         cnt_RB <= 26'd0;
         Relay <= ~Relay;
         Buzz <= ~Buzz;
         end
   
      else cnt_RB <= cnt_RB +1'b1;
   end
   
   default:
      Buzz <= 0;
   endcase

end
end

endmodule