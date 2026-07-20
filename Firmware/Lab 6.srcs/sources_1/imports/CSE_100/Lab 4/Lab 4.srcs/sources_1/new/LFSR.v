`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2025 06:33:54 PM
// Design Name: 
// Module Name: LFSR
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


module LFSR(
    input clk_i,
    output [7:0] q_o
    );
    
    // setup 8 fdres that link into each other
        // initialize the first to 1, the rest to zero?
    // input of the first link is a xor of fdres 0, 5, 6, 7
    // output is the output of all 8 fdres
    
    wire [7:0] Q_temp;
    wire [0:0] D_in = Q_temp[0] ^ Q_temp[5] ^ Q_temp[6] ^ Q_temp[7];
    
    FDRE #(.INIT(1'b1)) ff0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(D_in),      .Q(Q_temp[0]));
    FDRE #(.INIT(1'b0)) ff1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(Q_temp[0]), .Q(Q_temp[1]));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(Q_temp[1]), .Q(Q_temp[2]));
    FDRE #(.INIT(1'b0)) ff3 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(Q_temp[2]), .Q(Q_temp[3]));
    FDRE #(.INIT(1'b0)) ff4 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(Q_temp[3]), .Q(Q_temp[4]));
    FDRE #(.INIT(1'b0)) ff5 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(Q_temp[4]), .Q(Q_temp[5]));
    FDRE #(.INIT(1'b0)) ff6 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(Q_temp[5]), .Q(Q_temp[6]));
    FDRE #(.INIT(1'b0)) ff7 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(Q_temp[6]), .Q(Q_temp[7]));
    
    assign q_o = Q_temp;
    
endmodule
