`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:12 11/25/2014 
// Design Name: 
// Module Name:    Thermistor 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Thermistor(
 input clk_main,   
 input reset,  
 inout Thermistor2,
 output [31:0]PrintfData4
    );

reg Thermistor_r = 0;
reg dir_r=0; //0 out, 1 in
reg [7:0]state = 0;
reg [7:0]i_cnt = 0;
reg [31:0]cnt = 0;
reg [31:0]reset_cnt = 0;
reg [15:0]state_timer_cnt = 0;
//Parameters: wrd - data to be written
reg [7:0]wrd = 0;
reg [7:0]wrd2 = 0;
//Return Value: retd - a byte of data returned
reg [7:0]retd = 0;
reg [7:0]write_cnt = 0;
reg [7:0]read_cnt = 0;
reg [7:0]templow = 0;
reg [7:0]temphigh = 0;
reg [15:0]temp_sum = 0;
reg re_init=0;
reg [3:0]writeNumber = 0;
reg [3:0]readNumber = 0;
always@(posedge clk_main)
begin
 case(state)
 8'd0:
 begin
  if(reset_cnt == 32'd500000)
  begin
   state <= 8'd1;
   dir_r <=  0; //output set!
   Thermistor_r <=  1'b0; // output low!
   wrd <=  8'd0;
   read_cnt <=  8'd0;
   temp_sum <=  16'd0;
   templow <=  8'd0;
   temphigh <=  8'd0;
  end 
  else reset_cnt <=  reset_cnt + 1'b1;
 end 
 8'd1://ds18b20_init
 begin
   dir_r <=  0; //output set!
   state <=  8'd2;
 end 
 8'd2:
 begin
  Thermistor_r <=  1'b0;// output high!
  state <=  8'd3;
 end
 8'd3:
 begin
  if(state_timer_cnt >= 16'd45000) //900us 
  begin
   state_timer_cnt <=  16'd0;
   state <=  8'd31;
  end 
  else state_timer_cnt <=  state_timer_cnt + 1'b1;
 end 
  8'd31:
 begin
   Thermistor_r <=  1'b1;// output high!
	state <=  8'd4;
 end 
 8'd4:
 begin
   if(state_timer_cnt >= 32'd2500) ///delay 50us!
   begin
   state_timer_cnt <=  32'd0;
   state <=  8'd32;
   end 
   else state_timer_cnt <=  state_timer_cnt + 1'b1;
 end 
 8'd32:
 begin
  dir_r <=  1; //input set!
  state <=  8'd5;
 end 
8'd5:
 begin
    if(Thermistor2 == 1'b0)
    begin
   state <=  8'd6;
   end 
 end
8'd6:
 begin
   if(Thermistor2 == 1'b1)
   begin
   state <=  8'd7;
   end 
 //state = 8'd6;
 end 
//////////////////////////////////////////////////////////////// 
//ds18b20_writeB skip ROM,start temperature conversion
//////////////////////////////////////////////////////////////// 
8'd28:
begin
	if(state_timer_cnt >= 32'd2500) //50us delay!
	begin
	state_timer_cnt <=  32'd0;
	state <=  8'd7;
	end 
	else state_timer_cnt <=  state_timer_cnt + 1'b1;
end 
 8'd7:
  begin
  case(writeNumber)
  0:wrd <=  8'hcc;
  1:wrd <=  8'h44;
  2:wrd <=  8'hcc;
  3:wrd <=  8'hbe;
  endcase
  state <=  8'd8;
  
  end 
 8'd8: 
 begin
  dir_r <=  1'b0; // output set!
  state <=  8'd9;
 end 
 8'd9:
 begin
 Thermistor_r <=  1'b0; //output low!
 state <=  8'd10;
 end
 8'd10: 
 begin
		if(state_timer_cnt >= 32'd50) //1us delay!
		begin
			state_timer_cnt <=  32'd0;
			state <=  8'd11;
		end 
		else state_timer_cnt <=  state_timer_cnt + 1'b1;
 end 
 8'd11: 
 begin
		  if((wrd&8'h01))
		  begin
			Thermistor_r <=  1'b1;
		  end 
		  else Thermistor_r <=  1'b0;
		  state <=  8'd12;
 end 
 8'd12:
 begin
  if(state_timer_cnt>=32'd2500)//50us!
  begin
		state_timer_cnt <=  32'd0;
		state <=  8'd29;   
  end
  else state_timer_cnt <=  state_timer_cnt + 1'b1;
 end 
8'd29:
  begin
  Thermistor_r <=  1'b1;
	state <=  8'd30;   
  end 
  8'd30:
  begin
  	wrd <=  (wrd>>1'b1);
  state <=  8'd13;   
  
  end
 8'd13:
 begin
   if(write_cnt >= 8'd7)
  begin
   state <=  8'd14;   
   write_cnt <=  8'd0;
  end 
   else 
  begin
  write_cnt <=  write_cnt + 1'b1;
  state <=  8'd8;
  end 
 end  
 8'd14:
 begin
 writeNumber <=  writeNumber+ 1'b1;
 state <=  8'd15;
 end 
 8'd15:
 begin
	case(writeNumber)
	1:
	begin
	state <=  8'd28;
	end
	2:
	begin
	state <=  8'd1;
	
	end
	3:
	begin
	state <=  8'd28;
	
	end
	4:
	begin
	 writeNumber <= 4'd0;
		  state <=  8'd27;
	end
	endcase
 end 
//////////////////////////////////////////////////////////////// 
// read temperature low byte, read temperature high byte
////////////////////////////////////////////////////////////////
8'd27:
begin
	 retd <=  8'd0;
	 state <=  8'd16;
end 
8'd16: 
 begin
   retd <=  (retd>>1);
   state <=  8'd33;
 end
8'd33:
begin
	dir_r <=  1'b0; // output set!
	state <=  8'd34;
end 
8'd34:
begin
   Thermistor_r <=  1'b0; //output low!
   state <=  8'd35;
end 
8'd35:
begin
   if(state_timer_cnt >= 32'd50) //1us delay!
   begin
	  state_timer_cnt <=  32'd0;
	  state <=  8'd36;
   end 
   else state_timer_cnt <=  state_timer_cnt + 1'b1;
end 
8'd36:
 begin
   dir_r <=  1'b1; // input set!
   state <=  8'd37;
end 
8'd37:
begin
   if(state_timer_cnt >= 32'd700) //14us delay!
   begin
	  state_timer_cnt <=  32'd0;
	  state <=  8'd21;
   end 
   else state_timer_cnt <=  state_timer_cnt + 1'b1;
end 
8'd21:
 begin
   if(Thermistor2 == 1'b1)
  begin
   retd <=  retd | 8'h80;
  end 
    state <=  8'd22;
 end 
8'd22:
 begin
  if(state_timer_cnt >= 32'd2250) //45us delay!
  begin
    state_timer_cnt <=  32'd0;
     state <=  8'd23;
  end 
  else state_timer_cnt <=  state_timer_cnt + 1'b1;
 end
8'd23:
 begin
    if(read_cnt == 8'd7)
   begin 
   read_cnt <=  8'd0;
   state <=  8'd24;
   end
    else 
   begin
   read_cnt <=  read_cnt + 1'b1;
   state <=  8'd16;
   end 
 end 
8'd24:
begin
readNumber <=  readNumber + 1'b1;
state <=  8'd25;
end 
//////////////////////////////////////////////////////////////// 
// calculate the specific temperature
//////////////////////////////////////////////////////////////// 
8'd25:
begin
 if(readNumber ==4'd1)
 begin
   templow <=  retd;
   state <=  8'd27;
 end 
 else if(readNumber >=2'd2)
 begin
	readNumber <= 4'd0;
   temphigh <=  retd;
   state <=  8'd26;
 end 
end
8'd26:
 begin
  temp_sum <=  {temphigh,templow};
  state <=  8'd1;
 end 
 endcase
end 

assign PrintfData4 = ((temp_sum*10'd625)/10'd1000);
//assign Dataout = state[7:0];
assign Thermistor2 = (dir_r==0)? Thermistor_r:1'bz;
endmodule  
