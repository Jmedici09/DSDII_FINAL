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
	

	//register
	always @( posedge clk )
		if ( ld == 1'b1 )
			Q <= D;
		else if (left == 1'b1)
			Q <= {Q[SIZE-2:0], 1'b0};
		else if (right == 1'b1) 
			Q <= {1'b0, Q[SIZE-1:1]};
		else
			Q <= Q;
			
endmodule