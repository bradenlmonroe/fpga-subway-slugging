`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2025 11:12:55 PM
// Design Name: 
// Module Name: top
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


module top(
    input btnC,
    input btnD,
    input btnU,
    input btnL,
    input btnR,
    input [15:0] sw,
    input clkin,
    input greset,

    // Outputs
    output [3:0] an,
    output dp,
    output [6:0] seg,
    output [15:0] led,
    output Hsync,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output [3:0] vgaRed,
    output Vsync,
    output oops,
    output rgb_oops
    
    );
    
    wire clk, digsel;
    labVGA_clks not_so_slow (
        .clkin(clkin),
        .greset(btnD),
        .clk(clk),
        .digsel(digsel)
    );

    wire [15:0] row, col;
    wire new_frame;
    pixel_address zaddy (.clk_i(clk), .row_o(row), .col_o(col), .new_frame_o(new_frame));
    
    wire HS, VS;
    syncs let_that_sink_in (.clk_i(clk), .Hcount_i(col), .Vcount_i(row), .Hsync_o(HS), .Vsync_o(VS));
    
    FDRE #(.INIT(1'b1)) HsyncFF (.C(clk), .R(1'b0), .CE(1'b1), .D(HS), .Q(Hsync));
    FDRE #(.INIT(1'b1)) VsyncFF (.C(clk), .R(1'b0), .CE(1'b1), .D(VS), .Q(Vsync));
    
    wire [11:0] color = Hsync & Vsync ? 12'hFFF : 12'h000;
    
    assign vgaRed_o   = color[11:8];
    assign vgaGreen_o = color[7:4];
    assign vgaBlue_o  = color[3:0];
    
endmodule
