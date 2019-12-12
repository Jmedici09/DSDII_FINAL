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
	output reg cnt_is_0, divisor_is_0, dvsr_less_than_dvnd, shifted_divisor_MSB
	);
	
wire [SIZE-1:0] shifted_divisor;
wire [$clog2(SIZE)-1:0] cnt; // This should only need 5 bits to count to 32
	
		
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
	.ld(init),
	.incr(left), .decr(right),
	.Q(cnt) // Cur count
	);
	
// Status signal calculation
	always @(*)
	begin
		shifted_divisor_MSB <= shifted_divisor[SIZE-1];
	
		divisor_is_0 <= (shifted_divisor == SIZE-1'd0) ? 1'b1 : 1'b0;
			
		dvsr_less_than_dvnd <= (shifted_divisor < remainder) ? 1'b1 : 1'b0;
						
		cnt_is_0 <= (cnt == {$clog2(SIZE){1'b0}}) ? 1'b1 : 1'b0;
		
	end
	
endmodule