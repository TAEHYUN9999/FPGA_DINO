`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:06 02/11/2015 
// Design Name: 
// Module Name:    top 
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
module top_tem(
	input osc,
	inout Thermistor,
	input RXD,
	output TXD,
	output [31:0]PrintfData1
    );

//wire [31:0]PrintfData1;
//wire [31:0]PrintfData2;
//wire [31:0]PrintfData3;
//wire [31:0]PrintfData4;
//wire [31:0]PrintfData5;
wire clk_main;
wire clk_fb, clk_fb2;
/////////////////////////////////////////////////////////////////////
// main clock generation 50MHz
/////////////////////////////////////////////////////////////////////
DCM_SP #(
    .CLKIN_PERIOD       (20),
    .CLKFX_DIVIDE	    (2),	
    .CLKFX_MULTIPLY   (2),
    .CLKDV_DIVIDE       (2.0),
    .CLK_FEEDBACK       ("1X")
)
DCM_SP_1 (
    .CLKIN    (osc),
    .CLKFB    (clk_fb),
    .CLK0     (clk_fb),
    .RST      (1'b0),
    .CLKFX    (clk_main),
    .PSEN     (1'b0)
);
	 
wire [7:0]sec;
wire [7:0]minute;
wire [7:0]hour;
reg [1:0]reset_cnt = 0;
reg reset = 1'b1;

always@(posedge clk_main)
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

USB Printf
(
	.clk_main(clk_main),   
	.reset(reset),	 
	.RXD(RXD),
	.TXD(TXD),
	.PrintfData1(PrintfData1[30:0])
);
Thermistor DS18B20
(
	.clk_main(clk_main),   
	.reset(reset),	 
	.Thermistor2(Thermistor),
	.PrintfData4(PrintfData1)
);
endmodule
