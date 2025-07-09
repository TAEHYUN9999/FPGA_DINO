`timescale 1ns / 1ps

// bin2seg  ,  / pin 
module bin2seg(
   input         [3:0]      bin_data,
   output   wire   [7:0]      seg_data
);

//   7-segment  
assign  seg_data = (bin_data==0)?8'b11111100:
                   (bin_data==1)?8'b01100000:
                   (bin_data==2)?8'b11011010:
                   (bin_data==3)?8'b11110010:
                   (bin_data==4)?8'b01100110:
                   (bin_data==5)?8'b10110110:
                   (bin_data==6)?8'b10111110:
                   (bin_data==7)?8'b11100100:
                   (bin_data==8)?8'b11111110:
                   8'b11110110;
endmodule 