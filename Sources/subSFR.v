//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 10:42:44 PM
// Module Name: subSFR.v
// Project Name: Final Project
// Description: This module implements an subtractor Special Function
//				Register (SFR). It retains a subtractee value which is subtracted 
//				from by a subtractor value.
//////////////////////////////////////////////////////////////////////////////////

module subSFR
	# (parameter SIZE = 32)
   (input clk,
	input ld,
	input sub,
	input [SIZE - 1:0] D, // Base subtractee
	input [SIZE - 1:0] S, // Subtractor
	output reg [SIZE - 1:0] Q // Cur subtractee
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
		if (sub == 1'b1)
			next_Q <= (Q - S);
		else
			next_Q <= Q;
			
			
endmodule