


module PilelinedCPU(SysCLK, RST, SysRST);
	input RST, SysCLK, SysRST;

	/***********************************************************
		This Block Handles the CLOCK and Reset
	***********************************************************/
	wire [4:0] Phases; // five phase clock that runs each stage of the pipeline
	wire Reset;
	FivePhaseClock FPC (Phases, SysRST, SysCLK);
	
	StateCounter SC (Reset, RST, Phases[0], SysRST);


	/***********************************************************
		This Block Handles the Instruction Memory and Control
	***********************************************************/
	reg [31:0] Execute, Writeback; 
	reg [11:0] ExCntrl;
	reg [7:0] WbCntrl;

	wire [31:0] Instruction;
	wire [6:0] ProgramCounter;
	reg [6:0] PCin; // buffers the next program location
	wire [2:0] ALUop;
	wire SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUShift;
	wire [10:0] InstxOp;
	assign InstxOp = Instruction[31:21];
	wire [11:0] controlBus;

	InstxMem IM (Instruction, ProgramCounter, PCin, Phases[1], Phases[2], Reset);
	Control CNTRL (ALUop, SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUShift, Phases[3], InstxOp, Reset);

	assign controlBus = {ALUop, R2LOC, WDmux, PCC, BSC, BGR, ALUShift, SWE, OE, RNW};

	// passing along the instructions for the phases
	always@(posedge Phases[0])
		if(!Reset) begin
			Execute <= 32'h00000000;
			Writeback <= 32'h00000000;
			ExCntrl <= controlBus;
			WbCntrl <= controlBus[7:0]; // two source for wbcntrl
		end else begin
			Execute <= Instruction;
			Writeback <= Execute;
			ExCntrl <= controlBus;
			WbCntrl <= ExCntrl[7:0];
		end



	/***********************************************************
		This Block Handles the Register File
	***********************************************************/
	wire [31:0] R1ReadData, R2ReadData, WD;
	wire [4:0] R1RS, R2RS, WRS;

	assign R1RS = Execute[9:5];
	assign R2RS = ExCntrl[8] ? Execute[4:0] : Execute[20:16]; // changed from ExCntrl[7] to ExCntrl[8] which is R2Loc
	assign WRS = Writeback[4:0];
	assign WD = WbCntrl[7] ? SystemBus : Outhold;// I think we want this on WbCntrl[7] which is WDmux
	RegisterFile RF(R1ReadData, R2ReadData, R1RS, R2RS, WRS, WD, WbCntrl[2], Reset, Phases[3]);



	/***********************************************************
		This Block Handles the ALU
	***********************************************************/
	wire [3:0] flags;
	wire [15:0] busA, busB, busOut;
	wire [2:0] control;

	reg [15:0] Ahold, Bhold;
	reg [31:0] Outhold;
	reg [3:0] flagReg, WflagReg;
	
	always@(posedge Phases[0])
		if(!Reset)
			WflagReg <= 4'h0;
		else
			WflagReg <= flagReg;

	assign busA = Ahold;
	assign busB = Bhold;
	assign control = ExCntrl[11:9];

	always@(posedge Phases[3]) begin
		Ahold <= R1ReadData[15:0];
		Bhold <= ExCntrl[3] ? {10'h000, Execute[15:10]} : R2ReadData[15:0];
	end

	always@(posedge Phases[4]) begin
		Outhold <= {{16{busOut[15]}}, busOut};
		flagReg <= flags;
	end
	alu ALU (busA, busB, control, busOut, flags);



	/***********************************************************
		This Block Handles the SRAM
	***********************************************************/
	wire [10:0] AdxBus;
	wire [31:0] SRAMDataBus;
	wire [31:0] SystemBus;
	
	// THIS PART MAY THROW AN ERROR IN INSTRUCTION CYCLE
	// Possible solution is to have MAR update earlier
	// Or forward the relevant RF data to the next stage
	assign AdxBus = R1ReadData[10:0];
	assign SRAMDataBus = WbCntrl[1] ? R2ReadData : 32'bz; 
	assign SystemBus = ~WbCntrl[1] ? SRAMDataBus : 32'bz;
	SRAM Cache (SRAMDataBus, AdxBus, WbCntrl[1], WbCntrl[0], Phases[1], Phases[2], Phases[3]);



	/***********************************************************
		This Block Handles the PC next behavior
	***********************************************************/
	wire BGRmux = (WflagReg[2] ~^ WflagReg[1]) & ~WflagReg[3] & WbCntrl[4];

	wire [6:0] NextPC;
	wire [15:0] PCsum;
	fastadder ADD ({9'b0, ProgramCounter}, 16'h0001, 1'b0, PCsum, , ); // changed to fastadder

	wire [6:0] BGRresult;
	assign BGRresult = BGRmux ? Writeback[11:5] : PCsum[6:0];
	
	// THIS PART MAY THROW AN ERROR IN INSTRUCTION CYCLE
	// Possible solution is to forward the relevant
	// RF data to the next stage
	wire [6:0] BSCresult;
	assign BSCresult = WbCntrl[5] ? R1ReadData[6:0] : Writeback[6:0];
	
	assign NextPC = WbCntrl[6] ? BSCresult : BGRresult;
	
	always@(posedge Phases[4])
		if(!Reset)
			PCin <= 7'h00;
		else
			PCin <= NextPC;


endmodule