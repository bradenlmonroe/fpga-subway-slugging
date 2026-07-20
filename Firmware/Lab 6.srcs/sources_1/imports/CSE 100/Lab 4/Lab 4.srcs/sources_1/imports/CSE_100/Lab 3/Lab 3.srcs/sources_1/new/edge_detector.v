`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 03:46:04 PM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input clk_i,
    input button_i,
    output edge_o
    );
    
    // edge_o = 1 if this button is 1 and last button was 0
    wire [0:0] q_old, q_now;
        
    FDRE #(.INIT(1'b0)) ff_now (.C(clk_i), .R(1'b0), .CE(1'b1), .D(button_i), .Q(q_now));
    FDRE #(.INIT(1'b0)) ff_old (.C(clk_i), .R(1'b0), .CE(1'b1), .D(q_now), .Q(q_old));
    
    assign edge_o = q_now & ~q_old;
    
    
endmodule
