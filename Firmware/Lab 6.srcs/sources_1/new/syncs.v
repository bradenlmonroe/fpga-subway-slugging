`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2025 03:46:46 PM
// Design Name: 
// Module Name: syncs
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module syncs(
    input [15:0] Hcount_i,
    input [15:0] Vcount_i,
    output Hsync_o,
    output Vsync_o
    );
    
    assign Hsync_o = (Hcount_i < 16'd670) | (Hcount_i > 16'd765);  // low between 655-750
    assign Vsync_o = (Vcount_i < 16'd489) | (Vcount_i > 16'd490);  // low between 489-490
    
    
endmodule
