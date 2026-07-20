`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2025 08:39:48 PM
// Design Name: 
// Module Name: top_sim
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


module top_sim( );

// registers to hold values for the inputs to your top level
    reg btnU;
    reg btnD;
    reg btnL;
    reg btnR;
    reg btnC;
    reg [15:0] sw;
    reg clkin;

    
    
// wires to see the values of the outputs of your top level

   // Outputs
    wire [3:0] an;
    wire [6:0] seg;
    wire [15:0] led;
    wire Hsync;
    wire Vsync;
    wire [3:0] vgaRed;
    wire [3:0] vgaBlue;
    wire [3:0] vgaGreen;
    
// create one instance of your top level
// and attach it to the registers and wires created above
    top UUT (
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR),
    .btnC(btnC),
    .sw(sw),
    .clkin(clkin),

   // Outputs
    .an(an),
    .seg(seg),
    .led(led),
    .Hsync(Hsync),
    .Vsync(Vsync),
    .vgaRed(vgaRed),
    .vgaBlue(vgaBlue),
    .vgaGreen(vgaGreen)
    );
    
    
// create an oscillating signal to impersonate the clock provided on the BASYS 3 board
    parameter PERIOD = 100;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        #OFFSET
		  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
    end
	
// here is where the values for the registers are provided
// time must be advanced so that the change will have an effect
   initial
   begin
	 // add your test vectors here
	 // to set signal foo to value 0 use
	 // foo = 1'b0;
	 // to set signal foo to value 1 use
	 // foo = 1'b1;
	 //always advance time by multiples of 500ns
	 
	   // init everything to 0?
        
        btnU = 1'b0;
        btnD = 1'b0;
        btnL = 1'b0;
        btnR = 1'b0;
        btnC = 1'b0;
        sw = 16'b0;
	   
	    // ---------- start game ---------
	   
	    #9700
        btnC = 1'b1;
        
        #3000
        btnC = 1'b0;
        
        #5000
        btnL = 1'b1;
        
        #1000
        btnL = 1'b0;
       
       
    end

endmodule
