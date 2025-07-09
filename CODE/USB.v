`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:01 11/24/2014 
// Design Name: 
// Module Name:    USB 
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
module USB
(
	input clk_main,
	input reset,
	input RXD,
	output TXD,
	input [30:0]PrintfData1
//	input [31:0]PrintfData2,
//	input [31:0]PrintfData3,
//	input [31:0]PrintfData4,
//	input [31:0]PrintfData5
 );
   // OUT
parameter CLOCKS_PER_BIT = 2604; // baud rate : 38400, Clock : 50MHz
parameter CLOCKS_WAIT_FOR_RECEIVE = 1302;
parameter MAX_TX_BIT_COUNT = 9;
parameter MAX_DATA_BUFFER_INDEX = 15;

	parameter 	[7:0]		LCD_BLANK 	= 8'b00100000;
	parameter 	[7:0]		LCD_DASH 	= 8'b00101101;
	parameter	[7:0]	 	LCD_COLON	= 8'b00111010;
	parameter	[7:0]	 	LCD_PERIODE	= 8'b00101110;
	parameter	[7:0]	 	LCD_EQUAL	= 8'b00111101;
	parameter	[7:0]	 	LCD_0			= 8'b00110000;
	parameter	[7:0]	 	LCD_1			= 8'b00110001;
	parameter	[7:0]	 	LCD_2			= 8'b00110010;
	parameter	[7:0]	 	LCD_3			= 8'b00110011;
	parameter	[7:0]	 	LCD_4			= 8'b00110100;
	parameter	[7:0]	 	LCD_5			= 8'b00110101;
	parameter	[7:0]	 	LCD_6			= 8'b00110110;
	parameter	[7:0]	 	LCD_7			= 8'b00110111;
	parameter	[7:0]	 	LCD_8			= 8'b00111000;
	parameter	[7:0]	 	LCD_9			= 8'b00111001;
	parameter	[7:0]	 	LCD_A			= 8'b01000001;
	parameter	[7:0]	 	LCD_B			= 8'b01000010;
	parameter	[7:0]	 	LCD_C			= 8'b01000011;
	parameter	[7:0]	 	LCD_D			= 8'b01000100;
	parameter	[7:0]	 	LCD_E			= 8'b01000101;
	parameter	[7:0]	 	LCD_F			= 8'b01000110;
	parameter	[7:0]	 	LCD_G			= 8'b01000111;
	parameter	[7:0]	 	LCD_H			= 8'b01001000;
	parameter	[7:0]	 	LCD_I			= 8'b01001001;
	parameter	[7:0]	 	LCD_J			= 8'b01001010;
	parameter	[7:0]	 	LCD_K			= 8'b01001011;
	parameter	[7:0]	 	LCD_L			= 8'b01001100;
	parameter	[7:0]	 	LCD_M			= 8'b01001101;
	parameter	[7:0]	 	LCD_N			= 8'b01001110;
	parameter	[7:0]	 	LCD_O			= 8'b01001111;
	parameter	[7:0]	 	LCD_P			= 8'b01010000;
	parameter	[7:0]	 	LCD_Q			= 8'b01010001;
	parameter	[7:0]	 	LCD_R			= 8'b01010010;
	parameter	[7:0]	 	LCD_S			= 8'b01010011;
	parameter	[7:0]	 	LCD_T			= 8'b01010100;
	parameter	[7:0]	 	LCD_U			= 8'b01010101;
	parameter	[7:0]	 	LCD_V			= 8'b01010110;
	parameter	[7:0]	 	LCD_W			= 8'b01010111;
	parameter	[7:0]	 	LCD_X			= 8'b01011000;
	parameter	[7:0]	 	LCD_Y			= 8'b01011001;
	parameter	[7:0]	 	LCD_Z			= 8'b01011010;
	parameter	[7:0]	 	LCD_UNDER	= 8'b01011111;
	parameter	[7:0]	 	LCD_S_a		= 8'b01100001;
	parameter	[7:0]	 	LCD_S_b		= 8'b01100010;
	parameter	[7:0]	 	LCD_S_c		= 8'b01100011;
	parameter	[7:0]	 	LCD_S_d		= 8'b01100100;
	parameter	[7:0]	 	LCD_S_e		= 8'b01100101;
	parameter	[7:0]	 	LCD_S_f		= 8'b01100110;
	parameter	[7:0]	 	LCD_S_g		= 8'b01100111;
	parameter	[7:0]	 	LCD_S_h		= 8'b01101000;
	parameter	[7:0]	 	LCD_S_i		= 8'b01101001;
	parameter	[7:0]	 	LCD_S_j		= 8'b01101010;
	parameter	[7:0]	 	LCD_S_k		= 8'b01101011;
	parameter	[7:0]	 	LCD_S_l		= 8'b01101100;
	parameter	[7:0]	 	LCD_S_m		= 8'b01101101;
	parameter	[7:0]	 	LCD_S_n		= 8'b01101110;
	parameter	[7:0]	 	LCD_S_o		= 8'b01101111;
	parameter	[7:0]	 	LCD_S_p		= 8'b01110000;
	parameter	[7:0]	 	LCD_S_q		= 8'b01110001;
	parameter	[7:0]	 	LCD_S_r		= 8'b01110010;
	parameter	[7:0]	 	LCD_S_s		= 8'b01110011;
	parameter	[7:0]	 	LCD_S_t		= 8'b01110100;
	parameter	[7:0]	 	LCD_S_u		= 8'b01110101;
	parameter	[7:0]	 	LCD_S_v		= 8'b01110110;
	parameter	[7:0]	 	LCD_S_w		= 8'b01110111;
	parameter	[7:0]	 	LCD_S_x		= 8'b01111000;
	parameter	[7:0]	 	LCD_S_y		= 8'b01111001;
	parameter	[7:0]	 	LCD_S_z		= 8'b01111010;
	parameter	[7:0]	 	LCD_dot		= 8'b01100000;
	
reg [15:0] tx_clk_count=0; // clock count
reg [3:0] tx_bit_count=0; // bit count [start bit | d0 | d1 | d2 | d3 | d4 | d5 | d6 | d7 | stop bit]
reg [7:0] data_buffer_index=0;
reg [4:0] data_buffer_base=0;
reg [7:0] data_buffer[0:15]; // data buffer
wire [7:0] data_buffer2[0:23]; // data buffer
reg [7:0] data_tx=0; // data to transmit
reg [7:0] rx_data=0;
reg [3:0] rx_bit_count=0;
reg [11:0] rx_clk_count=0;
reg state_rx=0;
reg tx_bit=0;
wire rxd_w;
//
wire [39:0] bcd1;
wire [39:0] bcd2;
wire [39:0] bcd3;
wire [39:0] bcd4;
wire [39:0] bcd5;
reg [18:0]timer_cnt = 0;
function [7:0] ascii;
  input [4:0] hex;
  integer i;
  begin
		ascii = 0;
		if(hex <= 9)
			 ascii = hex + 8'h30; //10           + 0X30
		else
			 ascii = hex + 8'd55; //           + 0X37
  end
endfunction

   // Transmitter Process
    // at every rising edge of the clock
    always @ (posedge clk_main)
    begin
        if(reset == 1)begin
            tx_clk_count = 16'd0;
            tx_bit_count = 0;
            tx_bit = 1;                     // set idle
            data_buffer_index = 8'd0;          // data index
				timer_cnt = 19'd0;
        end
        else 
		  begin
            // transmit data until the index became the same with the base index
            //if ( data_buffer_index != data_buffer_base ) begin
				if(timer_cnt>19'd500000)
				begin
                if (tx_clk_count == CLOCKS_PER_BIT) begin
                    if (tx_bit_count == 0) begin
                        tx_bit = 1'b1;     // idle bit
                        tx_bit_count = 1'b1;
                        data_tx = data_buffer2[data_buffer_index];
                    end
                    else if (tx_bit_count == 1) begin
                        tx_bit = 0;     // start bit
                        tx_bit_count = 2;
                    end
                    else if (tx_bit_count <= MAX_TX_BIT_COUNT) begin
                        tx_bit = data_tx[tx_bit_count-2];   // data bits
                        tx_bit_count = tx_bit_count + 1'b1;
                    end
                    else begin
                        tx_bit = 1;     // stop bit
                        data_buffer_index = data_buffer_index + 1'b1;  // if the index exceeds its maximum, it becomes 0.
                        if(data_buffer_index==8'd24)  ///reset!
								begin
									data_buffer_index=8'd0;
									timer_cnt = 19'd0;
								end 
								tx_bit_count = 0;
                    end
                    tx_clk_count = 0;   // reset clock count
                end
                 
                tx_clk_count = tx_clk_count + 1'b1;        // increase clock count
            //end
				end
				else timer_cnt = timer_cnt + 1'b1;
        end
    end
     
    // Receiver Processs
    // at every rising edge of the clock
    always @ (posedge clk_main)
    begin
        if (reset == 1) begin
            rx_clk_count = 0;
            rx_bit_count = 0;
            data_buffer_base = 0;               // base index
            state_rx = 0;
        end
        else begin
            // if not receive mode and start bit is detected
            if (state_rx == 0 && RXD == 0) begin
                state_rx = 1;       // enter receive mode
                rx_bit_count = 0;
                rx_clk_count = 0;
            end
            // if receive mode
            else if (state_rx == 1) begin
                 
                if(rx_bit_count == 0 && rx_clk_count == CLOCKS_WAIT_FOR_RECEIVE) begin
                    rx_bit_count = 1;
                    rx_clk_count = 0;
                end
                else if(rx_bit_count < 9 && rx_clk_count == CLOCKS_PER_BIT) begin
                    rx_data[rx_bit_count-1] = RXD;
                    rx_bit_count = rx_bit_count + 1'b1;
                    rx_clk_count = 0;
                end
                // stop receiving
                else if(rx_bit_count == 9 && rx_clk_count == CLOCKS_PER_BIT && RXD == 1) begin
                    state_rx = 0;
                    rx_clk_count = 0;
                    rx_bit_count = 0;
                     
                    // transmit the received data back to the host PC.
                    data_buffer[data_buffer_base] = rx_data;
                    data_buffer_base = data_buffer_base + 1'b1;        // if the index exceeds its maximum, it becomes 0.
						  if(data_buffer_base == 4'd10)
						  begin
						  data_buffer_base = 4'd0;
						  end 
					 end
                // if stop bit is not received, clear the received data
                else if(rx_bit_count == 9 && rx_clk_count == CLOCKS_PER_BIT && RXD != 1) begin
                    state_rx = 0;
                    rx_clk_count = 0;
                    rx_bit_count = 0;
                    rx_data = 8'b00000000;      // invalidate
                end
                rx_clk_count = rx_clk_count + 1'b1;
            end
        end
         
    end
     
assign TXD = tx_bit;
assign data_buffer2[0] = 8'd0;
assign data_buffer2[1] = LCD_T;
assign data_buffer2[2] = LCD_S_h;
assign data_buffer2[3] = LCD_S_e;
assign data_buffer2[4] = LCD_S_r;
assign data_buffer2[5] = LCD_S_m;
assign data_buffer2[6] = LCD_S_i;
assign data_buffer2[7] = LCD_S_s;
assign data_buffer2[8] = LCD_S_t;
assign data_buffer2[9] = LCD_S_o;
assign data_buffer2[10] = LCD_S_r;

assign data_buffer2[11] = ascii(bcd1[39:36]);
assign data_buffer2[12] = ascii(bcd1[35:32]);
assign data_buffer2[13] = ascii(bcd1[31:28]);
assign data_buffer2[14] = ascii(bcd1[27:24]);
assign data_buffer2[15] = ascii(bcd1[23:20]);
assign data_buffer2[16] = ascii(bcd1[19:16]);
assign data_buffer2[17] = ascii(bcd1[15:12]);
 
assign data_buffer2[18] = ascii(bcd1[11:8]);
assign data_buffer2[19] = ascii(bcd1[7:4]);
assign data_buffer2[20] = LCD_dot;
assign data_buffer2[21] = ascii(bcd1[3:0]);

assign data_buffer2[22] = 8'h0d; //CF
assign data_buffer2[23] = 8'h0a; //LF

//assign data_buffer2[21] = ascii(bcd3[39:36]);
//assign data_buffer2[22] = ascii(bcd3[35:32]);
//assign data_buffer2[23] = ascii(bcd3[31:28]);
//assign data_buffer2[24] = ascii(bcd3[27:24]);
//assign data_buffer2[25] = ascii(bcd3[23:20]);
//assign data_buffer2[26] = ascii(bcd3[19:16]);
//assign data_buffer2[27] = ascii(bcd3[15:12]);
//assign data_buffer2[28] = ascii(bcd3[11:8]);
//assign data_buffer2[29] = ascii(bcd3[7:4]);
//assign data_buffer2[30] = ascii(bcd3[3:0]);
//
//assign data_buffer2[31] = ascii(bcd4[39:36]);
//assign data_buffer2[32] = ascii(bcd4[35:32]);
//assign data_buffer2[33] = ascii(bcd4[31:28]);
//assign data_buffer2[34] = ascii(bcd4[27:24]);
//assign data_buffer2[35] = ascii(bcd4[23:20]);
//assign data_buffer2[36] = ascii(bcd4[19:16]);
//assign data_buffer2[37] = ascii(bcd4[15:12]);
//assign data_buffer2[38] = ascii(bcd4[11:8]);
//assign data_buffer2[39] = ascii(bcd4[7:4]);
//assign data_buffer2[40] = ascii(bcd4[3:0]);
//
//assign data_buffer2[41] = ascii(bcd5[39:36]);
//assign data_buffer2[42] = ascii(bcd5[35:32]);
//assign data_buffer2[43] = ascii(bcd5[31:28]);
//assign data_buffer2[44] = ascii(bcd5[27:24]);
//assign data_buffer2[45] = ascii(bcd5[23:20]);
//assign data_buffer2[46] = ascii(bcd5[19:16]);
//assign data_buffer2[47] = ascii(bcd5[15:12]);
//assign data_buffer2[48] = ascii(bcd5[11:8]);
//assign data_buffer2[49] = ascii(bcd5[7:4]);
//assign data_buffer2[50] = ascii(bcd5[3:0]);

//assign data_buffer2[51] = 8'h0d; //CF
//assign data_buffer2[52] = 8'h0a; //LF
hextobcd hextobcd1
(
	.hex(PrintfData1),
   .bcdout(bcd1)
);
//hextobcd hextobcd2
//(
//	.hex(PrintfData2),
//   .bcdout(bcd2)
//);
//
//hextobcd hextobcd3
//(
//	.hex(PrintfData3),
//   .bcdout(bcd3)
//);
//hextobcd hextobcd4
//(
//	.hex(PrintfData4),
//   .bcdout(bcd4)
//);
//hextobcd hextobcd5
//(
//	.hex(PrintfData5),
//   .bcdout(bcd5)
//);
endmodule


