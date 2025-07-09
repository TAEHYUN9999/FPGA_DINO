`timescale 1ns / 1ps

// TextLCD                          
module textlcd(
   input               RESET,      // nRESET input
   input               CLK,         // CLOCK input
   input               Mode_Switch, //   
   input    wire         [2:0] KEY, // Ű, reset Ű 
	input 	wire		[31:0] PrintfData1,
   output   reg      [2:0] status_led, // پ ֹ  
   
   output	reg		[31:0]reg_e, // Dino ġ  
   output	reg		[31:0]reg_a, //   ġ  

   output   wire      LCD_RS,      // register selector
   output   wire      [7:0]LCD_DATA,
   output   reg      LCD_EN,      // LCD TEXT Enable
   
   
   output      wire   [7:0]   LED
   
);
   
 //  reg   [31:0]   reg_a;      // Data register 0 / 1 / 2 / 3
   reg   [31:0]   reg_b;      // Data register 4 / 5 / 6 / 7
   reg   [31:0]   reg_c;      // Data register 8 / 9 / 10 / 11
   reg   [31:0]   reg_d;      // Data register 12 / 13 / 14 / 15
// The lower row
  // reg   [31:0]   reg_e;      // Data register 16 / 17 / 18 / 19
   reg   [31:0]   reg_f;      // Data register 20 / 21 / 22 / 23
   reg   [31:0]   reg_g;      // Data register 24 / 25 / 26 / 27
   reg   [31:0]   reg_h;      // Data register 28 / 29 / 30 / 31

   reg   [10:0]   delay_lcdclk;   //lcdclk    
   reg   [6:0]      count_lcd;      // lcdclk delay_lcdclk    .    LCD_DATA .

   reg   [31:0]    cnt;
   reg   [4:0]      status;
   
   //reg   [1:0] status_led;
   reg    [7:0] regLED;


                  

   //////////////////////////////

// TEXT-LCD device   state   logic
   reg  [3:0] lcd_mode; // state        
   parameter [3:0] mode_pwron = 4'd1 ;  // power on
   parameter [3:0] mode_fnset = 4'd2 ;  // function set
   parameter [3:0] mode_onoff = 4'd3 ;  // display on/off control
   parameter [3:0] mode_entr1 = 4'd4 ;  //
   parameter [3:0] mode_entr2 = 4'd5 ;  //
   parameter [3:0] mode_entr3 = 4'd6 ;  //
   parameter [3:0] mode_seta1 = 4'd7 ;  // set addr 1st line
   parameter [3:0] mode_wr1st = 4'd8 ;  // write 1st line 1   
   parameter [3:0] mode_seta2 = 4'd9 ;  // set addr 2nd line
   parameter [3:0] mode_wr2nd = 4'd10;  // write 2nd line 2   
   parameter [3:0] mode_delay = 4'd11;  // dealy  
   parameter [3:0] mode_actcm = 4'd12;  // user command     
   
   parameter [7:0] hurdle=8'h03; //     hurdle  lcd   
   parameter [7:0] blank=8'h20;  //     blank  lcd   
   parameter [7:0] dino=8'h04;   //     dino  lcd     
   parameter [7:0] floor=8'h05;   //     floor  lcd   
   

// TEXT-LCD device  state   logic
   reg [9:0] set_data;//set_data 10  MSB LCD_RS    LCD_RW   LCD_DATA 
   
   assign LCD_RS = set_data[9];
   assign LCD_DATA = set_data[7:0];

// 50MHz clock  1  
   always @ (posedge CLK or posedge RESET)
   begin
      if (RESET)
         cnt <= 32'd0;
      else
         begin
         //50MHz , 49999999 count  1
            if (cnt < 32'd50000000)      
                  cnt <=Mode_Switch? cnt+32'd1 : cnt + 32'd2; // CNT  MODESWITCH OFF 1  1 CNT 50000000  MODESWITCH ON 2  0.5 CNT 50000000 .
                  
            else
                  cnt <= 32'd0; 
         end
   end

initial begin
status = 5'd0;  //status 0  
status_led=3'd0;//status_led 0 
end

//status 
always @ (posedge CLK or posedge RESET)
begin
    if (RESET || KEY[2])
    begin
        status <= 5'd0; // RESET status 0
        status_led <= 3'd2; // RESET status_led 2
    end
    else
    begin
        if ((cnt == 32'd50000000) && (status < 5'd16)) // count sec
            status <= status + 4'd1; // status 16 status 1
        else if (status == 5'd16)
            status <= 5'd0; // status 16 status 0
        
        // 온도 값이 22'을 넘으면 status가 5'd18로 설정
		  if (PrintfData1 > 220)
        begin
            status <= 5'd18; // 온도가 22'을 넘으면 status 18
        end
        
        if (((cnt == 32'd50000000) && (reg_e[31:24] == hurdle)) || KEY[1])
        begin
            status_led <= status_led - 3'd1;
            if (status_led == 3'd0)
            begin
                status <= 5'd17;
                status_led <= 3'd3;
            end
        end
		          if (KEY[0] && (reg_e[23:16] == hurdle))
        begin
            status <= 5'd0;
        end
    end
end

      always@(status_led) 
         begin
         case (status_led)
 			3'd0 : regLED <= 8'b00000000;
			3'd1 : regLED <= 8'b10000000;
			3'd2 : regLED <= 8'b11000000;
			3'd3 : regLED <= 8'b11111111;
         default : regLED<=regLED;
         endcase
   end

  reg [7:0] up, down;

  assign LED= regLED;
	
	always @ (*)
	begin
		if( KEY[0] ) begin
			up <= dino;
	   end
		else begin 
			up <= blank;
		end
	end

	always @ (*)
	begin
		if( KEY[0] ) begin
			down <= blank;
	   end
		else begin 
			down <= dino;
		end
	end
   

   always @ (status) // ٰ ֹ ǥϱ  state  ǥ 
   begin
      case(status)
         5'd0 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, hurdle};// 
         end
         5'd1 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, hurdle, floor};// 
         end
         5'd2 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, hurdle, floor, floor};// 
         end
         5'd3 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {hurdle, floor, floor, floor};   // 
         end
         5'd4 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, hurdle};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd5 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, hurdle, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end   
         5'd6 : begin
            reg_a      <=   {blank, up, blank, blank};// 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor,floor};   // 
            reg_g      <=   {floor, hurdle, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd7 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {hurdle, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd8 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, hurdle};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd9 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, hurdle, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd10 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {floor, hurdle, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd11 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, floor};   // 
            reg_f      <=   {hurdle, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end   
         5'd12 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, floor, hurdle};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd13 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down, floor, hurdle, floor};   // 
            reg_f      <=   {floor, floor, floor,floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd14 : begin
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {down,  hurdle, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
         end
         5'd15 :   begin 
            reg_a      <=   {blank, up, blank, blank};   // 
            reg_b      <=   {blank, blank, blank, blank};   //  
            reg_c      <=   {blank, blank, blank, blank};   // 
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {hurdle, floor, floor, floor};   // 
            reg_f      <=   {floor, floor, floor, floor};   // 
            reg_g      <=   {floor, floor, floor, floor};   // 
            reg_h      <=   {floor, floor, floor, floor};   // 
           end         
         5'd16 : begin
            reg_a      <=   {8'h47, 8'h41, 8'h4D, 8'h45};   // GAME
            reg_b      <=   {8'h4F, 8'h56, 8'h45, 8'h52};   // OVER 
            reg_c      <=   {blank, blank, blank, blank};   //  
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {8'h47, 8'h41, 8'h4D, 8'h45};   // 
            reg_f      <=   {8'h4F, 8'h56, 8'h45, 8'h52};   // 
            reg_g      <=   {blank, blank, blank, blank};   // 
            reg_h      <=   {blank, blank, blank, blank};   // 
         end
          5'd17 : begin
            reg_a      <=   {blank, blank, blank, blank};   // 
            reg_b      <=   {8'h47, 8'h41, 8'h4D, 8'h45};   //  
            reg_c      <=   {8'h4F, 8'h56, 8'h45, 8'h52};   //GAME
            reg_d      <=   {blank, blank, blank, blank};   //OVER 
            reg_e      <=   {blank, blank, 8'h50, 8'h52};   //PRES 
            reg_f      <=   {8'h45, 8'h53, 8'h53, blank};   //S
            reg_g      <=   {blank, 8'h52, 8'h45, 8'h53};   //RESE 
            reg_h      <=   {8'h45, 8'h54, blank, blank};   //T 
         end
			5'd18 : begin
				reg_a      <=   {blank, blank, blank, blank};   // 
            reg_b      <=   {blank, 8'h57, 8'h41, 8'h52};   //  warning
            reg_c      <=   {8'h4E, 8'h49, 8'h4E, 8'h47};   //
            reg_d      <=   {blank, blank, blank, blank};   //
            reg_e      <=   {blank, blank, blank, blank};   //
            reg_f      <=   {blank, blank, blank, blank};   //
            reg_g      <=   {blank, blank, blank, blank};   //
            reg_h      <=   {blank, blank, blank, blank};   //
			end
         default : begin
            reg_a      <=   {8'h47, 8'h41, 8'h4D, 8'h45};   // GAME
            reg_b      <=   {8'h4F, 8'h56, 8'h45, 8'h52};   // OVER 
            reg_c      <=   {blank, blank, blank, blank};   //  
            reg_d      <=   {blank, blank, blank, blank};   //  
            reg_e      <=   {8'h47, 8'h41, 8'h4D, 8'h45};   //
            reg_f      <=   {8'h4F, 8'h56, 8'h45, 8'h52};   // 
            reg_g      <=   {blank, blank, blank, blank};   // 
            reg_h      <=   {blank, blank, blank, blank};   // 
         end
      endcase
   
end



// state logic  counter 
// CLK      
always @(posedge RESET or posedge CLK)
begin
   if(RESET)
      begin
         delay_lcdclk   <=   11'd0; 
         count_lcd      <=   7'd0;
         LCD_EN      <=   0;
      end
   else
      begin
         if (delay_lcdclk < 11'd2000)
            delay_lcdclk <=  delay_lcdclk + 11'd1;
         else
            delay_lcdclk <= 11'd0;
         if (delay_lcdclk == 11'd0)
            begin
               if (count_lcd < 7'd89)
                  count_lcd <=count_lcd + 7'd1;
               else
                  count_lcd <= 7'd6;
            end

         // CLK      
         // delay_lcdclk  200~1800 , LCD_EN 1       
         //  , LCD_EN 0       
         if (delay_lcdclk == 11'd200)
             LCD_EN <=1 ;//////////  
         else if (delay_lcdclk == 11'd1800)
            LCD_EN <= 0;
      end
end

always @(posedge RESET or posedge CLK) // LCD ۵ count 
begin
   if (RESET)
      lcd_mode <= mode_pwron;
   else   
      begin
               // count_lcd    "lcd_mode" state  
               case (count_lcd)
               7'd0      :   lcd_mode   <=   mode_pwron;
               7'd1       :   lcd_mode <= mode_fnset;
               7'd2      :   lcd_mode   <=   mode_onoff;
               7'd3      :   lcd_mode   <=   mode_entr1;
               7'd4      :   lcd_mode   <=   mode_entr2;
               7'd5      :   lcd_mode   <=   mode_entr3;
               7'd6      :   lcd_mode   <=   mode_seta1;
               7'd7      :   lcd_mode   <=   mode_wr1st;
               7'd23      :   lcd_mode   <=   mode_seta2;
               7'd24      :   lcd_mode   <=   mode_wr2nd;
               7'd40      :   lcd_mode   <=   mode_delay;
               7'd41      :   lcd_mode <= mode_actcm;
                                                
                              
               default   :   begin end
               endcase
         
      end
end



always @(posedge RESET or posedge CLK)
begin
   if (RESET)
      set_data <= 10'd0;
   else
      begin
         // lcd_mode state   LCD_DATA, LCD_RW, LCD_RS  
         case (lcd_mode)
            mode_pwron   :   set_data   <=   {1'b0,1'b0, 8'h38};//RS=0,binary 00111000
            mode_fnset   :   set_data   <=   {1'b0,1'b0, 8'h38};
            mode_onoff   :   set_data   <=   {1'b0,1'b0, 8'h0e};//00001110
            mode_entr1   :   set_data   <=   {1'b0,1'b0, 8'h06};//00000110
            mode_entr2   :   set_data   <=   {1'b0,1'b0, 8'h02};//00000010
            mode_entr3   :   set_data   <=   {1'b0,1'b0, 8'b01000000};//01000000
            mode_seta1   :   set_data   <=   {1'b0,1'b0, 8'h80};//10000000

            mode_wr1st   :
               begin
                  // Register  TEXT-LCD display    16     
                  case (count_lcd)
                     7'd7      :    set_data   <=   {1'b1,1'b0, reg_a[31:24]}; //{1'b1,1'b0, reg_e[31:24]}
                     7'd8      :    set_data   <=   {1'b1,1'b0, reg_a[23:16]};
                     7'd9      :    set_data   <=   {1'b1,1'b0, reg_a[15: 8]};
                     7'd10      :   set_data   <=   {1'b1,1'b0, reg_a[7 : 0]};
                     7'd11      :   set_data   <=   {1'b1,1'b0, reg_b[31:24]};
                     7'd12      :   set_data   <=   {1'b1,1'b0, reg_b[23:16]};
                     7'd13      :   set_data   <=   {1'b1,1'b0, reg_b[15: 8]};
                     7'd14      :   set_data   <=   {1'b1,1'b0, reg_b[7 : 0]};
                     7'd15      :   set_data   <=   {1'b1,1'b0, reg_c[31:24]};
                     7'd16      :   set_data   <=   {1'b1,1'b0, reg_c[23:16]};
                     7'd17      :   set_data   <=   {1'b1,1'b0, reg_c[15: 8]};
                     7'd18      :   set_data   <=   {1'b1,1'b0, reg_c[7 : 0]};
                     7'd19      :   set_data   <=   {1'b1,1'b0, reg_d[31:24]};
                     7'd20      :   set_data   <=   {1'b1,1'b0, reg_d[23:16]};
                     7'd21      :   set_data   <=   {1'b1,1'b0, reg_d[15: 8]};
                     7'd22      :   set_data   <=   {1'b1,1'b0, reg_d[7 : 0]};
                     
                      endcase
                   end

            mode_seta2      :   set_data   <=   {1'b0,1'b0, 8'hc0};//11000000
            mode_wr2nd      :
               begin
                  // Register  TEXT-LCD display    16   
                  case (count_lcd)
                     7'd24      :   set_data   <=   KEY[0] ?{1'b1,1'b0, reg_a[31:24]}:{1'b1,1'b0, reg_e[31:24]};
                     7'd25      :   set_data   <=   {1'b1,1'b0, reg_e[23:16]};
                     7'd26      :   set_data   <=   {1'b1,1'b0, reg_e[15: 8]};
                     7'd27      :   set_data   <=   {1'b1,1'b0, reg_e[7 : 0]};
                     7'd28      :   set_data   <=   {1'b1,1'b0, reg_f[31:24]};
                     7'd29      :   set_data   <=   {1'b1,1'b0, reg_f[23:16]};
                     7'd30      :   set_data   <=   {1'b1,1'b0, reg_f[15: 8]};
                     7'd31      :   set_data   <=   {1'b1,1'b0, reg_f[7 : 0]};
                     7'd32      :   set_data   <=   {1'b1,1'b0, reg_g[31:24]};
                     7'd33      :   set_data   <=   {1'b1,1'b0, reg_g[23:16]};
                     7'd34      :   set_data   <=   {1'b1,1'b0, reg_g[15: 8]};
                     7'd35      :   set_data   <=   {1'b1,1'b0, reg_g[7 : 0]};
                     7'd36      :   set_data   <=   {1'b1,1'b0, reg_h[31:24]};
                     7'd37      :   set_data   <=   {1'b1,1'b0, reg_h[23:16]};
                     7'd38      :   set_data   <=   {1'b1,1'b0, reg_h[15: 8]};
                     7'd39      :   set_data   <=   {1'b1,1'b0, reg_h[7 : 0]};
                  endcase
      
                        
               end
            
   
            mode_delay      :   set_data   <=   {1'b0,1'b0, 8'h02};//40
            mode_actcm      :   
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
///  03 
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////            
               begin
               case(count_lcd)//41
                7'd41  : begin
                        set_data<={1'b0, 1'b0, 8'b01011000};// 01   011  , row address 000   
                        end
                7'd42  :begin         
                        set_data<={1'b1, 1'b0, 8'b00000111}; //  3 data , 5      00111 ,  
                                                             // LCD   00111   
                        end
                7'd43  : begin
                        set_data<={1'b0, 1'b0, 8'b01011001};//
                        end
                7'd44  :begin         
                        set_data<={1'b1, 1'b0, 8'b00000111};
                        end
                7'd45  : begin
                        set_data<={1'b0, 1'b0, 8'b01011010};//
                        end
                7'd46  :begin         
                        set_data<={1'b1, 1'b0, 8'b00010111};
                        end
                7'd47  : begin
                        set_data<={1'b0, 1'b0, 8'b01011011};//
                        end
                7'd48  :begin         
                        set_data<={1'b1, 1'b0, 8'b00010111};
                        end
                7'd49  : begin
                        set_data<={1'b0, 1'b0, 8'b01011100};//
                        end
                7'd50  :begin         
                        set_data<={1'b1, 1'b0, 8'b00011111};
                        end
                7'd51  : begin
                        set_data<={1'b0, 1'b0, 8'b01011101};//
                        end
                7'd52  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001110};
                        end
                7'd53  : begin
                        set_data<={1'b0, 1'b0, 8'b01011110};//
                        end
                7'd54  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001110};
                        end
                7'd55  : begin
                        set_data<={1'b0, 1'b0, 8'b01011111};//
                        end
                7'd56  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001110};
                        end
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
///  04 
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
                7'd57  : begin
                        set_data<={1'b0, 1'b0, 8'b01100000};//
                        end
                7'd58  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001100};
                        end
                7'd59  : begin
                        set_data<={1'b0, 1'b0, 8'b01100001};//
                        end
                7'd60  :begin         
                        set_data<={1'b1, 1'b0, 8'b00011011};
                        end
                7'd61  : begin
                        set_data<={1'b0, 1'b0, 8'b01100010};//
                        end
                7'd62  :begin         
                        set_data<={1'b1, 1'b0, 8'b00011110};
                        end
                7'd63  : begin
                        set_data<={1'b0, 1'b0, 8'b01100011};//
                        end
                7'd64  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001111};
                        end
                7'd65  : begin
                        set_data<={1'b0, 1'b0, 8'b01100100};//
                        end
                7'd66  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001100};
                        end
                7'd67  : begin
                        set_data<={1'b0, 1'b0, 8'b01100101};//
                        end
                7'd68  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001110};
                        end
                7'd69  : begin
                        set_data<={1'b0, 1'b0, 8'b01100110};//
                        end
                7'd70  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001110};
                        end
                7'd71  : begin
                        set_data<={1'b0, 1'b0, 8'b01100111};//
                        end
                7'd72 :begin         
                        set_data<={1'b1, 1'b0, 8'b00001010};
                        end
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
///  05 
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
                7'd73  : begin
                        set_data<={1'b0, 1'b0, 8'b01101000};//
                        end
                7'd74  :begin         
                        set_data<={1'b1, 1'b0, 8'b00000000};
                        end
                7'd75  : begin
                        set_data<={1'b0, 1'b0, 8'b01101001};//
                        end
                7'd76  :begin         
                        set_data<={1'b1, 1'b0, 8'b00000000};
                        end
                7'd77  : begin
                        set_data<={1'b0, 1'b0, 8'b01101010};//
                        end
                7'd78  :begin         
                        set_data<={1'b1, 1'b0, 8'b00000000};
                        end
                7'd79  : begin
                        set_data<={1'b0, 1'b0, 8'b01101011};//
                        end
                7'd80  :begin         
                        set_data<={1'b1, 1'b0, 8'b00000000};
                        end
                7'd81  : begin
                        set_data<={1'b0, 1'b0, 8'b01101100};//
                        end
                7'd82  :begin         
                        set_data<={1'b1, 1'b0, 8'b00000000};
                        end
                7'd83  : begin
                        set_data<={1'b0, 1'b0, 8'b01101101};//
                        end
                7'd84  :begin         
                        set_data<={1'b1, 1'b0, 8'b00000000};
                        end
                7'd85  : begin
                        set_data<={1'b0, 1'b0, 8'b01101110};//
                        end
                7'd86  :begin         
                        set_data<={1'b1, 1'b0, 8'b00001000};
                        end
                7'd87  : begin
                        set_data<={1'b0, 1'b0, 8'b01101111};//
                        end
                7'd88 :begin         
                        set_data<={1'b1, 1'b0, 8'b00010111};
                        end                        
                  endcase
               end
            default         :   begin end
         endcase
      end
end

endmodule 