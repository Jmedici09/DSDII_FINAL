//Fall'19 EECE 573/451 Final Project Testbench
//~mjain

`define TEST_WIDTH 32
module divider_tb();

reg [`TEST_WIDTH-1:0] a_iv, b_iv;
wire [`TEST_WIDTH-1:0] q_ov, r_ov;
reg clk, reset_iv, start_iv; 
wire error_ov, done_ov;

divider #(`TEST_WIDTH) dut (
	.dividend(a_iv), 
	.divisor(b_iv),
	.clk(clk),
	.reset(reset_iv),
	.start(start_iv),
	.quotient(q_ov),
	.remainder(r_ov),
	.error(error_ov),
	.done(done_ov)
);

initial begin
	clk=1'b0;
	forever 
	#10 clk=~clk;
end

initial begin:main_testbench
	reset_iv=1;
	@(posedge clk) #1;
		reset_iv=0;
		a_iv=`TEST_WIDTH'd1;
		b_iv=`TEST_WIDTH'd1;
		start_iv=1;
	
	@(posedge clk) #1;
		start_iv=0;
		while( done_ov == 0 )
			begin
				@(posedge clk);
					$display(q_ov, r_ov);
			end
	
	$display("Quotient",q_ov,,"Remainder",r_ov);
	$finish();

end

endmodule
