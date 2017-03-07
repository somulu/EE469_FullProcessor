module DE1SingleClock(LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, SW, KEY, CLOCK_50);
	input CLOCK_50;
	input [3:0] KEY;
	input [9:0] SW;
	output wire [9:0] LEDR;
	output wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	reg[24:0] Count;
	wire [2:0] ALUop;
	wire SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUShift, PHReset, SysReset;
	wire [10:0] InstxOp;
	wire [5:0] Phases;
	wire OUT;
	wire [6:0] ProgramCounter;


	always@(posedge CLOCK_50)
	 	if(!PHReset)
	 		Count <= 25'b0;
	 	else
	 		Count <= Count + 1'b1;

	assign PHReset = KEY[3];
	assign SysReset = OUT;

	StateCounter SC (OUT, ~KEY[2], Phases[0], PHReset);
 	SixPhaseClock SPC (Phases, Count[22], PHReset);
//	SixPhaseClock SPC (Phases, CLOCK_50, PHReset);
	Control CTRL (ALUop, SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUShift, Phases[1], InstxOp, SysReset);
	Datapath DP (ProgramCounter, ALUop, SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUShift, InstxOp, Phases, SysReset);

	hex 	h0 (.data(ProgramCounter[3:0]), .HEX(HEX0));
	hex     h1 (.data({1'b0, ProgramCounter[6:4]}), .HEX(HEX1));
	QuadHexDriver QHD (HEX5, HEX4, HEX3, HEX2, InstxOp);
	LEDcontrol	LEDc  (LEDR, Phases);


endmodule

module QuadHexDriver(HEXLL, HEXL, HEXR, HEXRR, bits);
	output reg [6:0] HEXLL, HEXL, HEXR, HEXRR;
	input [10:0] bits;

	parameter	ADD = 11'h458;
	parameter	SUB = 11'h658;
	parameter	AND = 11'h450;
	parameter	ORR = 11'h550;
	parameter	EOR = 11'h650;
	parameter	LSL = 11'h69B;
	parameter	LDURSW = 11'h5C4;
	parameter	STURW = 11'h5C0;
	parameter	B = 11'h0A0;
	parameter	BR = 11'h6B0;
	parameter	BGT = 11'h2A0;
	parameter	ADDI = 11'h488;
	parameter	NOP = 11'h000;

	parameter S = 7'b0010010;
	parameter U = 7'b1000001;
	parameter bee = 7'b0000011; 
	parameter A = 7'b0001000;
	parameter i = 7'b1111001;
	parameter d = 7'b0100001;
	parameter n = 7'b1001000;
	parameter O = 7'b1000000;
	parameter r = 7'b1001110;
	parameter E = 7'b0000110;
	parameter L = 7'b1000111;
	parameter t = 7'b0000111;
	parameter g = 7'b0010000;
	parameter p = 7'b0001100;
	parameter blank = 7'b1111111;
	
	always@(*)	
		case(bits)
			ADD:	 begin HEXLL = A;
							HEXL = d;
							HEXR = d;
							HEXRR = blank; end
			SUB:	 begin HEXLL = S;
							HEXL = U;
							HEXR = bee;
							HEXRR = blank; end
			AND:	 begin HEXLL = A;
							HEXL = n;
							HEXR = d;
							HEXRR = blank; end
			ORR:	 begin HEXLL = O;
							HEXL = r;
							HEXR = r;
							HEXRR = blank; end
			EOR:	 begin HEXLL = E;
							HEXL = O;
							HEXR = r;
							HEXRR = blank; end
			LSL:	 begin HEXLL = L;
							HEXL = S;
							HEXR = L;
							HEXRR = blank; end
			LDURSW: begin HEXLL = L;
							HEXL = d;
							HEXR = U;
							HEXRR = d; end
			STURW:  begin HEXLL = S;
							HEXL = t;
							HEXR = U;
							HEXRR = r; end
			B:		  begin HEXLL = bee;
							HEXL = blank;
							HEXR = blank;
							HEXRR = blank; end
			BR:		begin HEXLL = bee;
							HEXL = r;
							HEXR = blank;
							HEXRR = blank; end
			BGT:	 begin HEXLL = bee;
							HEXL = 7'b1110111;
							HEXR = g;
							HEXRR = t; end
			ADDI:	 begin HEXLL = A;
							HEXL = d;
							HEXR = d;
							HEXRR = i; end
			NOP:	 begin HEXLL = n;
							HEXL = O;
							HEXR = p;
							HEXRR = blank; end
			default: begin HEXLL = 7'b1110111;
							HEXL = 7'b1110111;
							HEXR = 7'b1110111;
							HEXRR = 7'b1110111; end
		endcase // bits
endmodule

module LEDcontrol(leds, Phases);
	input [5:0] Phases;
	output wire [9:0] leds;

	assign leds[0] = Phases[5];
	assign leds[1] = Phases[4] | Phases[5];
	assign leds[2] = Phases[3] | Phases[4] | Phases[5];
	assign leds[3] = Phases[2] | Phases[3] | Phases[4] | Phases[5];
	assign leds[4] = Phases[1] | Phases[2] | Phases[3] | Phases[4] | Phases[5];
	assign leds[5] = Phases[1] | Phases[2] | Phases[3] | Phases[4] | Phases[5];
	assign leds[6] = Phases[2] | Phases[3] | Phases[4] | Phases[5];
	assign leds[7] = Phases[3] | Phases[4] | Phases[5];
	assign leds[8] = Phases[4] | Phases[5];
	assign leds[9] = Phases[5];
endmodule