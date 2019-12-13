//////////////////////////////////////////////////////////////////////////////////
// Company: Binghamton University
// Engineer: James Medici
//			 Walter Keyes
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
	reg	[5:0] fsm_states [`NUM_TEST_VECTORS-1:0];

	
	reg start_iv, cnt_is_0_iv, divisor_is_0_iv, dvsr_less_than_dvnd_iv, shifted_divisor_MSB_iv, reset_iv, clk;
	reg [`SIZE-1:0] dividend_iv, divisor_iv;
	wire error_ov, done_ov, init_ov, left_ov, right_ov, sub_ov;
	wire [2:0] state_ov, next_state_ov;
	
	reg [3:0] mealy_outputs;
	reg [2:0] mealy_next_state, moore_state;
	reg [1:0] moore_outputs;
	
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
	assign init_ov = DUT.init;
	assign left_ov = DUT.left;
	assign right_ov = DUT.right;
	assign sub_ov = DUT.sub;
	assign state_ov = DUT.state;
	assign next_state_ov = DUT.next_state;
	
	//test vector pair ((rest,a),output)
	initial begin	
		//homing
		// no homing sequence 
	
		// r=reset, ds=divisor, dd=dividend, s=start, c=cnt_is_0, 0=divisor_is_0, <=dvsr_less_than_dvnd, m=shifted_divisor_MSB
		// e=error, d=done, i=init, l=left, r=right, s=sub
		// cs=current_state, ns=next_state 
	
		//reset 		   r ds dd s c0<m                     ed ilrs				   cs ns	NEXT_STATE
		fsm_inputs[0] =10'b1_00_00_0_xxxx; fsm_outputs[0] =6'bxx_xxxx; fsm_states[0] =6'ox__0;// WAIT_FOR_START
																					   
		//test                                                                         
		fsm_inputs[1] =10'b0_00_00_0_xxxx; fsm_outputs[1] =6'b00_0000; fsm_states[1] =6'o0__0;// WAIT_FOR_START
		fsm_inputs[2] =10'b0_00_00_1_xxxx; fsm_outputs[2] =6'b00_1000; fsm_states[2] =6'o0__1;// CHECK_DIVIDE_BY_ZERO
		fsm_inputs[3] =10'b0_00_00_0_0110; fsm_outputs[3] =6'b00_0000; fsm_states[3] =6'o1__2;// ERROR
		fsm_inputs[4] =10'b0_01_10_0_0110; fsm_outputs[4] =6'b11_0000; fsm_states[4] =6'o2__0;// WAIT_FOR_START
		fsm_inputs[5] =10'b0_01_10_1_0110; fsm_outputs[5] =6'b00_1000; fsm_states[5] =6'o0__1;// CHECK_DIVIDE_BY_ZERO
		fsm_inputs[6] =10'b0_01_10_0_0010; fsm_outputs[6] =6'b00_0000; fsm_states[6] =6'o1__3;// SHIFT_LEFT
		fsm_inputs[7] =10'b0_01_10_0_0010; fsm_outputs[7] =6'b00_0100; fsm_states[7] =6'o3__3;// SHIFT_LEFT
		fsm_inputs[8] =10'b0_01_10_0_0011; fsm_outputs[8] =6'b00_0000; fsm_states[8] =6'o3__4;// SHIFT_RIGHT
		fsm_inputs[9] =10'b0_01_10_0_0011; fsm_outputs[9] =6'b00_0011; fsm_states[9] =6'o4__4;// SHIFT_RIGHT
		fsm_inputs[10]=10'b0_01_10_0_0000; fsm_outputs[10]=6'b00_0010; fsm_states[10]=6'o4__4;// SHIFT_RIGHT
		fsm_inputs[11]=10'b0_01_10_0_1110; fsm_outputs[11]=6'b00_0000; fsm_states[11]=6'o4__5;// NO_ERROR
		fsm_inputs[12]=10'b0_01_10_0_1110; fsm_outputs[12]=6'b01_0000; fsm_states[12]=6'o5__0;// WAIT_FOR_START
	end
	
	//main testbench
	
	initial begin:main_testbench
		integer i; 
		integer passed;
		i=0;
		passed=1;
		
		if(`DEBUG)
			$display("reset start divisor dividend | cnt=0 div=0 ds<dd div[MSB] | error done init left right sub (expected) | state next_state (expected)");
		
		repeat(`NUM_TEST_VECTORS) begin
			@(negedge clk);
			reset_iv=fsm_inputs[i][9];
			divisor_iv=fsm_inputs[i][8:7];
			dividend_iv=fsm_inputs[i][6:5];
			start_iv=fsm_inputs[i][4];
			#1
			
			// Save Mealy output for display
			mealy_outputs = {init_ov, left_ov, right_ov, sub_ov};
			mealy_next_state = next_state_ov;
			
			// Check Mealy outputs
			// Ignore outputs that are X
			if( (fsm_outputs[i][3] != 1'bx && init_ov !== fsm_outputs[i][3]) || 
				(fsm_outputs[i][2] != 1'bx && left_ov !== fsm_outputs[i][2]) || 
				(fsm_outputs[i][1] != 1'bx && right_ov !== fsm_outputs[i][1]) || 
				(fsm_outputs[i][0] != 1'bx && sub_ov !== fsm_outputs[i][0]) || 
				(fsm_states[i][2:0] != 3'bx && next_state_ov !== fsm_states[i][2:0]))
				begin
					passed = 0;
					$display("Mealy Fail");
				end
			
			if(`DEBUG)
				$display("%5b %5b %7b %8b | %5b %5b %5b %8b | %5b %4b %4b %4b %5b %3b (%3b %4b) | %5d %10d (%6d %1d)",
				reset_iv, start_iv, divisor_iv, dividend_iv, DUT.cnt_is_0, DUT.divisor_is_0, DUT.dvsr_less_than_dvnd, DUT.shifted_divisor_MSB,
						moore_outputs[1], moore_outputs[0], mealy_outputs[3], mealy_outputs[2], mealy_outputs[1], mealy_outputs[0],
						fsm_outputs[i][5:4], fsm_outputs[i][3:0], moore_state, mealy_next_state, fsm_states[i][5:3],fsm_states[i][2:0] );

			
			@(posedge clk);
			#1
			
			// Save Moore outputs for display
			moore_outputs = {error_ov, done_ov};
			moore_state = state_ov;
			
			// Check Moore outputs
			// Ignore outputs that are X
			if( (fsm_outputs[i][5] != 1'bx && error_ov !== fsm_outputs[i][5]) || 
				(fsm_outputs[i][4] != 1'bx && done_ov !== fsm_outputs[i][4]) || 
				(fsm_states[i][5:3] != 3'bx && state_ov !== fsm_states[i][5:3]) )
				begin
					passed = 0;
					$display("Moore Fail");
				end
						
			if (passed == 0)
			begin
				$display("Failed");
				$finish();
			end
			
			i=i+1;
		end
		if( passed == 1 ) $display("Pass");
		$finish();
	end

endmodule