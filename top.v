//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 7:53:44 PM
// Module Name: top.v
// Project Name: Final Project
// Description: This module contains the controler and datapath for the long 
///				division module
//////////////////////////////////////////////////////////////////////////////////

module top
	# (parameter SIZE = 32)
   (input clk,
	input start,
	input reset,
	input [SIZE - 1] dividend, divisor,
	output error,
	output done,
	output [SIZE - 1] quotient, remainder
	);
	
control C #(SIZE)
	(
	
	);
	
datapath D #(SIZE)
	(
	
	);