//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 10:02:44 PM
// Module Name: lrShiftSFR.v
// Project Name: Final Project
// Description: This module implements a left/right shift Special Function
//				Register (SFR)
//////////////////////////////////////////////////////////////////////////////////


module lrShiftSFR
	# (parameter SIZE = 32)
   (input clk,
	input ld,
	input left, right,
	input [SIZE - 1:0] D,
	output reg [SIZE - 1:0] Q
	);
	

reg [SIZE-1:0] next_Q;

	//register
	always @( posedge clk )
		if ( ld == 1'b1 )
			Q <= D;
		else
			Q <= next_Q;
			
	// Next Value
	always @( * )
		if (left == 1'b1)
			next_Q <= (Q << 1);
		else if (right == 1'b1) 
			next_Q <= (Q >> 1);
		else
			next_Q <= Q;
			
endmodule