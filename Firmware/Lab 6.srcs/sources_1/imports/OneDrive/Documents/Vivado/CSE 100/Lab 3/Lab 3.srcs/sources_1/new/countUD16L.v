`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 03:47:39 PM
// Design Name: 
// Module Name: countUD16L
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


module countUD16L(
    input clk_i,
    input up_i,
    input dw_i,
    input ld_i,
    input [15:0] Din_i,
    
    output [15:0] Q_o,
    output utc_o,
    output dtc_o
    );
    
    // make a few countUD4Ls
    wire [3:0] Qa, Qb, Qc, Qd;
    wire [3:0] utcs, dtcs;
    
    // counters a-d go right to left, so reading visual counters go [ d c b a ]
    countUD4L a (.clk_i(clk_i), .up_i(up_i),                               .dw_i(dw_i),    .ld_i(ld_i), .Din_i(Din_i[3:0]), .Q_o(Qa), .utc_o(utcs[3]), .dtc_o(dtcs[3]));
    countUD4L b (.clk_i(clk_i), .up_i(utcs[3] & up_i),                     .dw_i(dtcs[3] & dw_i), .ld_i(ld_i), .Din_i(Din_i[7:4]),  .Q_o(Qb), .utc_o(utcs[2]), .dtc_o(dtcs[2]));
    countUD4L c (.clk_i(clk_i), .up_i(utcs[2] & utcs[3] & up_i),           .dw_i(dtcs[2] & dtcs[3] & dw_i), .ld_i(ld_i), .Din_i(Din_i[11:8]),   .Q_o(Qc), .utc_o(utcs[1]), .dtc_o(dtcs[1]));
    countUD4L d (.clk_i(clk_i), .up_i(utcs[1] & utcs[2] & utcs[3] & up_i), .dw_i(dtcs[1] & dtcs[2] & dtcs[3] & dw_i), .ld_i(ld_i), .Din_i(Din_i[15:12]),   .Q_o(Qd), .utc_o(utcs[0]), .dtc_o(dtcs[0]));
    
    // temp wire to put the counters back together
    wire [15:0] Q_temp;
    assign Q_temp[3:0] = Qa;
    assign Q_temp[7:4] = Qb;
    assign Q_temp[11:8] = Qc;
    assign Q_temp[15:12] = Qd;
    
    // outputs
    assign Q_o = Q_temp;
    
    assign utc_o = utcs[0] & utcs[1] & utcs[2] & utcs[3];
    assign dtc_o = dtcs[0] & dtcs[1] & dtcs[2] & dtcs[3];
endmodule
