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


module slug_sim( );
// registers to hold values for the inputs to your top level
    reg clkin;
    reg play_game_i;
    reg btnL_sync_i;
    reg btnR_sync_i;
    reg btnU_sync_i;
    reg thirtyfive_frames_i;
    reg energy_left_i;
    
    
// wires to see the values of the outputs of your top level
  
    wire moving_left_o;
    wire moving_right_o;
    wire hovering_o;
    
// create one instance of your top level
// and attach it to the registers and wires created above
    slug_fsm UUT (
        .clk_i(clkin),
        .play_game_i(play_game_i),
        .btnL_sync_i(btnL_sync_i),
        .btnR_sync_i(btnR_sync_i),
        .btnU_sync_i(btnU_sync_i),
        .thirtyfive_frames_i(thirtyfive_frames_i),
        .energy_left_i(energy_left_i),
        
         .moving_left_o(moving_left_o),
         .moving_right_o(moving_right_o),
         .hovering_o(hovering_o)
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
	   play_game_i = 1'b1;
       btnL_sync_i = 1'b0;
       btnR_sync_i = 1'b0;
       btnU_sync_i = 1'b0;
       thirtyfive_frames_i = 1'b0;
       energy_left_i = 1'b1;
	   
	   // ---------- go from middle to left ---------
	   
	   #29000 
	   btnL_sync_i = 1'b1;
	   
	   #1000
	   btnL_sync_i = 1'b0;
	   
	   #3000
	   thirtyfive_frames_i = 1'b1;
	   
	   #1000
	   thirtyfive_frames_i = 1'b0;
	   
	   // try to hover
	   #1000
	   btnU_sync_i = 1'b1;
	   
	   #1000
	   btnU_sync_i = 1'b0;
	   
	   // ---------- go from left to middle ----------
	   
	   #1000
	   btnR_sync_i = 1'b1;
	   
	   #1000
	   btnR_sync_i = 1'b0;
	   
	   #3000
	   thirtyfive_frames_i = 1'b1;
	   
	   #1000
	   thirtyfive_frames_i = 1'b0;
	   
	   // try to hover
	   #1000
	   btnU_sync_i = 1'b1;
	   
	   #1000
	   btnU_sync_i = 1'b0;
	   
	   // ---------- go from middle to right ----------
	   
	   #1000
	   btnR_sync_i = 1'b1;
	   
	   #1000
	   btnR_sync_i = 1'b0;
	   
	   #3000
	   thirtyfive_frames_i = 1'b1;
	   
	   #1000
	   thirtyfive_frames_i = 1'b0;
	   
	   // try to hover
	   #1000
	   btnU_sync_i = 1'b1;
	   
	   #1000
	   btnU_sync_i = 1'b0;
	   
	   // --------- go from right to middle ---------
	   
	   #1000 
	   btnL_sync_i = 1'b1;
	   
	   #1000
	   btnL_sync_i = 1'b0;
	   
	   #3000
	   thirtyfive_frames_i = 1'b1;
	   
	   #1000
	   thirtyfive_frames_i = 1'b0;
	   
	   // try to hover
	   #1000
	   btnU_sync_i = 1'b1;
	   
	   #1000
	   btnU_sync_i = 1'b0;
	   
          
    end

endmodule