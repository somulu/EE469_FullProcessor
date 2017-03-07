module Datapath (ProgramCounter, ALUOP, SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUshift, InstxOp, Phi, RST);
	input [5:0] Phi;
	input [2:0] ALUOP;
	input SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUshift, RST;
	output [10:0] InstxOp;
	output [6:0] ProgramCounter; 
	
	wire BGRmux = (flagreg[2] ~^ flagreg[1]) & ~flagreg[3] & BGR;
	
	// program counter structures
	wire [31:0] Instruction;
	wire [6:0] ProgramCounter;
	reg [6:0] PCin;
	InstxMem InstructionMemory (Instruction, ProgramCounter, PCin, Phi[5], Phi[0], RST);
	
	assign InstxOp = Instruction[31:21];

	// incrementing adder
	//wire [15:0] incrementaddend, incrementaugend, incrementaddersum;
	//assign incrementaddend = {1'b0, ProgramCounter};
	//assign incrementaugend = 8'b00000001;
	//eightbitfastadder IncrementAdder (incrementaddend, incrementaugend, 1'b0, incrementaddersum, );
	wire [15:0] incrementaddersum;
	alu ADD ({9'b0, ProgramCounter}, 16'h01, 3'b001, incrementaddersum, );


	wire [6:0] BGRresult;
	assign BGRresult = BGRmux ? Instruction[11:5] : incrementaddersum[6:0];
	
	wire [6:0] BSCresult;
	assign BSCresult = BSC ? Read1Data[6:0] : Instruction[6:0];
	
	wire [6:0] NextPC;
	assign NextPC = PCC ? BSCresult : BGRresult;
	
	always@(posedge Phi[4])
		if(!RST)
			PCin <= 7'h00;
		else
			PCin <= NextPC;
	
	// reg file
	wire [31:0] Read1Data, Read2Data, WriteData;
	wire [4:0] Read1Sel, Read2Sel, WriteSel;
	RegisterFile RegFile (Read1Data, Read2Data, Read1Sel, Read2Sel, WriteSel, WriteData, SWE, RST, Phi[4]);
	

	
	
	// ALU
	wire [15:0] A, B, busOut;
	wire [3:0] flags;
	alu ALU (A, B, ALUOP, busOut, flags);
	
	// ALU hold registers
	reg [15:0] Ahold, Bhold;
	reg [31:0] ALUout;
	reg [3:0] flagreg;
	
	always@(posedge Phi[2]) begin
		Ahold <= Read1Data[15:0];
		Bhold <= ALUshift ? {10'h000, Instruction[15:10]} : Read2Data[15:0];
	end
	
	assign A = Ahold;
	assign B = Bhold;
	
	always@(posedge Phi[3]) begin
		ALUout <= {{16{busOut[15]}}, busOut}; //sign extend
		flagreg <= flags;
	end

	
	// SRAM
	wire [31:0] SRAMData;
	wire [10:0] SRAMAdx;
	SRAM Memory (SRAMData, SRAMAdx, OE, RNW, Phi[2], Phi[3], Phi[4]);
	
	wire [31:0] SRAMDataBus;
	wire [31:0] SystemBus;
	assign SRAMData = OE ? Read2Data : 32'bz;
	assign SRAMDataBus = ~OE ? SRAMData : 32'bz;


	assign SRAMAdx = Read1Data[10:0];
	assign Read1Sel = Instruction[9:5];
	assign Read2Sel = R2LOC ? Instruction[4:0] : Instruction[20:16];
	assign WriteSel = Instruction[4:0];
	assign WriteData = WDmux ? SRAMDataBus : ALUout;
	
	
endmodule

