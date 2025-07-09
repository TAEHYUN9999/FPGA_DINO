`timescale 1ns / 1ps

//7-segment  ,  / pin 

module segment(
   input                     CLK,
   input                     RESET,
   input                 [2:0]    KEY,
   input                     Mode_Switch,
   input      wire   [1:0]      status_led,
   input      wire    [31:0]   reg_e,
   input      wire    [31:0]   reg_a,   
   output   reg   [3:0]      FND_COM,
   output   reg   [7:0]      FND_DATA
   
);

//   
   reg   [31:0]   cnt;


   reg   [15:0]   cnt64k;
   reg   [1:0]      cnt4;
   
   reg   [3:0]      regseg0;
   reg   [3:0]      regseg1;
   reg   [3:0]      regseg2;
   reg   [3:0]      regseg3;
   
   wire   [7:0]      seg0;
   wire   [7:0]      seg1;
   wire   [7:0]      seg2;
   wire   [7:0]      seg3;
   
   
   parameter [7:0] hurdle=8'h03;
   parameter [7:0] blank=8'h20;
   parameter [7:0] dino=8'h04;
   parameter [7:0] floor=8'h05;   
   
   //reg scorestop ;
   
   
   

// 24MHz clock  1  
   always @ (posedge CLK or posedge RESET)
   begin
      if (RESET)
         cnt<= 32'd0;
      else
         begin
         //50MHz , 49999999 count  1
            if (cnt < 32'd50000000)      
                  cnt <=Mode_Switch? cnt+32'd1 : cnt+ 32'd2;
// CNT  MODESWITCH OFF 1  1 CNT 50000000  MODESWITCH ON 2  0.5 CNT 50000000 .                  
            else
                  cnt<= 32'd0;
         end
   end


// 7-segment    
// cnt64 reset frequency is approx. 370 Hz
   always @ (posedge RESET or posedge CLK)
   begin
      if (RESET)
         cnt64k <= 16'd0;
      else
         begin
            if (cnt64k < 16'hffff)
               cnt64k <= cnt64k + 16'd1;
            else
               cnt64k <= 16'd0;
         end
   end

// 4 7-Segment     
// Switch to next segment at around 370 Hz
   always @ (posedge RESET or posedge CLK)
   begin
      if (RESET)
         cnt4 <= 2'b00;
      else
         begin
            if (cnt64k == 16'hffff)
               begin
                  if (cnt4 < 2'b11)
                     cnt4 <= cnt4 + 2'b01;
                  else
                     cnt4 <= 2'b00;
               end
         end
   end

// 1  counter  7-Segment    
   always @ (posedge RESET or posedge CLK)
   begin
      if(RESET || KEY[1] || KEY[2])
         begin
            regseg0 <= 4'd0;
            regseg1 <= 4'd0;
            regseg2 <= 4'd0;
            regseg3 <= 4'd0;
         end   
      else
         begin

            if ((cnt == 32'd50000000)&&(status_led<2'd3))// , reg_a hurdle    // 10의 자리수 증가
               begin
                  if (regseg2 < 9)
                     regseg2 <= regseg2 + 4'd1; // 10  1
                  else
                     regseg2 <= 4'd0;
               end
               
            if ((cnt == 32'd50000000) && (regseg2 == 9))// ,regseg2 9,  10 9 reg_a hurdle   // 100의 자리수 증가
               begin
                  if (regseg1 < 9)
                     regseg1 <= regseg1 + 4'd1;
                  else
                     regseg1 <= 4'd0;
               end
               
            if ((cnt == 32'd50000000) && (regseg1 == 9) && (regseg2 == 9) &&(status_led<2'd3)) // 1000의 자리수 증가 
// ,regseg2 9, 100  9  10 9 reg_a hurdle    regseg0 1             
               begin
                  if (regseg0 < 9)
                     regseg0 <= regseg0 + 4'd1;
                  else
                     regseg0 <= 4'd0;
               end
            if((((cnt == 32'd50000000) &&(status_led==3'd3) )))//   0 segment     
            begin
            regseg0<=regseg0; 
            regseg1<=regseg1;
            regseg2<=regseg2;
            regseg3<=regseg3;				
				//scorestop <= 1'd1;
            end
         end
   end
	
/*	always @ (posedge CLK or posedge RESET)
	begin 
		if(RESET)
			scorestop <= 0;
		else if (scorestop) begin
			regseg0<=4'd0; 
         regseg1<=4'd0;
         regseg2<=4'd0;
         regseg3<=4'd0;
	end 
	
	end */
	
//cnt4  4 7-Segment    
   always @ (cnt4)
   begin
      case (cnt4)
         2'b00      :   FND_COM   <=   4'b1000;
         2'b01      :   FND_COM   <=   4'b0100;
         2'b10      :   FND_COM   <=   4'b0010;
         default   :   FND_COM   <=   4'b0001;
      endcase
   end

//7-segment     
   bin2seg u0 (.bin_data(regseg0), .seg_data(seg0));
   bin2seg u1 (.bin_data(regseg1), .seg_data(seg1)); 
   bin2seg u2 (.bin_data(regseg2), .seg_data(seg2));
   bin2seg u3 (.bin_data(regseg3), .seg_data(seg3));

//7-Segment 
   always @ (FND_COM or seg0 or seg1 or seg2 or seg3)
      begin
      case (FND_COM)
         4'b1000   :   FND_DATA   <=   ~seg0; // First 7-Segment (Left Most)
         4'b0100   :   FND_DATA   <=   ~seg1; // Second 7-Segment
         4'b0010   :   FND_DATA   <=   ~seg2; // Third 7-Segment
         default   :   FND_DATA   <=   ~seg3; // Fourth 7-Segment (Right Most)
      endcase
   end
endmodule 