`timescale 1ns/10ps
module DataPath_tb();

	reg PCout, Zlowout, Zhighout, MDRout, HIout, LOout, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out; // add any other signals to see in your simulation
	reg MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin;
	reg IncPC, Read, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
	reg AND, OR, ADD, SUB, MUL, DIV, SHR, SHRA, SHL, ROR, ROL, NEG, NOT;
	reg Clock;
	wire Clear;
	
	reg [31:0] Mdatain;
	
	parameter AND_s = 4'h0,OR_s=4'h1,ADD_s=4'h2,SUB_s=4'h3,MUL_s=4'h4,DIV_s=4'h5,SHR_s=4'h6,SHRA_s=4'h7,SHL_s=4'h8,ROR_s=4'h9,ROL_s=4'hA,NEG_s=4'hB,NOT_s=4'hC;

	parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
				Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
				T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101, Done = 4'b1110;
				
	reg [3:0] operation_state;
	reg [3:0] next_operation_state;
	
	reg [3:0] next_state;
	reg [3:0] present_state;
	
	assign Clear = 0;
	
	DataPath DataPath_DUT (
		.PCout(PCout), 
		.Zlowout(Zlowout), 
		.Zhighout(Zhighout),
		.MDRout(MDRout),
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
		.HIout(HIout),
		.LOout(LOout),
		.IncPC(IncPC), 
		.Read(Read), 
		.AND(AND),
		.OR(OR),
		.ADD(ADD),
		.SUB(SUB), // this is to stop the alu from z values
		.SHR(SHR),
		.SHRA(SHRA),
		.SHL(SHL),
		.ROR(ROR),
		.ROL(ROL),
		.MUL(MUL),
		.DIV(DIV),
		.NEG(NEG),
		.NOT(NOT),
		.MARin(MARin), 
		.Zin(Zin), 
		.PCin(PCin), 
		.MDRin(MDRin), 
		.IRin(IRin), 
		.Yin(Yin), 
		.LOin(LOin),
		.HIin(HIin),
		.R0in(R0in),
		.R1in(R1in),
		.R2in(R2in),
		.R3in(R3in),
		.R4in(R4in), 
		.R5in(R5in),
		.R6in(R6in),
		.R7in(R7in),
		.R8in(R8in),
		.R9in(R9in),	
		.R10in(R10in),
		.R11in(R11in),
		.R12in(R12in),
		.R13in(R13in),
		.R14in(R14in),
		.R15in(R15in),
		.Clock(Clock), 
		.Clear(Clear),
		.Mdatain(Mdatain)
	);
	
	// add test logic here
	initial begin
		Clock <= 1'b1;
		forever #10 Clock <= ~ Clock;
	end
	
	initial begin
		present_state <= Default;
		operation_state <= AND_s;
	end
	
	always @ (negedge Clock) begin
		#5;
		present_state <= next_state;
		if (present_state == Done) begin
			operation_state <= next_operation_state;
			present_state <= Default;
		end
	end
	
	always @(*) begin
	
		// this represents the d
		case (present_state)
			Default : next_state = Reg_load1a;
			Reg_load1a : next_state = Reg_load1b;
			Reg_load1b : next_state = Reg_load2a;
			Reg_load2a : next_state = Reg_load2b;
			Reg_load2b : if ((operation_state == MUL_s) || (operation_state == DIV_s)) next_state = T0; else next_state = Reg_load3a;
			Reg_load3a : next_state = Reg_load3b;
			Reg_load3b : next_state = T0;
			T0 : next_state = T1;
			T1 : next_state = T2;
			T2 : next_state = T3;
			T3 : next_state = T4;
			T4 : next_state = T5;
			T5 : if ((operation_state == MUL_s) || (operation_state == DIV_s)) next_state = T6; else next_state = Done; 
			T6 : next_state = Done;
		endcase
		
		// this is the order of instructions executed in the state machine 
		case (operation_state)
			AND_s : next_operation_state = OR_s;
			OR_s : next_operation_state = ADD_s;
			ADD_s : next_operation_state = SUB_s;
			SUB_s : next_operation_state = MUL_s;
			MUL_s : next_operation_state = DIV_s;
			DIV_s : next_operation_state = SHR_s;
			SHR_s : next_operation_state = SHRA_s;
			SHRA_s : next_operation_state = SHL_s;
			SHL_s : next_operation_state = ROR_s;
			ROR_s : next_operation_state = ROL_s;
			ROL_s : next_operation_state = NEG_s;
			NEG_s : next_operation_state = NOT_s;
			NOT_s : next_operation_state = AND_s;
		endcase
	end
	
	always @ (*) begin
		case (present_state)
			Default : begin
				PCout = 1'b0;
				Zlowout = 1'b0;
				Zhighout = 1'b0;
				HIout = 1'b0;
				LOout = 1'b0;
				MDRout = 1'b0;
				// TODO set all reg to 0 for other ops
				R0out = 1'b0;
				R1out = 1'b0;
				R2out = 1'b0;
				R3out = 1'b0;
				R4out = 1'b0;
				R5out = 1'b0;
				R6out = 1'b0;
				R7out = 1'b0;
				R8out = 1'b0;
				R9out = 1'b0;
				R10out = 1'b0;
				R11out = 1'b0;
				R12out = 1'b0;
				R13out = 1'b0;
				R14out = 1'b0;
				R15out = 1'b0;
				MARin = 1'b0;
				Zin = 1'b0;
				HIin = 1'b0;
				LOin = 1'b0;
				PCin = 1'b0;
				MDRin = 1'b0;
				IRin = 1'b0;
				Yin = 1'b0;
				IncPC = 1'b0;
				Read = 1'b0;
				// TODO set all alu inputs to 0
				AND = 1'b0;
				OR = 1'b0;
				ADD = 1'b0;
				SUB = 1'b0;
				MUL = 1'b0;
				DIV = 1'b0;
				SHR = 1'b0;
				SHRA = 1'b0;
				SHL = 1'b0;
				ROR = 1'b0;
				ROL = 1'b0;
				NEG = 1'b0;
				NOT = 1'b0;
				// TODO set all register in to 0
				R0in = 1'b0;
				R1in = 1'b0;
				R2in = 1'b0;
				R3in = 1'b0;
				R4in = 1'b0;
				R5in = 1'b0;
				R6in = 1'b0;
				R7in = 1'b0;
				R8in = 1'b0;
				R9in = 1'b0;
				R10in = 1'b0;
				R11in = 1'b0;
				R12in = 1'b0;
				R13in = 1'b0;
				R14in = 1'b0;
				R15in = 1'b0;
				Clock = 1'b0;
				Mdatain = 32'b0;
			end
			Reg_load1a: begin
				case (operation_state)
					NEG_s:
						begin
						Mdatain = 32'hF0000022;
						Read = 1; 
						MDRin = 1;						end
					NOT_s:
						begin
						Mdatain = 32'hF0000022;
						Read = 1; 
						MDRin = 1;
						end
					MUL_s: begin
						Mdatain = 32'hF0000022;
						Read = 1; 
						MDRin = 1;
					end
					DIV_s: begin
						Mdatain = 32'hF0000022;
						Read = 1; 
						MDRin = 1;
					end
					default:
						begin
							Mdatain = 32'hFFFEEE00;
							Read = 1; 
							MDRin = 1;
						end
				endcase
			end
			Reg_load1b: begin
				Read = 0; 
				MDRin = 0;
				// Blocking assignment so timing is not a concern for this state machine implementation
				MDRout = 1; 
				// TODO change this to specific register depending on operation state
				case (operation_state)
					NEG_s:begin R0in=1;end
					NOT_s:begin R0in=1;end
					MUL_s: begin
						R2in = 1;
					end
					DIV_s: begin
						R2in = 1;
					end
					default:
						R3in = 1;
				endcase
			end
			Reg_load2a: begin
				MDRout = 0;
				// change this to specific register depending on operation state
				R0in=0;
				R3in = 0;
				R2in = 0;
				case (operation_state)
					NEG_s:
						begin
							Read = 0;
						end
					NOT_s:
						begin
							Read = 0;
						end
					default:
						begin
							Mdatain = 32'h2;
							Read = 1; 
							MDRin = 1;
						end
				endcase
			end
			Reg_load2b: begin
				Read = 0; 
				MDRin = 0;
				
				MDRout = 1; 
				// TODO change this to specific register depending on operation state
				case (operation_state)
					NEG_s:begin end
					NOT_s:begin end
					MUL_s: 
						R6in = 1;
					DIV_s: 
						R6in = 1;
					default:
						R7in = 1;
				endcase
			end
			Reg_load3a: begin
				MDRout = 0;
				// TODO change this to specific register depending on operation state
				R7in = 0;
				Mdatain = 32'h00000028;
				Read = 1; 
				MDRin = 1;
			end
			Reg_load3b: begin
				Read = 0; 
				MDRin = 0;
				
				MDRout = 1;
				// TODO change this to specific register depending on operation state
				case (operation_state)
					NEG_s:
						R5in = 1; // for the sake of ensuring that R5 changes?
					NOT_s:
						R5in = 1;
					default:
						R4in = 1;
				endcase

			end
			T0: begin
				MDRout = 0;
				// TODO change this to specific register depending on operation state
				R4in = 0;
				R5in = 0;
				R6in = 0;
				
				PCout = 1; 
				MARin = 1; 
				IncPC = 1; 
				Zin = 1;
			end
			T1: begin
				PCout = 0; 
				MARin = 0; 
				IncPC = 0; 
				Zin = 0;
				
				Zlowout = 1; 
				PCin = 1; 
				Read = 1; 
				MDRin = 1;
				// TODO change this to specific register depending on operation state
				case (operation_state)
					AND_s : Mdatain = 32'h2A1B8000;
					OR_s : Mdatain = 32'h321B8000;
					ADD_s : Mdatain = 32'h1A1B8000;
					SUB_s : Mdatain = 32'h221B8000;
					MUL_s: Mdatain = 32'h81300000;
					DIV_s: Mdatain = 32'h79300000;
					SHR_s : Mdatain = 32'h4A1B8000;
					SHRA_s : Mdatain = 32'h521B8000;
					SHL_s : Mdatain = 32'h5A1B8000;
					ROR_s : Mdatain = 32'h3a1b8000;
					ROL_s : Mdatain = 32'h422b8000;
					NEG_s : Mdatain = 32'h8a800000;
					NOT_s : Mdatain = 32'h92800000;
				endcase
			end
			T2: begin
				Zlowout = 0; 
				PCin = 0; 
				Read = 0; 
				MDRin = 0;
				
				MDRout = 1;
				IRin = 1;
			end
			T3: begin
				MDRout = 0;
				IRin = 0;
				
				// TODO change this to specific register depending on operation state
				case (operation_state)
					NEG_s:
						R0out = 1;
					NOT_s:
						R0out = 1;
					MUL_s:
						R2out = 1;
					DIV_s:
						R2out = 1;
					default:
						R3out = 1;
				endcase
				Yin = 1;
			end
			T4: begin
				// TODO change this to specific register depending on operation state
				R0out = 0;
				R2out = 0;
				R3out = 0;
				Yin = 0;
				
				// TODO change this to specific register depending on operation state

				case (operation_state)
					AND_s : begin AND = 1; R7out = 1; end
					OR_s :  begin OR  = 1; R7out = 1; end
					ADD_s : begin ADD = 1; R7out = 1; end
					SUB_s : begin SUB = 1; R7out = 1; end
					MUL_s : begin MUL = 1; R6out = 1; end
					DIV_s : begin DIV = 1; R6out = 1; end
					SHR_s : begin SHR = 1; R7out = 1; end
					SHRA_s : begin SHRA = 1; R7out = 1; end
					SHL_s : begin SHL = 1; R7out = 1; end
					ROR_s : begin ROR = 1; R7out = 1; end
					ROL_s : begin ROL = 1; R7out = 1; end
					NEG_s : begin NEG = 1; end
					NOT_s : begin NOT = 1; end
				endcase
				Zin = 1;
			end
			T5: begin
				// TODO change this to specific register depending on operation state
				R6out = 0;
				R7out = 0; 
				Zin = 0;

				AND  = 0;
				OR   = 0;
				ADD  = 0;
				SUB  = 0;
				MUL  = 0;
				DIV  = 0;
				SHR  = 0;
				SHRA = 0;
				SHL  = 0;
				ROR  = 0;
				ROL  = 0;
				NEG  = 0;
				NOT  = 0;
				
				Zlowout = 1;

				// TODO change this to specific register depending on operation state
				case (operation_state)
					NEG_s:
						R5in = 1;
					NOT_s:
						R5in = 1;
					MUL_s:
						LOin = 1;
					DIV_s:
						LOin = 1;
					default:
						R4in = 1;
				endcase
			end
			T6: begin
				LOin = 0;
				Zlowout = 0;
				
				Zhighout = 1;
				HIin = 1;
			end
			Done: begin
				if (operation_state==NOT_s)begin
					$stop;
				end
			end
		endcase
	end
	
	//logic to double check values for each state
	// TODO change this to specific register depending on operation state
	/*
	always @ (negedge Clock) begin
		case (present_state)
			Reg_load1a: begin
				$display("At 1a - %t: MDR Output = %b", $time, DataPath_DUT.BusMuxInMDR);
			end
			Reg_load1b: begin
				$display("At 1b - %t: MDR Output = %b, BusMuxOut = %b, R3 = %b", $time, DataPath_DUT.BusMuxInMDR, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR3);
			end
			Reg_load2a: begin
				$display("At 2a - %t: MDR Output = %b", $time, DataPath_DUT.BusMuxInMDR);
			end
			Reg_load2b: begin
				$display("At 2b - %t: MDR Output = %b, BusMuxOut = %b, R7 = %b", $time, DataPath_DUT.BusMuxInMDR, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR7);
			end
			Reg_load3a: begin
				$display("At 3a - %t: MDR Output = %b", $time, DataPath_DUT.BusMuxInMDR);
			end
			Reg_load3b: begin
				$display("At 3b - %t: MDR Output = %b, BusMuxOut = %b, R4 = %b", $time, DataPath_DUT.BusMuxInMDR, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR4);
			end
			T0: begin
				$display("At T0 - %t: PC Output = %b, MAR Output = %b, Z Output = %b", $time, DataPath_DUT.BusMuxInPC, DataPath_DUT.MAR.q, DataPath_DUT.BusMuxInZlo);
			end
			T1: begin
				$display("At T1 - %t: BusMuxOut = %b, PC Output = %b, MDR Output = %h", $time, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInPC, DataPath_DUT.BusMuxInMDR);
			end
			T2: begin
				$display("At T2 - %t: BusMuxOut = %h, IR = %h", $time, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInIR);
			end
			T3: begin
				$display("At T3 - %t: BusMuxOut = %b, R3 = %b, Y = %b", $time, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR3, DataPath_DUT.Y_Out);
			end
			T4: begin
				$display("At T4 - %t: BusMuxOut = %b, R7 = %b, R3 = %b, Zlow = %b", $time, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR7, DataPath_DUT.BusMuxInR3, DataPath_DUT.BusMuxInZlo);
			end
			T5: begin
				$display("At T5 - %t: Zlow = %b, BusMuxOut = %b, R4 = %b", $time, DataPath_DUT.BusMuxInZlo, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR4);
			end
		endcase
	end
	*/
	
endmodule