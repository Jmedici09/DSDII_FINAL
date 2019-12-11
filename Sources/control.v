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
module control
	#(parameter SIZE=8)
	(	//Inputs
	input clk, reset,
	input start,
	// 	Status signals
	input cnt_is_0, divisor_is_0, dvsr_less_than_dvnd, shifted_divisor_MSB,
	//Outputs
	output reg error, done,
	//	Control signals
	output reg init, left, right, sub
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
			state <= WAIT_FOR_START;
		else
			state <= next_state;
			
	//next state logic
	always @(*)
	begin
		init = 1'b0;
		left = 1'b0;
		right = 1'b0;
		sub = 1'b0;
		
		casex( state )
			WAIT_FOR_START: 
				if( start == 1'b1 )
				begin
					next_state = CHECK_DIVIDE_BY_ZERO;
					init = 1'b1; // make sure this is how signals are done for mealy
				end
				else
					next_state = WAIT_FOR_START;
					
			CHECK_DIVIDE_BY_ZERO:
				if( divisor_is_0 == 1'b0 )
					next_state = SHIFT_LEFT;
				else
					next_state = ERROR; 
					
			ERROR:
				next_state = WAIT_FOR_START; 
			
			SHIFT_LEFT:
				if( shifted_divisor_MSB == 1'b1 )
					next_state = SHIFT_RIGHT;
				else
				begin
					next_state = SHIFT_LEFT;
					left = 1'b1;
				end
								
			SHIFT_RIGHT: // this could be rearanged
				if( cnt_is_0 == 1'b1 )
					if (dvsr_less_than_dvnd == 1'b1)
					begin
						next_state = SHIFT_RIGHT;
						sub = 1'b1;
					end
					else
						next_state = NO_ERROR;
				else if( dvsr_less_than_dvnd == 1'b1 )
				begin
					next_state = SHIFT_RIGHT;
					sub = 1'b1;
					right = 1'b1;
				end
				else
				begin
					next_state = SHIFT_RIGHT;
					right = 1'b1;
				end
				
				/* else
				begin
					next_state = SHIFT_RIGHT;
					right = 1'b1;
					if( dvsr_less_than_dvnd == 1'b1 )
						sub = 1'b1;
					else
						sub = 1'b0;
				end */
			
			NO_ERROR:
				next_state = WAIT_FOR_START; 
				
			default: next_state = {`SWIDTH{1'bx}};
		endcase
	end
	//output logic
	always @(*)
	begin
		error = (state == ERROR) ?  1'b1 : 1'b0;
		done = (state == NO_ERROR || state == ERROR) ?  1'b1 : 1'b0;
	end

endmodule
	