//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 8:47:44 PM
// Module Name: datapath.v
// Project Name: Final Project
// Description: This module contains the datapath to perform the long division 
//				algorithm. 	It contains 4 special function registers.
//////////////////////////////////////////////////////////////////////////////////

module datapath
	#( parameter SIZE = 32)
   (//Inputs
	input clk, reset,
	input [SIZE - 1:0] divisor, dividend,
	//	Control signals
	input init, left, right, sub,
	//Outputs
	output [SIZE - 1:0] quotient, remainder,
	// 	Status signals
	output cnt_is_0, divisor_is_0, dvsr_less_than_dvnd, shifted_divisor_MSB
	);
	
reg [SIZE-1:0] q, r;
reg [SIZE-1:0] shifted_divisor;
reg [$clog2(SIZE)-1:0] cnt; // This should only need 5 bits to count to 32
	
assign	shifted_divisor_MSB = shifted_divisor[SIZE-1];
	
assign	divisor_is_0 = (shifted_divisor == {SIZE{1'b0}}) ? 1'b1 : 1'b0;
			
assign		dvsr_less_than_dvnd = (shifted_divisor < r) ? 1'b1 : 1'b0;
						
assign		cnt_is_0 = (cnt == {$clog2(SIZE){1'b0}}) ? 1'b1 : 1'b0;
		
	
	
/*		
lrShiftSFR #(SIZE) left_right (
	.clk(clk),
	.ld(init),
	.left(left), .right(right),
	.D(divisor),
	.Q(shifted_divisor)
	);
	
subSFR #(SIZE) subtract (
	.clk(clk),
	.ld(init),
	.sub(sub),
	.D(dividend), // Base subtractee
	.S(shifted_divisor), // Subtractor
	.Q(remainder) // Cur subtractee
	);
	
lShiftSFR #(SIZE) left_shift (
	.clk(clk),
	.clr(init),
	.left(right),
	.incr(sub),
	.Q(quotient)
	);
	
udCounterSFR #($clog2(SIZE)) count (
	.clk(clk),
	.clr(init),
	.incr(left), .decr(right),
	.Q(cnt) // Cur count
	);
*/

	//lrs register
	always @(posedge clk)
	begin
		casex({left, right, init})
			3'bxx1  :	shifted_divisor <= divisor;
			3'bx1x  :	shifted_divisor <= {1'b0, shifted_divisor[SIZE-1:1]};
			3'b1xx  :	shifted_divisor <= {shifted_divisor[SIZE-2:0], 1'b0};
			default :	shifted_divisor <= shifted_divisor;
		endcase
	end
	
	//counter register
	always @( posedge clk )
	begin
		casex({left, right, init})
			3'bxx1	:	cnt <= {SIZE{1'b0}};
			3'b1xx	:	cnt <= (cnt + 1);
			3'bx1x	:	cnt <= (cnt - 1);
			default	:	cnt <= cnt;
		endcase
	end
	
	//sub register
	always @( posedge clk )
	begin
		casex({sub, init})
			2'bx1	:	r <= dividend;
			2'b1x	:	r <= (r - shifted_divisor);
			default	:	r <= r;
		endcase
	end
	
	//lshift register
	always @( posedge clk )
		if ( init == 1'b1 )
			q = {SIZE{1'b0}};
		else begin
			if (sub == 1'b1)
				q = q + 1;
			if (right == 1'b1)
				q = {q[SIZE-2:0], 1'b0};
		end
		
	assign remainder = r;
	assign quotient = q;

/*
// Status signal calculation
	always @(*)
	begin
		shifted_divisor_MSB <= shifted_divisor[SIZE-1];
	
		divisor_is_0 <= (shifted_divisor == {SIZE{1'b0}}) ? 1'b1 : 1'b0;
			
		dvsr_less_than_dvnd <= (shifted_divisor < r) ? 1'b1 : 1'b0;
						
		cnt_is_0 <= (cnt == {$clog2(SIZE){1'b0}}) ? 1'b1 : 1'b0;
		
	end
	*/
	
endmodule