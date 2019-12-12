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
	input clr,
	input incr, decr,
	output reg [SIZE - 1:0] Q // Cur count
	);

	//register
	always @( posedge clk )
	begin
		casex({incr, decr, clr})
			3'bxx1	:	Q <= {SIZE{1'b0}};
			3'b1xx	:	Q <= (Q + 1);
			3'bx1x	:	Q <= (Q - 1);
			default	:	Q <= Q;
		endcase
	end
			
endmodule