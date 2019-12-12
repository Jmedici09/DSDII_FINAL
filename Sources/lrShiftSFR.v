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
	always @(posedge clk)
	begin
		casex({left, right, ld})
			3'bxx1  :	Q <= D;
			3'bx1x  :	Q <= {1'b0, Q[SIZE-1:1]};
			3'b1xx  :	Q <= {Q[SIZE-2:0], 1'b0};
			default :	Q <= Q;
		endcase
	end
		
endmodule