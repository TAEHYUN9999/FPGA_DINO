`timescale 1ns / 1ps

module top(
   input               osc,  
   


   input SW_INPUT0,
   input SW_INPUT1,
   input SW_INPUT2,
   
   input DIP_SW0,
   input DIP_SW1,
   input DIP_SW2,
   
   input Mode_Switch,
   
   output reg SW_COMMON0,
   output reg SW_COMMON1,
   output reg SW_COMMON2,
   
//LCD Controls   
   output   wire             LCD_RS,
   output   wire             LCD_EN,
   output   wire   [7:0]     LCD_DATA,

// segment
   output   wire   [3:0]      FND_COM,
   output   wire   [7:0]      FND_DATA,
   
   output   wire         Buzz,
   output   wire          Relay,
// LED
   output   wire [7:0] LED,
// thermisotor
	inout Thermistor,
	input RXD,
	output TXD,	
// motor
	output reg motor
);


reg [1:0]reset_cnt = 0;
reg reset = 1'b1;

always@(posedge osc)
   begin
      if(reset==1'b1)
      begin
         reset_cnt <= reset_cnt + 1'b1;
      end 
         if(reset_cnt==2)
         begin
            reset <= 1'b0;
         end
   end
   
   reg [31:0]cnt_sw = 0;
   wire tick;
   reg ff_tick=0;

always@(posedge ff_tick or posedge osc)
begin
   if(ff_tick == 1'b1)
   begin
      cnt_sw <= 32'd0;
   end
   else cnt_sw <= cnt_sw +1'b1;
end 

assign tick = (cnt_sw==32'd5000)? 1'b1: 1'b0;

always@(posedge osc)
   begin
      ff_tick <=tick;
   end

reg [2:0]sw_column=0;

always@(posedge ff_tick or posedge reset)
begin
   if(reset==1'b1)
   begin
      sw_column <= 32'd0;
   end 
   else if(sw_column==4)
   begin
      sw_column <= 3'd1;
   end 
   else sw_column <= sw_column + 1'b1;
end 

always@(posedge osc or posedge reset)
begin
   if(reset==1'b1)
   begin
   SW_COMMON0 <= 1'b0;
   SW_COMMON1 <= 1'b0;
   SW_COMMON2 <= 1'b0;
   end
   else
begin
   case(sw_column)
   1:
   begin
      SW_COMMON0 <= 1'b0;
      SW_COMMON1 <= 1'b1;
      SW_COMMON2 <= 1'b1;
   end 
   2:
   begin
      SW_COMMON0 <= 1'b1;
      SW_COMMON1 <= 1'b0;
      SW_COMMON2 <= 1'b1;
   end
   3:
   begin
      SW_COMMON0 <= 1'b1;
      SW_COMMON1 <= 1'b1;
      SW_COMMON2 <= 1'b0;
   end 
   endcase
end
end 

reg [2:0]ff_sw = 0;

always@(posedge osc or posedge reset)
begin
if(reset)
begin
ff_sw <= 3'd0;
end
else ff_sw<={SW_INPUT2,SW_INPUT1,SW_INPUT0};
end

wire [2:0]KEY;

assign KEY[0] = (ff_sw==3'b110 && sw_column==1);
assign KEY[1] = (ff_sw==3'b101 && sw_column==2);
assign KEY[2] = (ff_sw==3'b011 && sw_column==3); 


wire  [1:0]status_led;
wire  [31:0]reg_e;
wire  [31:0]reg_a;



wire [31:0]  PrintfData1;   //온도센서에서 측정한 온도 데이터값 

top_tem top_tem               //온도센서 top module
(
	.osc(osc),
	.Thermistor(Thermistor),
	.RXD(RXD),
	.TXD(TXD),
	.PrintfData1(PrintfData1)
);

// 모터 제어 로직 (온도에 따라 모터 ON/OFF )
always @(posedge osc or posedge reset)
begin
   if (reset)
   begin
      motor <= 0;         // 리셋 시 모터 OFF
   end
	else
   begin
      if (PrintfData1 > 220) // 22도 = 220 (10배 스케일링)
      begin
         motor <= 1;         // 온도가 22도보다 크면 모터 ON
      end
		else
      begin
         motor <= 0;         // 온도가 27도 이하이면 모터 OFF
      end
   end
end


// textlcd   
textlcd textlcd(
   .RESET(reset),
   .CLK(osc),
   .LCD_RS(LCD_RS),
   .LCD_EN(LCD_EN),
   .LCD_DATA(LCD_DATA),
   .KEY(KEY),
   .Mode_Switch(Mode_Switch),
   .status_led(status_led),
	.reg_e(reg_e),
	.reg_a(reg_a),
   .LED(LED)
   );

// Sub-module 7-Segment 
segment segment(
   .RESET(reset),
   .CLK(osc),
   .FND_COM(FND_COM),
   .FND_DATA(FND_DATA),
   .KEY(KEY),
   .status_led(status_led),
   .Mode_Switch(Mode_Switch),
   .reg_a(reg_a),
   .reg_e(reg_e)
   );
   
buz buz(
   .RESET(reset),
   .CLK(osc),
   .DIP_SW0(DIP_SW0),
   .DIP_SW1(DIP_SW1),
   .DIP_SW2(DIP_SW2),
   .Buzz(Buzz),
   .Relay(Relay)
);




endmodule 