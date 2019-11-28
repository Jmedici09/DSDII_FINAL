//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineer: James Medici
// 
// Create Date: 11/21/2019 12:33:44 PM
// Module Name: arbiter2_tb.v
// Project Name: Assignment 6B
// Description: This module impliments an testbent to test the arbiter2 module
//				It uses the standard form recommended by in lecture 20
//////////////////////////////////////////////////////////////////////////////////

`define NUM_TEST_VECTORS 23
`define DEBUG 1
`define MOORE 0

module arbiter2_tb();
	
	//array  to hold fsm I/O pairs
	reg [2:0] fsm_inputs [`NUM_TEST_VECTORS-1:0];
	reg	[1:0] fsm_outputs [`NUM_TEST_VECTORS-1:0];
	// add a reg that checks the current state
	
	
	reg ra_iv, rb_iv, reset_iv, clk;
	wire Ga_ov, Gb_ov;
	
	arbiter2 DUT ( .ra(ra_iv), .rb(rb_iv), .reset(reset_iv), .Ga(Ga_ov), .Gb(Gb_ov), .clk(clk));
	
	//process for 20 ns clk
	initial begin	
		clk=1'b0;
		forever 
			#10 clk=~clk;
	end
	
	
	//test vector pair ((rest,a),output)
	initial begin	
		//homing
		// no homing sequence 
	
		//reset
		fsm_inputs[0]=3'b1_00; fsm_outputs[0]=2'b00; // A Priority
		
		//test           r ab                    ab
		fsm_inputs[1]=3'b0_00; fsm_outputs[1]=2'b00; // A Priority
		fsm_inputs[2]=3'b0_01; fsm_outputs[2]=2'b01; // B Using
		fsm_inputs[3]=3'b0_01; fsm_outputs[3]=2'b01; // B Using
		fsm_inputs[4]=3'b0_00; fsm_outputs[4]=2'b00; // A Priority
		fsm_inputs[5]=3'b0_01; fsm_outputs[5]=2'b01; // B Using
		fsm_inputs[6]=3'b0_10; fsm_outputs[6]=2'b10; // A Hold
		fsm_inputs[7]=3'b0_10; fsm_outputs[7]=2'b10; // A Hold
		fsm_inputs[8]=3'b0_01; fsm_outputs[8]=2'b01; // B Hold
		fsm_inputs[9]=3'b0_10; fsm_outputs[9]=2'b10; // A Hold
		fsm_inputs[10]=3'b0_00; fsm_outputs[10]=2'b00; // B Priority
		fsm_inputs[11]=3'b0_00; fsm_outputs[11]=2'b00; // B Priority
		fsm_inputs[12]=3'b0_10; fsm_outputs[12]=2'b10; // A Using
		fsm_inputs[13]=3'b0_10; fsm_outputs[13]=2'b10; // A Using
		fsm_inputs[14]=3'b0_00; fsm_outputs[14]=2'b00; // B Priority
		fsm_inputs[15]=3'b0_10; fsm_outputs[15]=2'b10; // A Using
		fsm_inputs[16]=3'b0_01; fsm_outputs[16]=2'b01; // B Hold
		fsm_inputs[17]=3'b0_01; fsm_outputs[17]=2'b01; // B Hold
		fsm_inputs[18]=3'b0_00; fsm_outputs[18]=2'b00; // A Priority
		fsm_inputs[19]=3'b0_10; fsm_outputs[19]=2'b10; // A Hold
		fsm_inputs[20]=3'b0_00; fsm_outputs[20]=2'b00; // B Priority
		fsm_inputs[21]=3'b0_01; fsm_outputs[21]=2'b01; // B Hold
		
		//reset
		fsm_inputs[22]=3'b1_00; fsm_outputs[22]=2'b00; // A Priority
		
	end
	
	//main testbench
	
	initial begin:main_testbench
		integer i; 
		integer passed;
		i=0;
		passed=1;
		
		if(`DEBUG)
			$display("reset ra rb Ga Ga_ex Gb Gb_ex");
		
		repeat(`NUM_TEST_VECTORS) begin
			reset_iv=fsm_inputs[i][2];
			ra_iv=fsm_inputs[i][1];
			rb_iv=fsm_inputs[i][0];
			if(`MOORE)
				@( posedge clk);
			#1
			if(`DEBUG)
				$display("%5b %2b %2b %2b (%3b) %2b (%3b)", reset_iv, ra_iv, rb_iv, Ga_ov, fsm_outputs[i][1], Gb_ov, fsm_outputs[i][0]);
			// Ignore outputs that are X
			if( (fsm_outputs[i][1] !== 1'bx && Ga_ov !== fsm_outputs[i][1]) || (fsm_outputs[i][0] !== 1'bx && Gb_ov !== fsm_outputs[i][0]))begin	
				$display( "Fail" );
				$finish();
			end
			
			i=i+1;
		end
		if( passed ) $display ("Pass");
		$finish();
	end

endmodule