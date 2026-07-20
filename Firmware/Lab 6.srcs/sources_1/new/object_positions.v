`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2025 01:58:56 PM
// Design Name: 
// Module Name: object_positions
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


module object_positions(
    input clk_i,
    input frame_tick_i,
    input moving_left_i,
    input moving_right_i,
    input hovering_i,
    input play_game_i,
    
    output [15:0] slug_x_o,
    
    output [7:0] energy_o,
    output collision_o,
    output inc_score_o,
    
    output [15:0] trainXA_y_o,
    output [15:0] trainXB_y_o,
    output [15:0] trainYA_y_o,
    output [15:0] trainYB_y_o,
    output [15:0] trainZA_y_o,
    output [15:0] trainZB_y_o,
    
    output [6:0] trainXA_length_o,
    output [6:0] trainXB_length_o,
    output [6:0] trainYA_length_o,
    output [6:0] trainYB_length_o,
    output [6:0] trainZA_length_o,
    output [6:0] trainZB_length_o
    );
    
// ---------- moving the player ----------
    wire [15:0] start = 16'b0000000111100010;
    
    // getting the next position
    wire [15:0] q_curr, q_next;

    assign q_next = moving_right_i ? q_curr + 16'd2 :
                    moving_left_i  ? q_curr - 16'd2 :
                    q_curr;
                   // if on frame tick, if moving right, shift right by 2 pixels
                   // if on frame tick, if moving left, shift left by 2 pixels
                   // if on frame tick, if not moving, stay at current position
                   // if not on frame tick, stay at current position
    
    // all 16 positions fdres are spaces out to emulate the initial position of x = 530 (width is 640, centered on middle track is 640 - 60 - 10 - 30
    FDRE #(.INIT(1'b0)) QF9FF [15:9] (
        .C(clk_i),
        .CE(frame_tick_i),
        .R(1'b0),      
        .D(q_next[15:9]),
        .Q(q_curr[15:9])
    );
    FDRE #(.INIT(1'b1)) Q8765FF[8:5] (
        .C({4{clk_i}}),
        .R({4{1'b0}}),
        .CE({4{frame_tick_i}}),
        .D(q_next[8:5]),
        .Q(q_curr[8:5])
    );
    FDRE #(.INIT(1'b0)) Q432FF[4:2] (
        .C({3{clk_i}}),
        .R({3{1'b0}}),
        .CE({3{frame_tick_i}}),
        .D(q_next[4:2]),
        .Q(q_curr[4:2])
    );
    FDRE #(.INIT(1'b1)) Q1FF (
        .C(clk_i),
        .R(1'b0),
        .CE(frame_tick_i),
        .D(q_next[1]),
        .Q(q_curr[1])
    );
    FDRE #(.INIT(1'b1)) Q0FF (
        .C(clk_i),
        .R(1'b0),
        .CE(frame_tick_i),
        .D(q_next[0]),
        .Q(q_curr[0])
    );

    assign slug_x_o = q_curr;
    
// ---------- energy bar ----------
    wire [7:0] energy_curr, energy_next;
    
    assign energy_next = (~hovering_i) ? ((energy_curr < 8'd192) ? (energy_curr + 8'd1) : 8'd192) 
                                       : ((energy_curr > 8'd0) ? (energy_curr - 8'd1) : 8'd0);

    FDRE #(.INIT(1'b0)) QenergyFF[7:0] (
        .C({8{clk_i}}),
        .R(8'b0),
        .CE({8{frame_tick_i}}),
        .D(energy_next),
        .Q(energy_curr)
    );
    
    assign energy_o = energy_curr;

    
// ---------- moving the trains ----------
    // start of game
    wire [15:0] num_frames;
    countUD16L frame_counter (.clk_i(clk_i), 
                              .up_i(frame_tick_i & play_game_i), 
                              .dw_i(1'b0), 
                              .ld_i(1'b0), 
                              .Din_i(16'b0), 
                              .Q_o(num_frames), 
                              .utc_o(), 
                              .dtc_o());
                              
    // ----- left lane -----
    
        // train YA dummy variables
    wire [15:0] XA_y, XA_delay_frames;
    wire XA_moving;
    wire [6:0] XA_delay, XA_length;
    
        // train YB dummy variables
    wire [15:0] XB_y, XB_delay_frames;
    wire XB_moving;
    wire [6:0] XB_delay, XB_length;
    
        // respawn, start signals
    wire XA_start = (num_frames == 16'd1) | (XB_y == 16'd440);
    wire XA_respawn = (XA_y == 16'd480 + {9'd0, XA_length});
    
    
    wire XB_start = (XA_y == 16'd440);
    wire XB_respawn = (XB_y == 16'd480 + {9'd0, XB_length});
    
        // first train
    train_fsm XA (.clk_i(clk_i), .start_i(XA_start), .respawn_i(XA_respawn), .salt_i(8'h23), .moving_o(XA_moving), .length_o(XA_length), .delay_o(XA_delay));
        
        // find out how much delay is left
    countUD16L XA_delayer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & XA_moving), 
                       .dw_i(1'b0), 
                       .ld_i(XA_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(XA_delay_frames), 
                       .utc_o(), 
                       .dtc_o());
    wire XA_no_more_delay = (XA_delay_frames >= {9'd0, XA_delay});                 
    
        // move the train down 1 pixel per frame
    countUD16L XA_yer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & XA_moving & XA_no_more_delay), 
                       .dw_i(1'b0), 
                       .ld_i(XA_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(XA_y), 
                       .utc_o(), 
                       .dtc_o());
    // output ya_y
    assign trainXA_y_o = XA_y;     
    assign trainXA_length_o = XA_length;               
                       
                       
                       
                       
        // second_train
    train_fsm XB (.clk_i(clk_i), .start_i(XB_start), .respawn_i(XB_respawn), .salt_i(8'h1), .moving_o(XB_moving), .length_o(XB_length), .delay_o(XB_delay));
        
        // find out how much delay is left
    countUD16L XB_delayer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & XB_moving), 
                       .dw_i(1'b0), 
                       .ld_i(XB_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(XB_delay_frames), 
                       .utc_o(), 
                       .dtc_o());
    wire XB_no_more_delay = (XB_delay_frames >= {9'd0, XB_delay});                 
    
        // move the train down 1 pixel per frame
    countUD16L XB_yer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & XB_moving & XB_no_more_delay), 
                       .dw_i(1'b0), 
                       .ld_i(XB_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(XB_y), 
                       .utc_o(), 
                       .dtc_o());
    // output ya_y
    assign trainXB_y_o = XB_y; 
    assign trainXB_length_o = XB_length;
    
    // ----- middle lane -----
    
        // train YA dummy variables
    wire [15:0] YA_y, YA_delay_frames;
    wire YA_moving;
    wire [6:0] YA_delay, YA_length;
    
        // train YB dummy variables
    wire [15:0] YB_y, YB_delay_frames;
    wire YB_moving;
    wire [6:0] YB_delay, YB_length;
    
        // respawn, start signals
    wire YA_start = (num_frames == 16'd480) | (YB_y == 16'd440);
    wire YA_respawn = (YA_y == 16'd480 + {9'd0, YA_length});
    
    
    wire YB_start = (YA_y == 16'd440);
    wire YB_respawn = (YB_y == 16'd480 + {9'd0, YB_length});
    
        // first train
    train_fsm YA (.clk_i(clk_i), .start_i(YA_start), .respawn_i(YA_respawn), .salt_i(8'h59), .moving_o(YA_moving), .length_o(YA_length), .delay_o(YA_delay));
        
        // find out how much delay is left
    countUD16L YA_delayer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & YA_moving), 
                       .dw_i(1'b0), 
                       .ld_i(YA_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(YA_delay_frames), 
                       .utc_o(), 
                       .dtc_o());
    wire YA_no_more_delay = (YA_delay_frames >= {9'd0, YA_delay});                 
    
        // move the train down 1 pixel per frame
    countUD16L YA_yer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & YA_moving & YA_no_more_delay), 
                       .dw_i(1'b0), 
                       .ld_i(YA_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(YA_y), 
                       .utc_o(), 
                       .dtc_o());
    // output ya_y
    assign trainYA_y_o = YA_y;     
    assign trainYA_length_o = YA_length;               
                       
                       
                       
                       
        // second_train
    train_fsm YB (.clk_i(clk_i), .start_i(YB_start), .respawn_i(YB_respawn), .salt_i(8'h26), .moving_o(YB_moving), .length_o(YB_length), .delay_o(YB_delay));
        
        // find out how much delay is left
    countUD16L YB_delayer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & YB_moving), 
                       .dw_i(1'b0), 
                       .ld_i(YB_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(YB_delay_frames), 
                       .utc_o(), 
                       .dtc_o());
    wire YB_no_more_delay = (YB_delay_frames >= {9'd0, YB_delay});                 
    
        // move the train down 1 pixel per frame
    countUD16L YB_yer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & YB_moving & YB_no_more_delay), 
                       .dw_i(1'b0), 
                       .ld_i(YB_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(YB_y), 
                       .utc_o(), 
                       .dtc_o());
    // output ya_y
    assign trainYB_y_o = YB_y; 
    assign trainYB_length_o = YB_length;  
    
    
    // ----- rightlane -----
    
        // train YA dummy variables
    wire [15:0] ZA_y, ZA_delay_frames;
    wire ZA_moving;
    wire [6:0] ZA_delay, ZA_length;
    
        // train YB dummy variables
    wire [15:0] ZB_y, ZB_delay_frames;
    wire ZB_moving;
    wire [6:0] ZB_delay, ZB_length;
    
        // respawn, start signals
    wire ZA_start = (num_frames == 16'd120) | (ZB_y == 16'd400);
    wire ZA_respawn = (ZA_y == 16'd480 + {9'd0, ZA_length});
    
    
    wire ZB_start = (ZA_y == 16'd400);
    wire ZB_respawn = (ZB_y == 16'd480 + {9'd0, ZB_length});
    
        // first train
    train_fsm ZA (.clk_i(clk_i), .start_i(ZA_start), .respawn_i(ZA_respawn), .salt_i(8'h73), .moving_o(ZA_moving), .length_o(ZA_length), .delay_o(ZA_delay));
        
        // find out how much delay is left
    countUD16L ZA_delayer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & ZA_moving), 
                       .dw_i(1'b0), 
                       .ld_i(ZA_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(ZA_delay_frames), 
                       .utc_o(), 
                       .dtc_o());
    wire ZA_no_more_delay = (ZA_delay_frames >= {9'd0, ZA_delay});                 
    
        // move the train down 1 pixel per frame
    countUD16L ZA_yer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & ZA_moving & ZA_no_more_delay), 
                       .dw_i(1'b0), 
                       .ld_i(ZA_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(ZA_y), 
                       .utc_o(), 
                       .dtc_o());
    // output ya_y
    assign trainZA_y_o = ZA_y;     
    assign trainZA_length_o = ZA_length;               
                       
                       
                       
                       
        // second_train
    train_fsm ZB (.clk_i(clk_i), .start_i(ZB_start), .respawn_i(ZB_respawn), .salt_i(8'h46), .moving_o(ZB_moving), .length_o(ZB_length), .delay_o(ZB_delay));
        
        // find out how much delay is left
    countUD16L ZB_delayer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & ZB_moving), 
                       .dw_i(1'b0), 
                       .ld_i(ZB_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(ZB_delay_frames), 
                       .utc_o(), 
                       .dtc_o());
    wire ZB_no_more_delay = (ZB_delay_frames >= {9'd0, ZB_delay});                 
    
        // move the train down 1 pixel per frame
    countUD16L ZB_yer (.clk_i(clk_i), 
                       .up_i(play_game_i & frame_tick_i & ZB_moving & ZB_no_more_delay), 
                       .dw_i(1'b0), 
                       .ld_i(ZB_respawn), 
                       .Din_i(16'b0), 
                       .Q_o(ZB_y), 
                       .utc_o(), 
                       .dtc_o());
    // output ya_y
    assign trainZB_y_o = ZB_y; 
    assign trainZB_length_o = ZB_length;

// ---------- inc_score ----------
    assign inc_score_o = (XA_y == 16'd377) | (XB_y == 16'd377) | (YA_y == 16'd377) | (YB_y == 16'd377) | (ZA_y == 16'd377) | (ZB_y == 16'd377);

// ---------- collision ----------
    
    // collision occurs if the slug overlaps any part of the  train
    wire collision_XA = ((q_curr + 16'd16 > 16'd390) & (q_curr < 16'd450)) 
                      & ((16'd360 + 16'd16 > XA_y - {9'd0, XA_length}) & (16'd360 < XA_y));
    wire collision_XB = ((q_curr + 16'd16 > 16'd390) & (q_curr < 16'd450)) 
                      & ((16'd360 + 16'd16 > XB_y - {9'd0, XB_length}) & (16'd360 < XB_y));
    
    // collision occurs if the slug overlaps any part of the YA train
    wire collision_YA = ((q_curr + 16'd16 > 16'd460) & (q_curr < 16'd520)) 
                      & ((16'd360 + 16'd16 > YA_y - {9'd0, YA_length}) & (16'd360 < YA_y));
    wire collision_YB = ((q_curr + 16'd16 > 16'd460) & (q_curr < 16'd520)) 
                      & ((16'd360 + 16'd16 > YB_y - {9'd0, YB_length}) & (16'd360 < YB_y));
                      
    // collision occurs if the slug overlaps any part of the YA train
    wire collision_ZA = ((q_curr + 16'd16 > 16'd530) & (q_curr < 16'd590)) 
                      & ((16'd360 + 16'd16 > ZA_y - {9'd0, ZA_length}) & (16'd360 < ZA_y));
    wire collision_ZB = ((q_curr + 16'd16 > 16'd530) & (q_curr < 16'd590)) 
                      & ((16'd360 + 16'd16 > ZB_y - {9'd0, ZB_length}) & (16'd360 < ZB_y));

    assign collision_o = ~hovering_i & ((collision_XA | collision_XB) | (collision_YA | collision_YB) | (collision_ZA | collision_ZB));
    
    
endmodule
