//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineers: James Medici 
//			  Walter Keyes
// 
// Create Date: 11/27/2019 7:53:44 PM
// Module Name: top.v
// Project Name: Final Project
// Description: This module contains the controller and datapath for the long 
///				division module
//////////////////////////////////////////////////////////////////////////////////

module top
	# (parameter SIZE = 32)
   (input clk,
	input start,
	input reset,
	input [SIZE - 1:0] dividend, divisor,
	output error,
	output done,
	output reg [SIZE - 1:0] quotient, remainder
	);

wire cnt_is_0, divisor_is_0, dvsr_less_than_dvnd, shifted_divisor_MSB;
wire init, left, right, sub;

control C
	(//Inputs
	.clk(clk), .reset(reset),
	.start(start),
	// 	Status signals
	.cnt_is_0(cnt_is_0) , .divisor_is_0(divisor_is_0), 
	.dvsr_less_than_dvnd(dvsr_less_than_dvnd), .shifted_divisor_MSB(shifted_divisor_MSB),
	//Outputs
	.error(error), .done(done),
	//	Control signals
	.init(init), .left(left), .right(right), .sub(sub)
	);
	
datapath D #(SIZE)
	(//Inputs
	.clk(clk), .reset(reset),
	.divisor(divisor), .dividend(dividend),
	//	Control signals
	.init(init), .left(left), .right(right), .sub(sub)
	//Outputs
	.quotient(quotient), remainder
	// 	Status signals
	.cnt_is_0(cnt_is_0) , .divisor_is_0(divisor_is_0), 
	.dvsr_less_than_dvnd(dvsr_less_than_dvnd), .shifted_divisor_MSB(shifted_divisor_MSB),
	);
	
endmodule