`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 03:44:35 PM
// Design Name: 
// Module Name: countUD4L
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


module countUD4L(
    input clk_i,
    input up_i,
    input dw_i,
    input ld_i,
    input [3:0] Din_i,
    
    output [3:0] Q_o,
    output utc_o,
    output dtc_o
    );
    
    // dummy variables
    wire [3:0] sum; // aka sum
    wire [3:0] fdre_outs; // initial values
    
    wire [0:0] add = up_i & ~dw_i;
    wire [0:0] sub = ~up_i & dw_i;
    
    // calculate what we need to load into the fdres
    wire [3:0] add_sub = (4'b0000) | (4'b0001 & {4{add}}) | (4'b1111 & {4{sub}});
        // default 0000 if both add and sub are false
        // becomes 0001 if add is true (implies sub is false)
        // becomes 1110 if sub is true (implies add is false)
            // 1110 is 2's complement -0001
   
    // use the add4 module (FROM LAB 2 BEOW BEOW BEOW BEOW BEOWWWW)
    
    // dummy wries for in/outputs we dont care about
    wire [0:0] cout, ovfl;
    
    add4 Add4 (.A_i(fdre_outs), .B_i(add_sub), .cin_i(1'b0), .S_o(sum), .cout_o(cout), .ovfl_o(ovfl));
    
    // then overwrite add_sub if load is true
    wire [3:0] addend = (sum & ~{4{ld_i}}) | (Din_i & {4{ld_i}});
        // if ld is false, then use the up/down trigger
        // if ld is true, then use the loaded value
    
    // load the fdres
        // importantly we know the values we want to set the fdres BEFORE we set them
        // so the Q_outs of the fdres is moot
    //assign Q_out = 
    // one fdre to flip when a button is pressed
    wire [0:0] update = add | sub | ld_i;
    //wire [0:0] update;
    //FDRE #(.INIT(1'b0)) ff_update (.C(clk_i), .R(1'b0), .CE(1'b1), .D(~btnPressed), .Q(update));
    
    // we need 4 FDRE modules
        // they count left to right so 0 is the rightmost, 3 is the leftmost
    FDRE #(.INIT(1'b0)) ff0 (.C(clk_i), .R(1'b0), .CE(update), .D(addend[0]), .Q(fdre_outs[0]));
    FDRE #(.INIT(1'b0)) ff1 (.C(clk_i), .R(1'b0), .CE(update), .D(addend[1]), .Q(fdre_outs[1]));
    FDRE #(.INIT(1'b0)) ff2 (.C(clk_i), .R(1'b0), .CE(update), .D(addend[2]), .Q(fdre_outs[2]));
    FDRE #(.INIT(1'b0)) ff3 (.C(clk_i), .R(1'b0), .CE(update), .D(addend[3]), .Q(fdre_outs[3]));
   
    // outputs
    assign Q_o = fdre_outs;
    
    assign utc_o = ( Q_o[3] &  Q_o[2] &  Q_o[1] &  Q_o[0]);
    assign dtc_o = (~Q_o[3] & ~Q_o[2] & ~Q_o[1] & ~Q_o[0]);
endmodule
