//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 10:42:44 PM
// Module Name: rShiftSFR.v
// Project Name: Final Project
// Description: This module implements a right shift Special Function
//				Register (SFR)
//////////////////////////////////////////////////////////////////////////////////


module lShiftSFR
	# (parameter SIZE = 32)
   (input clk,
	input clr,
	input left,
	input incr,
	output reg [SIZE - 1:0] Q
	);

	//register
	always @( posedge clk )
		if ( clr == 1'b1 )
			Q = {SIZE{1'b0}};
		else begin
			if (incr == 1'b1)
				Q = Q + 1;
			if (left == 1'b1)
				Q = {Q[SIZE-2:0], 1'b0};
		end
			
endmodule