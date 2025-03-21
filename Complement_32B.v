module Complement_32B (
	input enable,
	input [31:0]in,
	output reg [31:0]out
);
reg flip;

integer i;

always @ (*) begin
	flip = 1'b0;
	if (enable) begin
		for(i = 0; i < 32; i = i + 1)begin
			if (!flip) begin
				out[i] <= in[i];
				if(in[i]==1'b1)begin
					flip=1'b1;
				end
			end else begin
				out[i] <= ~in[i];
			end
		end
	end else begin
		out = in;
	end
end


endmodule