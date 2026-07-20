`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 04:06:40 PM
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


module topLevel(
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    input btnC,
    input [15:0] sw,
    input clkin,

   // Outputs
    output [3:0] an,
    output [6:0] seg,
    output [15:0] led,
    output Hsync,
    output Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen
    );
    
// ---------- clocks ----------
    wire clk, digsel;

    labVGA_clks not_so_slow (
        .clkin(clkin),
        .greset(btnD),
        .clk(clk),
        .digsel(digsel)
    );


// ---------- pixel address and syncs ----------

    // pixel address
    wire [15:0] row, col;
    pixel_address addy (.clk_i(clk), .row_o(row), .col_o(col));
    
    // sync it up
    wire HS, VS, new_frame;
    syncs let_that_sink_in (.Hcount_i(col), .Vcount_i(row), .Hsync_o(HS), .Vsync_o(VS));
    
    FDRE #(.INIT(1'b1)) HsyncFF (.C(clk), .R(1'b0), .CE(1'b1), .D(HS), .Q(Hsync));
    FDRE #(.INIT(1'b1)) VsyncFF (.C(clk), .R(1'b0), .CE(1'b1), .D(VS), .Q(Vsynced));
    assign Vsync = Vsynced;
    
    edge_detector inspector_gadget (.clk_i(clk), .button_i(Vsynced), .edge_o(new_frame));
    
    
//    // to count each frame
    wire [15:0] num_frames;
    wire utc, dtc;
    wire in_transition = moving_left | moving_right;
    
    countUD16L frame_counter (.clk_i(clk), 
                              .up_i(new_frame & in_transition), 
                              .dw_i(1'b0), 
                              .ld_i(~in_transition), 
                              .Din_i(16'b0), 
                              .Q_o(num_frames), 
                              .utc_o(utc), 
                              .dtc_o(dtc));
    wire thirtyfive_frames = (num_frames == 16'd35);
    
    
    

// ----------- fsm inputs -----------
    wire btnU_sync, btnD_sync, btnL_sync, btnR_sync, btnC_sync;
    FDRE #(.INIT(1'b0)) btnUFF (.C(clk), .R(1'b0), .CE(1'b1), .D(btnU), .Q(btnU_sync));
    FDRE #(.INIT(1'b0)) btnDFF (.C(clk), .R(1'b0), .CE(1'b1), .D(btnD), .Q(btnD_sync));
    FDRE #(.INIT(1'b0)) btnLFF (.C(clk), .R(1'b0), .CE(1'b1), .D(btnL), .Q(btnL_sync));
    FDRE #(.INIT(1'b0)) btnRFF (.C(clk), .R(1'b0), .CE(1'b1), .D(btnR), .Q(btnR_sync));
    FDRE #(.INIT(1'b0)) btnCFF (.C(clk), .R(1'b0), .CE(1'b1), .D(btnC), .Q(btnC_sync));

// ---------- all fsms ----------
    
    // dummy variables
    wire play_game;
    wire [7:0] energy;
    wire energy_left = energy > 7'b0;
    wire collision, collision_sync;
    wire moving_left, moving_right, hovering;
    wire [3:0] lives;
    
    // system fsm
    edge_detector collision_dect (.clk_i(clk), .button_i(collision), .edge_o(collision_sync));
    system_fsm Sys (.clk_i(clk), .btnC_sync_i(btnC_sync), .btnD_sync_i(btnD_sync), .collision_i(collision_sync), .sw_i(sw), .btnL_sync_i(btnL_sync),
                    .play_game_o(play_game), .lives_o(lives));
    
    // slug fsm
    slug_fsm sammy (.clk_i(clk), .play_game_i(play_game), .btnL_sync_i(btnL_sync), .btnR_sync_i(btnR_sync), .btnU_sync_i(btnU_sync), .thirtyfive_frames_i(thirtyfive_frames), .energy_left_i(energy_left),
                    .moving_left_o(moving_left), .moving_right_o(moving_right), .hovering_o(hovering));

// ---------- update positions of game objects ----------

    wire [15:0] slug_x;
    wire [15:0] trainXA_y, trainXB_y, trainYA_y, trainYB_y, trainZA_y, trainZB_y;
    wire [6:0]  trainXA_length, trainXB_length, trainYA_length, trainYB_length, trainZA_length, trainZB_length;
    wire inc_score;
    
    object_positions  positron (.clk_i(clk), .frame_tick_i(new_frame), .moving_left_i(moving_left), .moving_right_i(moving_right), .hovering_i(hovering), .play_game_i(play_game),
    .slug_x_o(slug_x), .energy_o(energy), .collision_o(collision), .inc_score_o(inc_score),
    .trainXA_y_o(trainXA_y),           .trainXB_y_o(trainXB_y),           .trainYA_y_o(trainYA_y),           .trainYB_y_o(trainYB_y),           .trainZA_y_o(trainZA_y),           .trainZB_y_o(trainZB_y), 
    .trainXA_length_o(trainXA_length), .trainXB_length_o(trainXB_length), .trainYA_length_o(trainYA_length), .trainYB_length_o(trainYB_length), .trainZA_length_o(trainZA_length), .trainZB_length_o(trainZB_length));

// ---------- vga output ---------
    
    // implement slow flicker for extra credit
    wire [15:0] flicker_frames;
    countUD16L flickerer (.clk_i(clk), 
                          .up_i(new_frame & hovering), 
                          .dw_i(1'b0), 
                          .ld_i(~hovering), 
                          .Din_i(16'b0), 
                          .Q_o(flicker_frames), 
                          .utc_o(utc), 
                          .dtc_o(dtc));
    
    game_visuals visual (.row_i(row), .col_i(col), .hovering_i(hovering), .flicker_i(flicker_frames[4]), .slug_x_i(slug_x), .energy_i(energy),
                         .trainXA_y_i(trainXA_y),           .trainXB_y_i(trainXB_y),           .trainYA_y_i(trainYA_y),           .trainYB_y_i(trainYB_y),           .trainZA_y_i(trainZA_y),           .trainZB_y_i(trainZB_y), 
                         .trainXA_length_i(trainXA_length), .trainXB_length_i(trainXB_length), .trainYA_length_i(trainYA_length), .trainYB_length_i(trainYB_length), .trainZA_length_i(trainZA_length), .trainZB_length_i(trainZB_length),
                         .sw_i(sw),
                         .vgaRed_o(vgaRed), .vgaGreen_o(vgaGreen), .vgaBlue_o(vgaBlue));

// ---------- led, seg, an logic ----------

    // ----- data + ringCounter -----  
    wire [15:0] seg_out;    // this holds the data for all four anodes. kinda.
    
    wire [3:0] ring_out;
    ring_counter RingCounter (.clk_i(clk), .advance_i(digsel), .ring_o(ring_out));

    // ----- seg out logic -----
    //assign seg_out[15:8] = 8'b0;        // middle segs are either unused or overwritten
    //assign seg_out[7:0] = score;    // right seg is absolute value of score
    
    edge_detector inc_scorer (.clk_i(clk), .button_i(inc_score), .edge_o(inc_score_sync));
    
    wire [15:0] score;
    countUD16L score_counter (.clk_i(clk), 
                              .up_i(inc_score_sync), 
                              .dw_i(1'b0), 
                              .ld_i(1'b0), 
                              .Din_i(16'b0), 
                              .Q_o(score), 
                              .utc_o(utc), 
                              .dtc_o(dtc));
    
    assign seg_out[7:0] = score;
    assign seg_out[15:12] = lives;
    assign seg_out[11:8] = 4'b0;
    
    // generate h7s for all of seg_out
    wire [3:0] h_out;
    selector Selector (.Sel_i(ring_out), .N_i(seg_out), .H_o(h_out));
    
    hex7seg Seg (.N_i(h_out), .seg_o(seg));
    
    // ----- anode logic -----
    assign an[3] = ~(ring_out[3] & (lives > 1'b0));          // never turn an3 on bro
    assign an[2] = ~(ring_out[2] & 1'b0);   // never turn an2 on bro
    assign an[1] = ~(ring_out[1]);     
    assign an[0] = ~(ring_out[0]);   
    
    
    // ----- led utility -----
    assign led[8] = hovering;
    assign led[3] = sw[3];
    assign led[15:9] = 7'b0;
    assign led[7:4] = 4'b0;
    assign led[2:1] = 2'b0;
    assign led[0] = sw[0];
    
endmodule
