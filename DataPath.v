module DataPath(
	input PCout, //done
	input Zlowout, //done
	input Zhighout,
	input MDRout, 
	input LOout,
	input HIout,
	input R0out,
	input R1out,
	input R2out,
	input R3out,
	input R4out,
	input R5out,
	input R6out,
	input R7out,
	input R8out,
	input R9out,
	input R10out,
	input R11out,
	input R12out,
	input R13out,
	input R14out,
	input R15out,
	input IncPC, 
	input Read, //Read is for MDR read signal, done
	input AND, 
	input ADD,
	input SUB, 
	input MUL, 
	input DIV, 
	input SHR,
	input SHRA,
	input SHL, 
	input ROR, 
	input ROL, 
	input OR, 
	input NEG, 
	input NOT,
	input MARin, 
	input Zin, //done
	input PCin, //done
	input MDRin, //done
	input IRin, //done
	input Yin, //done
	input LOin,
	input HIin,
	input R0in,
	input R1in,
	input R2in,
	input R3in, //done
	input R4in, //done
	input R5in,
	input R6in,
	input R7in, //done
	input R8in,
	input R9in,
	input R10in,
	input R11in,
	input R12in,
	input R13in,
	input R14in,
	input R15in,
	input Clock, //done
	input Clear,
	input [31:0] Mdatain //done
);
	wire [31:0] Y_Out;
	wire [31:0] ALU_A;
	wire [63:0] ALU_Out;
	wire [31:0] BusMuxInPC, BusMuxInR0, BusMuxInR1, 
					BusMuxInR2, BusMuxInR3, BusMuxInR4, 
					BusMuxInR5, BusMuxInR6, BusMuxInR7, 
					BusMuxInR8, BusMuxInR9, BusMuxInR10,
					BusMuxInR11, BusMuxInR12, BusMuxInR13, 
					BusMuxInR14, BusMuxInR15, BusMuxInZlo, 
					BusMuxInZhi, BusMuxInMDR, BusMuxInIR,
					BusMuxInLO, BusMuxInHI;
			
	wire [31:0] BusMuxOut; 

	assign ALU_A = (IncPC) ? 32'b1 : Y_Out;
	assign BusMuxInR0 = 32'b0;
	
	// Register File
	Register PC(.Clear(Clear), .Clock(Clock), .Enable(PCin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInPC));
	
	Register IR(.Clear(Clear), .Clock(Clock), .Enable(IRin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInIR));
	Register RY(.Clear(Clear), .Clock(Clock), .Enable(Yin), .BusMuxOut(BusMuxOut), .BusMuxIn(Y_Out));
	
	//Register R0(.Clear(1'b1), .Clock(Clock), .Enable(1'b0), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR0));
	Register R1(.Clear(Clear), .Clock(Clock), .Enable(R1in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR1));
	Register R2(.Clear(Clear), .Clock(Clock), .Enable(R2in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR2));
	Register R3(.Clear(Clear), .Clock(Clock), .Enable(R3in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR3));
	Register R4(.Clear(Clear), .Clock(Clock), .Enable(R4in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR4));
	Register R5(.Clear(Clear), .Clock(Clock), .Enable(R5in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR5));
	Register R6(.Clear(Clear), .Clock(Clock), .Enable(R6in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR6));
	Register R7(.Clear(Clear), .Clock(Clock), .Enable(R7in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR7));
	Register R8(.Clear(Clear), .Clock(Clock), .Enable(R8in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR8));
	Register R9(.Clear(Clear), .Clock(Clock), .Enable(R9in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR9));
	Register R10(.Clear(Clear), .Clock(Clock), .Enable(R10in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR10));
	Register R11(.Clear(Clear), .Clock(Clock), .Enable(R11in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR11));
	Register R12(.Clear(Clear), .Clock(Clock), .Enable(R12in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR12));
	Register R13(.Clear(Clear), .Clock(Clock), .Enable(R13in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR13));
	Register R14(.Clear(Clear), .Clock(Clock), .Enable(R14in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR14));
	Register R15(.Clear(Clear), .Clock(Clock), .Enable(R15in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR15));

	Register LO(.Clear(Clear), .Clock(Clock), .Enable(LOin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInLO));
	Register HI(.Clear(Clear), .Clock(Clock), .Enable(HIin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInHI));
	Register Zlo(.Clear(Clear), .Clock(Clock), .Enable(Zin), .BusMuxOut(ALU_Out[31:0]), .BusMuxIn(BusMuxInZlo));
	Register Zhi(.Clear(Clear), .Clock(Clock), .Enable(Zin), .BusMuxOut(ALU_Out[63:32]), .BusMuxIn(BusMuxInZhi));
	
	Register MAR(.Clear(Clear), .Clock(Clock), .Enable(MARin), .BusMuxOut(BusMuxOut)); // connect to memory bus later
	MDR MDR(.Clear(Clear), .Clock(Clock), .MDRin(MDRin), .BusMuxOut(BusMuxOut), .Mdatain(Mdatain), .Read(Read), .BusMuxIn(BusMuxInMDR));
	
	ALU ALU_DUT (
		.a(ALU_A),
		.b(BusMuxOut),
		.ADD(ADD | IncPC), 
		.SUB(SUB), 
		.MUL(MUL), 
		.DIV(DIV), 
		.SHR(SHR),
		.SHRA(SHRA),
		.SHL(SHL), 
		.ROR(ROR), 
		.ROL(ROL), 
		.AND(AND), 
		.OR(OR), 
		.NEG(NEG), 
		.NOT(NOT),
		.c(ALU_Out)
	);
	
	//Bus
	Bus Bus_DUT(
		.BusMuxInPC(BusMuxInPC),
		.BusMuxInZlo(BusMuxInZlo),
		.BusMuxInZhi(BusMuxInZhi),
		.BusMuxInR0(BusMuxInR0),
		.BusMuxInR1(BusMuxInR1),
		.BusMuxInR2(BusMuxInR2),
		.BusMuxInR3(BusMuxInR3),
		.BusMuxInR4(BusMuxInR4),
		.BusMuxInR5(BusMuxInR5),
		.BusMuxInR6(BusMuxInR6),
		.BusMuxInR7(BusMuxInR7),
		.BusMuxInR8(BusMuxInR8),
		.BusMuxInR9(BusMuxInR9),
		.BusMuxInR10(BusMuxInR10),
		.BusMuxInR11(BusMuxInR11),
		.BusMuxInR12(BusMuxInR12),
		.BusMuxInR13(BusMuxInR13),
		.BusMuxInR14(BusMuxInR14),
		.BusMuxInR15(BusMuxInR15),
		.BusMuxInMDR(BusMuxInMDR),
		.PCout(PCout), 
		.R0out(R0out),
		.R1out(R1out),
		.R2out(R2out),
		.R3out(R3out),
		.R4out(R4out),
		.R5out(R5out),
		.R6out(R6out),
		.R7out(R7out),
		.R8out(R8out),
		.R9out(R9out),
		.R10out(R10out),
		.R11out(R11out),
		.R12out(R12out),
		.R13out(R13out),
		.R14out(R14out),
		.R15out(R15out),
		.Zlowout(Zlowout),
		.Zhighout(Zhighout),
		.LOout(LOout),
		.HIout(HIout),
		.MDRout(MDRout),
		.BusMuxOut(BusMuxOut)
	);
	

endmodule 