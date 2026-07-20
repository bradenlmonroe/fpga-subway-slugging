`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 03:47:24 PM
// Design Name: 
// Module Name: selector
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


module selector(
    input [3:0] Sel_i,
    input [15:0] N_i,
    output [3:0] H_o
    );
    
    // variable
        // this is our default case and our "dont care" case
        
    // set h_o to n(15:12) if input is 1000
    wire [0:0] matchesD;
    wire [3:0] selectedD;
    assign matchesD = Sel_i[3] & ~Sel_i[2] & ~Sel_i[1] & ~Sel_i[0];
    assign selectedD = (N_i[15:12]) & ({4{matchesD}});
    
    // set h_o to n(11:8) if input is 0100
    wire [0:0] matchesC;
    wire [3:0] selectedC;
    assign matchesC = ~Sel_i[3] & Sel_i[2] & ~Sel_i[1] & ~Sel_i[0];
    assign selectedC = (N_i[11:8]) & ({4{matchesC}});
    
    // set h_o to n(7:4) if input is 0010
    wire [0:0] matchesB;
    wire [3:0] selectedB;
    assign matchesB = ~Sel_i[3] & ~Sel_i[2] & Sel_i[1] & ~Sel_i[0];
    assign selectedB = (N_i[7:4]) & ({4{matchesB}});
    
    // set h_o to n(3:0) if input is 0001
    wire [0:0] matchesA;
    wire [3:0] selectedA;
    assign matchesA = ~Sel_i[3] & ~Sel_i[2] & ~Sel_i[1] & Sel_i[0];
    assign selectedA = (N_i[3:0]) & ({4{matchesA}});
    
    
    // set output to selected part of N_i
    assign H_o = selectedD | selectedC | selectedB | selectedA;
    
    
endmodule
