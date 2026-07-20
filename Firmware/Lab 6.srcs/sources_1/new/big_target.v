`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 12:05:32 AM
// Design Name: 
// Module Name: big_target
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


module big_target(
    input clk_i,
    input [6:0] D_i,
    input CE_i,
    output [6:0] Q_o
    );
    
    wire [6:0] Q_temp;
    
    FDRE #(.INIT(1'b0)) ff0 (.C(clk_i), .R(1'b0), .CE(CE_i), .D(D_i[0]), .Q(Q_temp[0]));
    FDRE #(.INIT(1'b0)) ff1 (.C(clk_i), .R(1'b0), .CE(CE_i), .D(D_i[1]), .Q(Q_temp[1]));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk_i), .R(1'b0), .CE(CE_i), .D(D_i[2]), .Q(Q_temp[2]));
    FDRE #(.INIT(1'b0)) ff3 (.C(clk_i), .R(1'b0), .CE(CE_i), .D(D_i[3]), .Q(Q_temp[3]));
    FDRE #(.INIT(1'b0)) ff4 (.C(clk_i), .R(1'b0), .CE(CE_i), .D(D_i[4]), .Q(Q_temp[4]));
    FDRE #(.INIT(1'b0)) ff5 (.C(clk_i), .R(1'b0), .CE(CE_i), .D(D_i[5]), .Q(Q_temp[5]));
    FDRE #(.INIT(1'b0)) ff6 (.C(clk_i), .R(1'b0), .CE(CE_i), .D(D_i[6]), .Q(Q_temp[6]));
    
    assign Q_o = Q_temp;
    
endmodule
