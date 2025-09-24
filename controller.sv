// CONTROLLER

module controller(input logic [10:0] instr,
				  input logic ExtIRQ, reset, ExcAck, 
						output logic [3:0] AluControl, EStatus,						
						output logic reg2loc, regWrite, AluSrc, Branch,
											memtoReg, memRead, memWrite,ExtIAck,Exc );
											
	logic [1:0] AluOp_s;
											
	maindec 	decPpal 	(
							.ExtIRQ(ExtIRQ),
							.reset(reset),
							.Op(instr), 
							.Reg2Loc(reg2loc), 
							.ALUSrc(AluSrc), 
							.MemtoReg(memtoReg), 
							.RegWrite(regWrite), 
							.MemRead(memRead), 
							.MemWrite(memWrite), 
							.Branch(Branch), 
							.ALUOp(AluOp_s),
							.EStatus(EStatus),
							.Exc(Exc)
	);	
	ExtIAck = ExcAck && ExtIRQ;
								
	aludec 	decAlu 	(.funct(instr), 
							.aluop(AluOp_s), 
							.alucontrol(AluControl));
			
endmodule
