//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 10:02:44 PM
// Module Name: udCounterSFR.v
// Project Name: Final Project
// Description: This module implements an UP/Down Counter Special Function
//				Register (SFR)
//////////////////////////////////////////////////////////////////////////////////

module udCounterSFR
	# (parameter SIZE = 5)
   (input clk,
	input ld,
	input incr, decr,
	input [SIZE - 1:0] D, // Base count
	output reg [SIZE - 1:0] Q // Cur count
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
		if (incr == 1'b1)
			next_Q <= (Q + 1);
		else if (decr == 1'b1) 
			next_Q <= (Q - 1);
		else
			next_Q <= Q;
			
endmodule