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


module slug_fsm(
    input clk_i,
    input play_game_i,
    input btnL_sync_i,
    input btnR_sync_i,
    input btnU_sync_i,
    input thirtyfive_frames_i,
    input energy_left_i,
    
    output moving_left_o,
    output moving_right_o,
    output hovering_o
    );
    
    // dummy wires
    wire [7:0] Q, D;
    
// ---------- FDRES ----------
    FDRE #(.INIT(1'b1)) Q8FF (
        .C(clk_i),
        .R(1'b0),
        .CE(1'b1),
        .D(D[0]),
        .Q(Q[0])
    );
    FDRE #(.INIT(1'b0)) Q1234567FF[7:1] (
        .C({7{clk_i}}),
        .R({7'b0}),
        .CE({7{1'b1}}),
        .D(D[7:1]),
        .Q(Q[7:1])
    );
    
// ---------- state logic ----------

    // states
    wire [7:0] middle = 8'b00000001;
    wire [7:0] m_go_l = 8'b00000010;
    wire [7:0] left   = 8'b00000100;
    wire [7:0] l_go_m = 8'b00001000;
    wire [7:0] m_go_r = 8'b00010000;
    wire [7:0] right  = 8'b00100000;
    wire [7:0] r_go_m = 8'b01000000;
    wire [7:0] hover  = 8'b10000000;
    
    // current state
    wire qmiddle = (Q == middle);
    wire qm_go_l = (Q == m_go_l);
    wire qleft   = (Q == left);
    wire ql_go_m = (Q == l_go_m);
    wire qm_go_r = (Q == m_go_r);
    wire qright  = (Q == right);
    wire qr_go_m = (Q == r_go_m);
    wire qhover  = (Q == hover);

    wire dmiddle = (play_game_i) & ((ql_go_m & thirtyfive_frames_i) | (qr_go_m & thirtyfive_frames_i) | (qhover & ~energy_left_i) | (qhover & ~btnU_sync_i)) | (~play_game_i);
    wire dm_go_l = (play_game_i) & ((qmiddle & btnL_sync_i));
    wire dleft   = (play_game_i) & ((qm_go_l & thirtyfive_frames_i));
    wire dl_go_m = (play_game_i) & ((qleft & btnR_sync_i));
    wire dm_go_r = (play_game_i) & ((qmiddle & btnR_sync_i));
    wire dright  = (play_game_i) & ((qm_go_r & thirtyfive_frames_i));
    wire dr_go_m = (play_game_i) & ((qright & btnL_sync_i));
    wire dhover  = (play_game_i) & ((qmiddle & btnU_sync_i &  energy_left_i));

// ---------- output logic ----------

    assign moving_left_o  = qm_go_l | qr_go_m;
    assign moving_right_o = ql_go_m | qm_go_r;
    assign hovering_o = qhover;
    
    
    assign D = middle & {8{dmiddle}}
             | m_go_l & {8{dm_go_l}}
             | left   & {8{dleft}}
             | l_go_m & {8{dl_go_m}}
             | m_go_r & {8{dm_go_r}}
             | right  & {8{dright}}
             | r_go_m & {8{dr_go_m}}
             | hover  & {8{dhover}}
             | Q & {8{~dmiddle & ~dm_go_l & ~dleft & ~dl_go_m & ~dm_go_r & ~dright & ~dr_go_m & ~dhover}};
             


endmodule
