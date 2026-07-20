`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2025 04:33:46 PM
// Design Name: 
// Module Name: fa
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

module fa(
    input a_i,
    input b_i,
    input cin_i,
    output S_o,
    output cout_o,
    output ovfl_o
    );
    
    assign S_o = a_i ^ (b_i ^ cin_i);
    assign cout_o = (a_i & b_i) | (cin_i & (a_i ^ b_i)) ;
    assign ovfl_o = cout_o ^ (a_i & b_i);
    
endmodule


// lowk just updating add4 for this 
module add4(
    input [3:0] A_i,
    input [3:0] B_i,
    input cin_i,
    output [3:0] S_o,
    output cout_o,
    output ovfl_o
    );
    
    wire [3:0] sout;
    wire [4:0] cout, ovfl; // ovfl == 0 tbh
    assign cout[0] = cin_i;
    
    fa fa0(.a_i(A_i[0]), .b_i(B_i[0]), .cin_i(cout[0]), .S_o(sout[0]), .cout_o(cout[1]), .ovfl_o(ovfl[1]));
    fa fa1(.a_i(A_i[1]), .b_i(B_i[1]), .cin_i(cout[1]), .S_o(sout[1]), .cout_o(cout[2]), .ovfl_o(ovfl[2]));
    fa fa2(.a_i(A_i[2]), .b_i(B_i[2]), .cin_i(cout[2]), .S_o(sout[2]), .cout_o(cout[3]), .ovfl_o(ovfl[3]));
    fa fa3(.a_i(A_i[3]), .b_i(B_i[3]), .cin_i(cout[3]), .S_o(sout[3]), .cout_o(cout[4]), .ovfl_o(ovfl[4]));
    
    assign S_o = sout;
    assign cout_o = cout[4];
    assign ovfl_o = cout[3] ^ cout[4];
    
endmodule

