//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineer: James Medici
// 
// Create Date: 11/21/2019 12:33:44 PM
// Module Name: divider_control_tb.v
// Project Name: Final Project
// Description: This module impliments an testbench to test the divider module
//////////////////////////////////////////////////////////////////////////////////

`define SIZE 2
`define NUM_TEST_VECTORS 13
`define DEBUG 1

module divider_control_tb();
	
	//array  to hold fsm I/O pairs
	reg [9:0] fsm_inputs [`NUM_TEST_VECTORS-1:0];
	reg	[5:0] fsm_outputs [`NUM_TEST_VECTORS-1:0];
	// add a reg that checks the current state

	
	reg start_iv, cnt_is_0_iv, divisor_is_0_iv, dvsr_less_than_dvnd_iv, shifted_divisor_MSB_iv, reset_iv, clk;
	reg [`SIZE-1:0] dividend_iv, divisor_iv;
	wire error_ov, done_ov, init_ov, left_ov, right_ov, sub_ov;
	
	divider #(`SIZE) DUT (	.start(start_iv),
						.reset(reset_iv),
						.clk(clk),
						.divisor(divisor_iv),
						.dividend(dividend_iv),
						.error(error_ov),
						.done(done_ov),
						.quotient(),
						.remainder());
						
	//process for 20 ns clk
	initial begin	
		clk=1'b0;
		forever 
			#10 clk=~clk;
	end
	
	// Assign block
	//assign divider_control_tb.DUT.cnt_is_0 = cnt_is_0_iv;
	//assign divider_control_tb.DUT.dvsr_less_than_dvnd = dvsr_less_than_dvnd_iv;
	//assign divider_control_tb.DUT.shifted_divisor_MSB = shifted_divisor_MSB_iv;
	//assign divider_control_tb.DUT.divisor_is_0 = divisor_is_0_iv;
	
	assign init_ov = DUT.init;
	assign left_ov = DUT.left;
	assign right_ov = DUT.right;
	assign sub_ov = DUT.sub;
	
	
	//test vector pair ((rest,a),output)
	initial begin	
		//homing
		// no homing sequence 
	
		//reset
		fsm_inputs[0] =10'b1_00_00_00000; fsm_outputs[0]=6'b000000; // WAIT_FOR_START
		
		// r=reset, ds=divisor, dd=dividend, s=start, c=cnt_is_0, 0=divisor_is_0, <=dvsr_less_than_dvnd, m=shifted_divisor_MSB
		// e=error, d=done, i=init, l=left, r=right, s=sub
		//test             r ds dd sc0<m                     ed ilrs
		fsm_inputs[1] =10'b0_00_00_01010; fsm_outputs[1] =6'b00_0000; // WAIT_FOR_START
		fsm_inputs[2] =10'b0_00_00_11011; fsm_outputs[2] =6'b00_0000; // CHECK_DIVIDE_BY_ZERO
		fsm_inputs[3] =10'b0_00_00_01111; fsm_outputs[3] =6'b11_0000; // ERROR
		fsm_inputs[4] =10'b0_01_10_00010; fsm_outputs[4] =6'b00_0000; // WAIT_FOR_START
		fsm_inputs[5] =10'b0_01_10_10101; fsm_outputs[5] =6'b00_0000; // CHECK_DIVIDE_BY_ZERO
		fsm_inputs[6] =10'b0_01_10_10001; fsm_outputs[6] =6'b00_0000; // SHIFT_LEFT
		fsm_inputs[7] =10'b0_01_10_10100; fsm_outputs[7] =6'b00_0100; // SHIFT_LEFT
		fsm_inputs[8] =10'b0_01_10_01111; fsm_outputs[8] =6'b00_0000; // SHIFT_RIGHT
		fsm_inputs[9] =10'b0_01_10_10101; fsm_outputs[9] =6'b00_0010; // SHIFT_RIGHT
		fsm_inputs[10]=10'b0_01_10_00111; fsm_outputs[10]=6'b00_0011; // SHIFT_RIGHT
		fsm_inputs[11]=10'b0_01_10_01011; fsm_outputs[11]=6'b01_0000; // NO_ERROR
		fsm_inputs[12]=10'b0_01_10_00010; fsm_outputs[12]=6'b00_0000; // WAIT_FOR_START

		
		//reset
	//	fsm_inputs[22]=3'b1_00; fsm_outputs[22]=2'b00; // A Priority

	end
	
	//main testbench
	
	initial begin:main_testbench
		integer i; 
		integer passed;
		i=0;
		passed=1;
		
		if(`DEBUG)
			$display("reset start cnt=0 div=0 divisor<dividend div[MSB] divisor dividend | error done init left right sub (expected output) | state next_state count");
		
		repeat(`NUM_TEST_VECTORS) begin
			reset_iv=fsm_inputs[i][9];
			divisor_iv=fsm_inputs[i][8:7];
			dividend_iv=fsm_inputs[i][6:5];
			start_iv=fsm_inputs[i][4];
			cnt_is_0_iv=fsm_inputs[i][3];
			divisor_is_0_iv=fsm_inputs[i][2];
			dvsr_less_than_dvnd_iv=fsm_inputs[i][1];
			shifted_divisor_MSB_iv=fsm_inputs[i][0];
			
			@(posedge clk);
			#1
			if(`DEBUG)
				$display("%5b %5b %5b %5b %16b %8b %7b %8b | %5b %4b %4b %4b %5b %3b (%15b) | %5d %10d %5d",
				reset_iv, start_iv, cnt_is_0_iv, divisor_is_0_iv, dvsr_less_than_dvnd_iv, shifted_divisor_MSB_iv, divisor_iv, dividend_iv,
						error_ov, done_ov, init_ov, left_ov, right_ov, sub_ov, fsm_outputs[i], DUT.state, DUT.next_state, DUT.cnt);
			// Ignore outputs that are X
//			if( (fsm_outputs[i][1] !== 1'bx && Ga_ov !== fsm_outputs[i][1]) || (fsm_outputs[i][0] !== 1'bx && Gb_ov !== fsm_outputs[i][0]))begin	
	//			$display( "Fail" );
		//		$finish();
		//	end
			
			i=i+1;
		end
		if( passed == 1 ) $display ("Pass");
		$finish();
	end

endmodule