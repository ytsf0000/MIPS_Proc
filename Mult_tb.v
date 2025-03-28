`timescale 1ns/10ps
module Mult_tb();

wire signed [63:0] res;

reg signed [31:0] a;
reg signed [31:0] b;

Mult Test(
	a,b,
	res
);

reg signed [63:0] test_compare;
reg signed [63:0] test_result;
reg [31:0] seed;

integer i;
initial begin
	seed =$random(seed);
	for (i = 0; i < 1000; i = i + 1) begin
		seed =$random(seed);
		a = seed;
		seed =$random(seed);
		b = seed;
		
		#50; //arbitrary delay
		
		test_compare = a*b;
		test_result=res;
		
		$display("a: %d,b: %d, res: %d", a,b,res);
		$display("true: %d, test: %d",test_compare,test_result);
		
		
		if (test_compare == test_result) 
			$display ("Correct");
		else begin
			$display ("Incorrect");
			#20
			$finish;
		end
	end
end

endmodule