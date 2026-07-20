`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 10:48:02 PM
// Design Name: 
// Module Name: train_fsm
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


module train_fsm(
    input clk_i,
    input start_i,
    input respawn_i,
    input salt_i,
    
    output moving_o,
    output [6:0] length_o,
    output [6:0] delay_o
    );
    
    // dummy wires
    wire [1:0] Q, D;
    
// ---------- FDRES ----------
    FDRE #(.INIT(1'b1)) Q2FF (
        .C(clk_i),
        .R(1'b0),
        .CE(1'b1),
        .D(D[0]),
        .Q(Q[0])
    );
    FDRE #(.INIT(1'b0)) Q1FF (
        .C(clk_i),
        .R(1'b0),
        .CE(1'b1),
        .D(D[1]),
        .Q(Q[1])
    );
    
// ---------- state logic ----------
    
    // states 
    wire [1:0] waiting = 2'b01;
    wire [1:0] going = 2'b10;
    
    // current state
    wire qwaiting = (Q == waiting);
    wire qgoing = (Q == going);

    // next state
    wire dwaiting = (qgoing & respawn_i);
    wire dgoing = (qwaiting & start_i);

// ---------- output logic ----------
    
    wire [7:0] random_gen;
    LFSR lfsr (.clk_i(clk_i), .q_o(random_gen));
    
    wire [7:0] random = random_gen ^ salt_i;
    
    big_target lengthy (.clk_i(clk_i), .D_i(7'd60 + random[5:0]), .CE_i(start_i), .Q_o(length_o));
    big_target delengthy (.clk_i(clk_i), .D_i({random[3:0], random[7:4]}), .CE_i(start_i), .Q_o(delay_o));
    
    
    assign moving_o = qgoing;
        
    assign D = waiting & {2{dwaiting}}
             | going & {2{dgoing}}
             | Q & {2{~dwaiting & ~dgoing}};



endmodule
