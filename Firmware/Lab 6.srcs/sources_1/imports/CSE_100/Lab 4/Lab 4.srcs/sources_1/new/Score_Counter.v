`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2025 02:42:13 AM
// Design Name: 
// Module Name: Score_Counter
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


module Score_Counter(   
    input clk_i,
    input inc_i,
    input dec_i,
    output [3:0] Q_o
    );
    
    // use countUD16L again!
    wire [3:0] unused, count_out;
    wire [0:0] utc, dtc;
    countUD4L counter (
        .clk_i(clk_i),
        .up_i(inc_i),
        .dw_i(dec_i),
        .ld_i(1'b0),
        .Din_i(unused),
        
        .Q_o(count_out),
        .utc_o(utc),
        .dtc_o(dtc)
    );
    
    assign Q_o = count_out;
    
endmodule
