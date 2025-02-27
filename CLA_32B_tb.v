module CLA_32B_tb ();
	reg [64:0] stimulus;
	reg [32:0] test_sum;
	reg clk;

	//output values
	wire signed [31:0] s; // sum
	wire signed [31:0] x;
	wire signed [31:0] y;
	wire c_out; //c4 is c_out
	
	assign x = stimulus[31:0];
	assign y = stimulus[63:32];
	
	CLA_32B test_CLA_32B(
		.a(stimulus[31:0]),
		.b(stimulus[63:32]),
		.c_in(stimulus[64]),
		.s(s), // sum
		.c_out(c_out) //c4 is c_out
	);
	
	// It is obviously unrealistic to provide all 2^(16+16+1) arithmetic operations, so a pseudo-randomized pool of cases are chosen instead.
	// 10000 cases are generated by a 32-bit LFSR.
	
	always @ (posedge clk) begin
		stimulus <= {stimulus[63:0], stimulus[30]^stimulus[29]^stimulus[28]^stimulus[27]};
	end
	
	// testbench correctness assertion
	always @ (posedge clk) begin
		$display("Test case: x = %d, y = %d, c_in = %d, sum = %d, c_out = %d", x, y, stimulus[64], s, c_out);
		test_sum = {1'b0,x} + {1'b0,y} + {32'b0,stimulus[64]};
		if (!(test_sum[31:0] == s)) begin
			$display("Sum is incorrect, expected %d when given sum of %d", test_sum, s);
			$finish;
		end
		if (!(test_sum[32] == c_out)) begin
			$display("Incorrect carry signal, expected: %b, instead got: %b", test_sum[64], c_out);
			$finish;
		end
	end
	
	initial begin
		stimulus <= 65'b1;
		clk <= 1'b0;
		repeat (10000) begin
			#10;
			clk <= 1'b1;
			#10;
			clk <= 1'b0;
		end
		
		$display("Testbench complete.");
	end
endmodule