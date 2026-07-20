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


module sys_sim( );
// registers to hold values for the inputs to your top level
    reg clkin;
    reg btnC_sync_i;
    reg btnD_sync_i;
    reg collision_i;
    reg [15:0] sw;
    
    
// wires to see the values of the outputs of your top level
  
    wire play_game_o;
    
// create one instance of your top level
// and attach it to the registers and wires created above
    system_fsm UUT (
        .clk_i(clkin),
        .btnC_sync_i(btnC_sync_i),
        .btnD_sync_i(btnD_sync_i),
        .collision_i(collision_i),
        .sw(sw),
    
        .play_game_o(play_game_o)
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

       btnC_sync_i = 1'b0;
       btnD_sync_i = 1'b0;
       collision_i = 1'b0;
       sw = 16'b0;
	   
	   // ---------- start game ---------
	   
	   #29000
	   btnC_sync_i = 1'b1;
	   
	   #1000
	   btnC_sync_i = 1'b0;
	   
       // ---------- crash! ----------
       
       #1000
       collision_i = 1'b1;
       
       #1000
       collision_i = 1'b0;
       
       // --------- new game -----------
       
       #1000
       btnD_sync_i = 1'b1;
       
       
    end

endmodule