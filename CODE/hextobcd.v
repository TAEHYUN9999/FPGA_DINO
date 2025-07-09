`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:00 04/18/2014 
// Design Name: 
// Module Name:    hextobcd 
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
module hextobcd(
    input [30:0] hex,
    /*
    output [3:0] bcd0,
    output [3:0] bcd1,
    output [3:0] bcd2,
    output [3:0] bcd3,
    output [3:0] bcd4,
    output [3:0] bcd5,
    output [3:0] bcd6,
    output [3:0] bcd7,
    output [3:0] bcd8,
    output [3:0] bcd9
    */
    output [39:0] bcdout
    );

reg [30:0] bin;
//reg [39:0] bcd;
reg [39:0] result;
always @(hex)
begin
    bin = hex;
    result = 0;
    repeat(30)
    begin
        result[0] = bin[30];
        if(result[3:0] > 4)
            result[3:0] = result[3:0] + 4'd3;
        if(result[7:4] > 4)
            result[7:4] = result[7:4] + 4'd3;
        if(result[11:8] > 4)
            result[11:8] = result[11:8] + 4'd3;
        if(result[15:12] > 4)
            result[15:12] = result[15:12] + 4'd3;
        if(result[19:16] > 4)
            result[19:16] = result[19:16] + 4'd3;
        if(result[23:20] > 4)
            result[23:20] = result[23:20] + 4'd3;
        if(result[27:24] > 4)
            result[27:24] = result[27:24] + 4'd3;
        if(result[31:28] > 4)
            result[31:28] = result[31:28] + 4'd3;
        if(result[35:32] > 4)
            result[35:32] = result[35:32] + 4'd3;
				
        result = result << 1; //0~30                    
        bin = bin << 1; //30~0                     result       
    end
    result[0] = bin[30];
//    bcd <= result;
end

assign bcdout = result;

// too much logic - fail
/*
always @(hex)
begin
    bcd_f[9] <= hex / 1000000000;
    bcd_f[8] <= (hex / 100000000) - (bcd_f[9] * 10);
    bcd_f[7] <= (hex / 10000000) - (bcd_f[9] * 100 + bcd_f[8] * 10);
    bcd_f[6] <= (hex / 1000000) - (bcd_f[9] * 1000 + bcd_f[8] * 100 + bcd_f[7] * 10);
    bcd_f[5] <= (hex / 100000) - (bcd_f[9] * 10000 + bcd_f[8] * 1000 + bcd_f[7] * 100 + bcd_f[6] * 10);
    bcd_f[4] <= (hex / 10000) - (bcd_f[9] * 100000 + bcd_f[8] * 10000 + bcd_f[7] * 1000 + bcd_f[6] * 100 + bcd_f[5] * 10);
    bcd_f[3] <= (hex / 1000) - (bcd_f[9] * 1000000 + bcd_f[8] * 100000 + bcd_f[7] * 10000 + bcd_f[6] * 1000 + bcd_f[5] * 100 + bcd_f[4] * 10);
    bcd_f[2] <= (hex / 100) - (bcd_f[9] * 10000000 + bcd_f[8] * 1000000 + bcd_f[7] * 100000 + bcd_f[6] * 10000 + bcd_f[5] * 1000 + bcd_f[4] * 100 + bcd_f[3] * 10);
    bcd_f[1] <= (hex / 10) - (bcd_f[9] * 100000000 + bcd_f[8] * 10000000 + bcd_f[7] * 1000000 + bcd_f[6] * 100000 + bcd_f[5] * 10000 + bcd_f[4] * 1000 + bcd_f[3] * 100 + bcd_f[2] * 10);
    bcd_f[0] <= (hex / 1) - (bcd_f[9] * 1000000000 + bcd_f[8] * 100000000 + bcd_f[7] * 10000000 + bcd_f[6] * 1000000 + bcd_f[5] * 100000 + bcd_f[4] * 10000 + bcd_f[3] * 1000 + bcd_f[2] * 100 + bcd_f[1] * 10);
end
*/

/*
assign bcd9 = bcd_f[9];
assign bcd8 = bcd_f[8];
assign bcd7 = bcd_f[7];
assign bcd6 = bcd_f[6];
assign bcd5 = bcd_f[5];
assign bcd4 = bcd_f[4];
assign bcd3 = bcd_f[3];
assign bcd2 = bcd_f[2];
assign bcd1 = bcd_f[1];
assign bcd0 = bcd_f[0];
*/


endmodule
