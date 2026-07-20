`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2025 06:39:19 PM
// Design Name: 
// Module Name: slug_sim
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


module pixel_sim( );
// registers to hold values for the inputs to your top level
    reg clkin;
    
    
// wires to see the values of the outputs of your top level
  
    wire [15:0] row_o;
    wire [15:0] col_o;
    wire new_frame_o;
    
// create one instance of your top level
// and attach it to the registers and wires created above
    pixel_address UUT (
        .clk_i(clkin),
        .row_o(row_o),
        .col_o(col_o),
        .new_frame_o(new_frame_o)
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

	   
	   // ---------- start game ---------
	   
       
    end

endmodule