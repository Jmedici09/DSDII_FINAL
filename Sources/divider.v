//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 7:53:44 PM
// Module Name: divider.v
// Project Name: Final Project
// Description: This module contains the controller and datapath for the long 
///				division module
//////////////////////////////////////////////////////////////////////////////////

module divider
	# (parameter SIZE = 32)
   (input clk,
	input start,
	input reset,
	input [SIZE - 1:0] divisor, dividend,
	output reg error, done,
	output [SIZE - 1:0] quotient, remainder
	);

`define SWIDTH 3
localparam [`SWIDTH-1:0] 
	WAIT_FOR_START = 0,
	CHECK_DIVIDE_BY_ZERO = 1,
	ERROR = 2,
	SHIFT_LEFT = 3,
	SHIFT_RIGHT = 4,
	NO_ERROR = 5;

wire cnt_is_0, divisor_is_0, dvsr_less_than_dvnd, shifted_divisor_MSB;
reg init, left, right, sub;

reg [SIZE-1:0] q, r;
reg [SIZE-1:0] shifted_divisor;
reg [$clog2(SIZE)-1:0] cnt; // This should only need 5 bits to count to 32
	
assign	shifted_divisor_MSB = shifted_divisor[SIZE-1];
assign	divisor_is_0 = (shifted_divisor == 0) ? 1'b1 : 1'b0;
assign	dvsr_less_than_dvnd = (shifted_divisor < r) ? 1'b1 : 1'b0;
assign	cnt_is_0 = (cnt == 0) ? 1'b1 : 1'b0;

assign remainder = r;
assign quotient = q;

	//lrShift register
	always @( posedge clk )
		if ( |{init, left, right} )
		begin
			if ( init == 1'b1 )
				shifted_divisor <= divisor;
			if (left == 1'b1)
				shifted_divisor <= {shifted_divisor[SIZE-2:0], 1'b0};
			if (right == 1'b1)
				shifted_divisor <= {1'b0, shifted_divisor[SIZE-1:1]};
		end
		else
			shifted_divisor <= shifted_divisor;
			
			
	//udCountregister
	always @( posedge clk )
		if ( |{init, left, right} )
		begin
			if ( init == 1'b1 )
				cnt <= 1;
			if (left == 1'b1)
				cnt <= (cnt + 1);
			if (right == 1'b1)
				cnt <= (cnt - 1);
		end
		else
			cnt <= cnt;
		
	//sub register
	always @( posedge clk )
		if ( |{init, sub} )
		begin
			if ( init == 1'b1 )
				r <= dividend;
			if (sub == 1'b1)
				r <= (r - shifted_divisor);
		end
		else
			r <= r;
			
			
	//lShift register
	always @( posedge clk )
		if ( init == 1'b1 )
			q <= 0;
		else if (right == 1)
			q <= {q[SIZE-2:0], sub};

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
		error = 1'b0; 
		done = 1'b0;
		
		casex( state )
			WAIT_FOR_START: 
				if( start == 1'b1 )
				begin
					next_state = CHECK_DIVIDE_BY_ZERO;
					init = 1'b1;
				end
				else
					next_state = WAIT_FOR_START;
					
			CHECK_DIVIDE_BY_ZERO:
				if( divisor_is_0 == 1'b0 )
					next_state = SHIFT_LEFT;
				else
					next_state = ERROR; 
					
			ERROR:
			begin
				next_state = WAIT_FOR_START;
				error = 1'b1;
				done = 1'b1;
			end
			
			SHIFT_LEFT:
				if( shifted_divisor_MSB == 1'b1 )
					next_state = SHIFT_RIGHT;
				else
				begin
					next_state = SHIFT_LEFT;
					left = 1'b1;
				end
								
			SHIFT_RIGHT:
				if( cnt_is_0 == 1'b1 )
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

			
			NO_ERROR:
			begin
				next_state = WAIT_FOR_START; 
				done = 1'b1;
			end
				
			default: next_state = {`SWIDTH{1'bx}};
		endcase
	end
	
endmodule