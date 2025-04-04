`timescale 1ns/10ps
module DataPath_tb2();

	reg PCout, Zlowout, Zhighout, MDRout, HIout, LOout, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out; // add any other signals to see in your simulation
	reg MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin, CONin;
	reg IncPC, Read, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, RAin;
	reg AND, OR, ADD, SUB, MUL, DIV, SHR, SHRA, SHL, ROR, ROL, NEG, NOT;
	reg Write, Rin, Rout, Gra, Grb, Grc, BAout, Cout, OutPortIn, OutPortOut, RINout;
	reg BranchTaken;
	reg Clock;
	wire Clear;
	wire BranchOut;
	wire [31:0] OutPort_Out;
	reg [31:0] Mdatain, INPort_In;
	reg Strobe;

	parameter Ld=5'h0,Ldi=5'h1,St=5'h2,Addi=5'h3,Andi=5'h4,Ori=5'h5,Brzr=5'h6,Brnz=5'h7,Brpl=5'h8,Brmi=5'h9,Jr=5'hA,Jal=5'hB,Mfhi=5'hC,Mflo=5'hD,In=5'hE,Out=5'hF, Mul = 5'h10, Div = 5'h11;

	parameter T0=4'h0,T1=4'h1,T2=4'h2,T3=4'h3,T4=4'h4,T5=4'h5,T6=4'h6,T7=4'h7,Done=4'h8,Default = 4'h9;
  
	reg [4:0] operation_state;
	
	reg [3:0] next_state;
	reg [3:0] present_state;
	
	assign Clear = 0;
	
	DataPath DataPath_DUT (
		.PCout(PCout), //done
		.Zlowout(Zlowout), //done
		.Zhighout(Zhighout),
		.MDRout(MDRout), 
		.LOout(LOout),
		.HIout(HIout),
		.IncPC(IncPC), 
		.Read(Read), //Read is for MDR read signal, done
		.AND(AND), 
		.ADD(ADD),
		.SUB(SUB), 
		.MUL(MUL), 
		.DIV(DIV), 
		.SHR(SHR),
		.SHRA(SHRA),
		.SHL(SHL), 
		.ROR(ROR), 
		.ROL(ROL), 
		.OR(OR), 
		.NEG(NEG), 
		.NOT(NOT),
		.MARin(MARin), 
		.Zin(Zin), //done
		.PCin(PCin), //done
		.MDRin(MDRin), //done
		.IRin(IRin), //done
		.Yin(Yin), //done
		.Write(Write),
		.LOin(LOin),
		.HIin(HIin),
		.Clock(Clock), //done
		.Clear(Clear),
		.INPort_In(INPort_In), //done
		.Rin(Rin),
		.Rout(Rout),
		.Gra(Gra),
		.Grb(Grb),
		.Grc(Grc),
		.Cout(Cout),
		.BAout(BAout),
		.CONin(CONin),
		.Strobe(Strobe), // This is the ready signal for the output port, asserted by testbench
		.OutPortIn(OutPortIn), // this is the control signal for the output port
		.OutPortOut(OutPortOut), // output outport to busmux out
		.OutPort_Out(OutPort_Out), // this is also an output
		.RINout(RINout),
		.BranchOut(BranchOut), // use this signal to see if the branch occurs or not: 1 = branch, 0 = no branch
		.RAin(RAin)
	);
	
	// add test logic here
	initial begin
		Clock <= 1'b1;
		forever #10 Clock <= ~ Clock;
	end
	
	integer instruction;
	initial begin
		instruction=0;
		present_state <= Default;
		operation_state <= Ld;
	end
	
	always @ (negedge Clock) begin
		#5;
		if(present_state==T7)
			instruction=instruction+1;
		present_state <= next_state;
	end
	
	always @(*) begin
	
		// this represents the d
		case (present_state)
			Default : next_state = T0;
			T0 : next_state = T1;
			T1 : next_state = T2;
			T2 : next_state = T3;
			T3 : next_state = T4;
			T4 : next_state = T5;
			T5 : next_state = T6;
			T6 : next_state = T7;
      T7 : begin
				next_state = Default;
				if(instruction>=12'h1FF) begin
					next_state=Done;
				end
			end
			Done:next_state=Done;
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
				Write = 1'b0;
				Rin = 1'b0;
				Rout = 1'b0;
				Gra = 1'b0;
				Grb = 1'b0;
				Grc = 1'b0;
				BAout = 1'b0;
				Cout = 1'b0;
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
				RAin = 1'b0;
				Clock = 1'b0;
				Mdatain = 32'b0;
				CONin = 1'b0;
				BranchTaken = 1'b0;
				OutPortIn = 1'b0;
				Strobe = 1'b0;
				INPort_In=32'hABCDEF00;
				OutPortOut = 1'b0;
			end
			Done:
				$stop;
			T0 : 
      begin
        PCout=1;
        MARin=1;
        IncPC=1;
        Zin=1;
		  Strobe=1; 
      end
      T1 : 
      begin
        PCout=0;
        MARin=0;
        IncPC=0;
        Zin=0;
        Zlowout=1;
        PCin=1;
        Read=1;
        MDRin=1;
      end
      T2 : 
      begin
        Zlowout=0;
        PCin=0;
        Read=0;
        MDRin=0;
        MDRout=1;
        IRin=1;

				case (DataPath_DUT.BusMuxInIR[31:27])
					5'b00000 : operation_state = Ld;
					5'b00001 : operation_state = Ldi;
					5'b00010 : operation_state = St;
					5'b01100 : operation_state = Addi;
					5'b01101 : operation_state = Andi;
					5'b01110 : operation_state = Ori;
					5'b10011 : case(DataPath_DUT.BusMuxInIR[20:19])
						2'b00: operation_state = Brzr;
						2'b01: operation_state = Brnz;
						2'b10: operation_state = Brpl;
						2'b11: operation_state = Brmi;
					endcase
					5'b10101 : operation_state = Jr;
					5'b10100 : operation_state = Jal;
					5'b11001 : operation_state = Mfhi;	
					5'b11000 : operation_state = Mflo;
					5'b10110 : operation_state = In;
					5'b10111 : operation_state = Out;
					5'b10000 : operation_state = Mul;
					5'b01111 : operation_state = Div;
				endcase
      end
      T3 : 
      begin
        MDRout=0;
        IRin=0;
        case (operation_state)
          Ld,Ldi,St:begin
            Grb=1;
            BAout=1;
            Yin=1;
					end
					Addi, Andi, Ori: begin
						Grb = 1;
						Rout = 1;
						Yin = 1;
					end
					Brzr,Brnz,Brpl,Brmi:begin
						Gra = 1;
						Rout = 1;
						CONin = 1;
						BranchTaken = BranchOut;
					end
					Jr:begin
						Gra = 1;
						Rout = 1;
						PCin = 1;
					end
					Jal: begin
						RAin = 1;
						Rin = 1;
						PCout = 1;
					end
					Mfhi:begin
						Gra=1;
						Rin=1;
						HIout=1;
					end
					Mflo:begin
						Gra=1;
						Rin=1;
						LOout=1;
					end
					In:begin
						Gra=1;
						Rin=1;
						RINout=1;
					end
					Out:begin
						Gra=1;
						Rout=1;
						OutPortIn=1;
					end
					Mul, Div:begin
						Gra=1;
						Rout=1;
						Yin=1;
					end
        endcase
      end
      T4 : 
      begin
        case(operation_state)
          Ld,Ldi,St:begin
            Grb=0;
            BAout=0;
            Yin=0;
            Cout=1;
            ADD=1;
            Zin=1;
          end
					Addi: begin
						Grb = 0;
						Rout = 0;
						Yin = 0;
						Cout = 1;
						ADD = 1;
						Zin = 1;
					end
					Andi: begin
						Grb = 0;
						Rout = 0;
						Yin = 0;
						Cout = 1;
						AND = 1;
						Zin = 1;
					end
					Ori: begin
						Grb = 0;
						Rout = 0;
						Yin = 0;
						Cout = 1;
						OR = 1;
						Zin = 1;
					end
					Brzr,Brnz,Brpl,Brmi:begin
						Gra=0;
						Rout=0;
						CONin = 0;
						PCout = 1;
						Yin = 1;
					end
					Jr:begin
						Gra = 0;
						Rout = 0;
						PCin = 0;
					end
					Jal: begin
						RAin = 0;
						Rin = 0;
						PCout = 0;
						
						Gra = 1;
						Rout = 1;
						PCin = 1;
					end
					Mfhi:begin
						Gra=0;
						Rin=0;
						HIout=0;
					end
					Mflo:begin
						Gra=0;
						Rin=0;
						LOout=0;
					end
					In:begin
						Gra=0;
						Rin=0;
						RINout=0;
					end
					Out:begin
						Gra=0;
						Rout=0;
						OutPortIn=0;
					end
					Mul:begin
						Gra=0;
						Yin=0;
						Rout=1;
						Grb=1;
						MUL=1;
						Zin=1;
					end
					Div:begin
						Gra=0;
						Yin=0;
						Rout=1;
						Grb=1;
						DIV=1;
						Zin=1;
					end
        endcase
      end
      T5 : 
      begin
        case(operation_state)
          Ld:begin
            Cout=0;
            ADD=0;
            Zin=0;
            Zlowout=1;
            MARin=1;
          end
					Ldi:begin
            Cout=0;
            ADD=0;
            Zin=0;
            Zlowout=1;
						Gra=1;
						Rin=1;
					end
					St:begin
						Cout=0;
            ADD=0;
            Zin=0;
						Zlowout=1;
            MARin=1;
					end
				
				Addi, Andi, Ori: begin
					Cout = 0;
					AND = 0;
					ADD = 0;
					OR = 0;
					Zin = 0;
					Zlowout = 1;
					Gra = 1;
					Rin = 1;
				end
				Brzr,Brnz,Brpl,Brmi:begin
					PCout = 0;
					Yin = 0;
					ADD = 1;
					Cout = 1;
					Zin = 1;
				end
				Jal: begin
					Gra = 0;
					Rout = 0;
					PCin = 0;
				end
				Mul, Div:begin
					Rout=0;
					Grb=0;
					DIV=0;
					MUL=0;
					Zin=0;
					Zlowout = 1;
					LOin = 1;
				end
        endcase
      end
      T6 : 
      begin
        case(operation_state)
          Ld:begin
            Zlowout=0;
            MARin=0;
            Read=1;
            MDRin=1;
          end
					Ldi:begin
						Zlowout=0;
						Gra=0;
						Rin=0;
					end
					St:begin
            Zlowout=0;
            MARin=0;
						Gra=1;
						Rout=1;
						Write=1;
					end
					Brzr,Brnz,Brpl,Brmi:begin
						Cout = 0;
						Zin = 0;
						ADD = 0;
						Zlowout = 1;
						if (BranchTaken)
							PCin = 1;
					end
					Mul, Div:begin
						Zlowout = 0;
						LOin = 0;
						Zhighout = 1;
						HIin = 1;
					end
        endcase
      end
      T7 : 
      begin
        case(operation_state)
		  			Brzr,Brnz,Brpl,Brmi:begin
						Zlowout = 0;
						PCin = 0;
					end
          Ld:begin
            Read=0;
            MDRin=0;
            MDRout=1;
            Gra=1;
            Rin=1;
          end
					St:begin
						Gra=0;
						Rout=0;
						Write=0;
					end
					Mul, Div:begin
						Zhighout = 0;
						HIin = 0;
					end
					
        endcase

      end
      
      endcase
	end
	
endmodule