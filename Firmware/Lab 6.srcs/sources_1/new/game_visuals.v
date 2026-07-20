`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 02:58:40 AM
// Design Name: 
// Module Name: game_visuals
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


module game_visuals(

    input [15:0] row_i,
    input [15:0] col_i,
    input hovering_i,
    input flicker_i,
    
    input [15:0] slug_x_i,
    
    input [7:0] energy_i,
    
    input [15:0] trainXA_y_i,
    input [15:0] trainXA_length_i,
    input [15:0] trainXB_y_i,
    input [15:0] trainXB_length_i,
    input [15:0] trainYA_y_i,
    input [15:0] trainYA_length_i,
    input [15:0] trainYB_y_i,
    input [15:0] trainYB_length_i,
    input [15:0] trainZA_y_i,
    input [15:0] trainZA_length_i,
    input [15:0] trainZB_y_i,
    input [15:0] trainZB_length_i,
    
    input [15:0] sw_i,
    
    output [3:0] vgaRed_o,
    output [3:0] vgaGreen_o,
    output [3:0] vgaBlue_o
    );
    
// ---------- colors ----------
    wire [11:0] COLOR_BLACK  = 12'h000;
    wire [11:0] COLOR_WHITE  = 12'hFFF;
    wire [11:0] COLOR_YELLOW = 12'hFF0;
    wire [11:0] COLOR_BLUE   = 12'h00F;
    wire [11:0] COLOR_GREEN  = 12'h0F0;
    wire [11:0] COLOR_PURPLE = 12'hF0F;
    wire [11:0] COLOR_RED    = 12'hF00;
    
// ---------- standardized variables ----------
    // Treat row/col as (y, x)
    wire [9:0] x = col_i[9:0];  // horizontal (0..799)
    wire [9:0] y = row_i[9:0];  // vertical   (0..524)
    
    // Visible 640x480 area
    wire active_video = (x < 10'd640) & (y < 10'd480);
    
    
// ---------- border ----------
    wire border_pixel = active_video & (
            (x < 8) | (x >= 10'd632) |  
            (y < 8) | (y >= 10'd472)      
        );
    
// ---------- player ----------
    wire [9:0] player_x = slug_x_i;
    wire [9:0] player_y = 10'd360;
    wire [9:0] player_width = 10'd16;
    wire [9:0] player_height = 10'd16;
    
    wire player_pixel = active_video &
                    (x >= player_x) & (x <  player_x + player_width) &
                    (y >= player_y) & (y <  player_y + player_height);

    
    
    
// ---------- energy bar ----------
    wire [9:0] energy_x = 10'd50;
    wire [9:0] energy_y = 10'd250 - energy_i;
    wire [9:0] energy_width = 10'd20;
    wire [9:0] energy_height = energy_i;
    
    wire energy_pixel = active_video &
                    (x >= energy_x) & (x <  energy_x + energy_width) &
                    (y >= energy_y) & (y <  energy_y + energy_height);

// ---------- trains ----------     
    // trains on X
    wire XA_pixel = active_video & 
                    (x >= 10'd390) & (x < 10'd450) & 
                    (y >= trainXA_y_i - trainXA_length_i) & (y < trainXA_y_i);
    wire XB_pixel = active_video & 
                    (x >= 10'd390) & (x < 10'd450) & 
                    (y >= trainXB_y_i - trainXB_length_i) & (y < trainXB_y_i);
                    
    // trains on Y
    wire YA_pixel = active_video & 
                    (x >= 10'd460) & (x < 10'd520) & 
                    (y >= trainYA_y_i - trainYA_length_i) & (y < trainYA_y_i);
    wire YB_pixel = active_video & 
                    (x >= 10'd460) & (x < 10'd520) & 
                    (y >= trainYB_y_i - trainYB_length_i) & (y < trainYB_y_i);
                    
    // trains on Z
    wire ZA_pixel = active_video & 
                    (x >= 10'd530) & (x < 10'd590) & 
                    (y >= trainZA_y_i - trainZA_length_i) & (y < trainZA_y_i);
    wire ZB_pixel = active_video & 
                    (x >= 10'd530) & (x < 10'd590) & 
                    (y >= trainZB_y_i - trainZB_length_i) & (y < trainZB_y_i);
                    
                    
    wire train_pixel = XA_pixel | XB_pixel | YA_pixel | YB_pixel | ZA_pixel | ZB_pixel;
        
// ---------- tracks ----------
    // implement tracks for extra credit
    wire in_lane = ((x > 10'd390 & x < 10'd450) | (x > 10'd460 & x < 10'd520) | (x > 10'd530 & x < 10'd590));
    wire on_track = (y > 10'd8 & y < 10'd480) & (y[3:0] < 4);
    
    wire track_pixel = active_video & in_lane & on_track & sw_i[0];

            
// ---------- output ----------
    wire [11:0] color = border_pixel ? COLOR_WHITE :
                        player_pixel ? ( (hovering_i) ? (flicker_i ? COLOR_PURPLE : COLOR_BLACK) : COLOR_YELLOW) : 
                        energy_pixel ? COLOR_GREEN :  
                        train_pixel  ? COLOR_BLUE :
                        track_pixel  ? COLOR_RED :
                                       COLOR_BLACK;        
    
    assign vgaRed_o   = color[11:8];
    assign vgaGreen_o = color[7:4];
    assign vgaBlue_o  = color[3:0];
    
endmodule
