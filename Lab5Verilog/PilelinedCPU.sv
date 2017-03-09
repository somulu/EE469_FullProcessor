module Stage1();
	
	
	InstxMem IM (Instruction, ProgramCounter, PCin, Clock1, Clock2, Reset); //inst is 32 bit output, pc is 7 bit output pcin is 7 bit for next location.
	Control CS (ALUop, SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUShift, Clock, InstxOp, Reset); // takes 11 bit Instxop and makes all these great outputs.
	RegisterFile Reg (R1ReadData, R2ReadData, R1RS, R2RS, WRS, WD, SWE, RST, Clock);
	SRAM Mem (DataBus, AdxBus, OE, RNW, Clock1, Clock2, Clock3);
	
endmodule
