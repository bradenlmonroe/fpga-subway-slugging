`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 03:46:35 PM
// Design Name: 
// Module Name: ring_counter
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


module ring_counter(
    input clk_i,
    input advance_i,
    output [3:0] ring_o
    );
    
    // if clk_i & advance_i, all bits shift one to the right + bit 0 becomes bit 3
    wire [3:0] Q_temp;
    
    FDRE #(.INIT(1'b1)) ff0 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(Q_temp[3]), .Q(Q_temp[0]));
    FDRE #(.INIT(1'b0)) ff1 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(Q_temp[0]), .Q(Q_temp[1]));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(Q_temp[1]), .Q(Q_temp[2]));
    FDRE #(.INIT(1'b0)) ff3 (.C(clk_i), .R(1'b0), .CE(advance_i), .D(Q_temp[2]), .Q(Q_temp[3]));
    
    assign ring_o = Q_temp;
    
endmodule
