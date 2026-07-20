`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 02:05:36 AM
// Design Name: 
// Module Name: system_fsm
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


module system_fsm(
    input clk_i,
    input btnC_sync_i,
    input btnD_sync_i,
    input collision_i,
    input [15:0] sw_i,
    input btnL_sync_i,
    
    output play_game_o,
    output [3:0] lives_o
    );
    
    // dummy wires
    wire [2:0] Q, D;
    
// ---------- FDRES ----------
    FDRE #(.INIT(1'b1)) Q3FF (
        .C(clk_i),
        .R(1'b0),
        .CE(1'b1),
        .D(D[0]),
        .Q(Q[0])
    );
    FDRE #(.INIT(1'b0)) Q12FF[2:1] (
        .C({2{clk_i}}),
        .R({2{1'b0}}),
        .CE({2{1'b1}}),
        .D(D[2:1]),
        .Q(Q[2:1])
    );
    
// ---------- state logic ----------

    // states
    wire [2:0] idle = 3'b001;
    wire [2:0] game = 3'b010;
    wire [2:0] done = 3'b100;
    
    // current state
    wire qidle = (Q == idle);
    wire qgame = (Q == game);
    wire qdone = (Q == done);

            // extra credit: lives
            wire [15:0] lives;
            countUD16L lives_counter(.clk_i(clk_i), 
                                     .up_i(1'b0), 
                                     .dw_i(collision_i & qgame & ~(lives == 16'b0)), 
                                     .ld_i(btnL_sync_i & qidle), 
                                     .Din_i({12'd0, sw_i[15:12]}), 
                                     .Q_o(lives), 
                                     .utc_o(), 
                                     .dtc_o());

    wire didle = qdone & btnD_sync_i;
    wire dgame = qidle & btnC_sync_i;
    wire ddone = qgame & collision_i & ~sw_i[3] & (lives == 4'b0);

// ---------- output logic ----------

    assign play_game_o = qgame;
    
    assign D = idle & {3{didle}}
             | game & {3{dgame}}
             | done & {3{ddone}}
             | Q & {3{~didle & ~dgame & ~ddone}};
             
    assign lives_o = lives[3:0];  
    


endmodule
