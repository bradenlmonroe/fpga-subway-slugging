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


module pixel_address(
    input clk_i,
    output [15:0] row_o,
    output [15:0] col_o
    );
    
    // dummy variables
    wire [15:0] curr_row, curr_col;
    wire row_dtc, row_utc, col_dtc, col_utc;
    wire [15:0] zero = 16'b0;
    
    // counters
        // go to the next col every (clock? frame?)
    wire col_edge = (curr_col == 16'd799);
    countUD16L col (.clk_i(clk_i), .up_i(1'b1), .dw_i(1'b0), .ld_i(col_edge), .Din_i(zero), .Q_o(curr_col), .utc_o(col_utc), .dtc_o(col_dtc));
    
        // go to the next row after reaching the last col 
    wire row_edge = (curr_row == 16'd524);
    countUD16L row (.clk_i(clk_i), .up_i(col_edge), .dw_i(1'b0), .ld_i(row_edge), .Din_i(zero), .Q_o(curr_row), .utc_o(row_utc), .dtc_o(row_dtc));
    
    // outputs
    assign row_o = curr_row;
    assign col_o = curr_col;

endmodule
