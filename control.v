//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 8:01:44 PM
// Module Name: control.v
// Project Name: Final Project
// Description: This module contains the FSM to control the long division 
//				algorithm. 	
//				This is a Mealy FSM.
//////////////////////////////////////////////////////////////////////////////////


`define SWIDTH 3
module controler
# (parameter SIZE )
(	//Inputs
	input clk, reset,
	input start,
	// 	Status signals
	input 
	//Outputs
	output reg ,
	//	Control signals
	output reg Error, Done,
	
);

localparam [`SWIDTH-1:0] 
	WAIT_FOR_START = 0,
	CHECK_DIVIDE_BY_ZERO = 1,
	ERROR = 2,
	SHIFT_LEFT = 3,
	SHIFT_RIGHT = 4,
	NO_ERROR = 5;
	
reg [`SWIDTH-1:0] state, next_state;
	//state register
	always @( posedge clk )
		if ( reset == 1'b1 )
			state <= A_PRIORITY;
		else
			state <= next_state;
			
	//next state logic
	always @(*)
		casex( state )
			A_PRIORITY: 
				if( ra == 1'b1 )
					next_state = A_HOLD;
				else if( (~ra & rb) == 1'b1 )
					next_state = B_USING;
				else
					next_state = A_PRIORITY; // next_state = state;
					
			A_HOLD:
				if( (~ra & rb) == 1'b1 )
					next_state = B_HOLD;
				else if( (~ra & ~rb) == 1'b1 )
					next_state = B_PRIORITY;
				else
					next_state = A_HOLD; // next_state = state;
					
			B_USING:

				if( ra == 1'b1 )
					next_state = A_HOLD;
				else if( (~ra & ~rb) == 1'b1 )
					next_state = A_PRIORITY;
				else
					next_state = B_USING; // next_state = state;
			
			B_PRIORITY:
				if( rb == 1'b1 )
					next_state = B_HOLD;
				else if( (ra & ~rb) == 1'b1 )
					next_state = A_USING;
				else
					next_state = B_PRIORITY; // next_state = state;
								
			B_HOLD:
				if( (~ra & ~rb) == 1'b1 )
					next_state = A_PRIORITY;
				else if( (ra & ~rb) == 1'b1 )
					next_state = A_HOLD;
				else
					next_state = B_HOLD; // next_state = state;
			
			A_USING:
				if( (~ra & ~rb) == 1'b1 )
					next_state = B_PRIORITY;
				else if( rb == 1'b1 )
					next_state = B_HOLD;
				else
					next_state = A_USING; // next_state = state;
			default: next_state = {`SWIDTH{1'bx}};
		endcase
	//output logic
	always @(*)
	begin
		Ga = (state == A_HOLD || state == A_USING) ?  1'b1 : 1'b0;
		Gb = (state == B_USING || state == B_HOLD) ?  1'b1 : 1'b0;
	end

endmodule
	