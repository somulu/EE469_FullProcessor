module Control (ALUop, SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUShift, Clock, InstxOp, Reset);
	output reg SWE, OE, RNW, R2LOC, WDmux, PCC, BSC, BGR, ALUShift;
	output reg [2:0] ALUop;
	input Clock, Reset;
	input [10:0] InstxOp;

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

	always@(posedge Clock or negedge Reset)
		if(!Reset) begin 	// Initialize all signals to zeros
			ALUop	<= 3'b000;
			SWE		<= 1'b0;
			OE		<= 1'b0;
			RNW		<= 1'b0;
			R2LOC	<= 1'b0;
			WDmux	<= 1'b0;
			PCC		<= 1'b0;
			BSC		<= 1'b0;
			BGR		<= 1'b0;
			ALUShift<= 1'b0;
		end else if ((InstxOp == ADD) | (InstxOp == SUB) | // R type instx
					 (InstxOp == AND) | (InstxOp == ORR) | (InstxOp == EOR) |
					 (InstxOp == LSL)) begin
			SWE		<= 1'b1;
			OE		<= 1'b0;
			RNW		<= 1'b1;
			R2LOC	<= 1'b0;
			WDmux	<= 1'b0;
			PCC		<= 1'b0;
			BSC		<= 1'b1;
			BGR		<= 1'b0;
			if (InstxOp == ADD) begin
				ALUop <= 3'b001;
				ALUShift<= 1'b0;
			end else if (InstxOp == SUB) begin
				ALUop <= 3'b010;
				ALUShift<= 1'b0;
			end else if (InstxOp == AND) begin
				ALUop <= 3'b011;
				ALUShift<= 1'b0;
			end else if (InstxOp == ORR) begin
				ALUop <= 3'b100;
				ALUShift<= 1'b0;
			end else if (InstxOp == EOR) begin
				ALUop <= 3'b101;
				ALUShift<= 1'b0;
			end else if (InstxOp == LSL) begin
				ALUop <= 3'b110;
				ALUShift<= 1'b1; // This is the only case where we use the ALU shift control
			end else begin
				ALUop <= 3'b000;
				ALUShift <= 1'b0;
			end
		end else if (InstxOp == LDURSW) begin // Load from SRAM to regfile
			ALUop	<= 3'b000;
			SWE		<= 1'b1;
			OE		<= 1'b0;
			RNW		<= 1'b1;
			R2LOC	<= 1'b0;
			WDmux	<= 1'b1;
			PCC		<= 1'b0;
			BSC		<= 1'b1;
			BGR		<= 1'b0;
			ALUShift<= 1'b0;
		end else if (InstxOp == STURW) begin // Store from regfile to SRAM
			ALUop	<= 3'b000;
			SWE		<= 1'b0;
			OE		<= 1'b1;
			RNW		<= 1'b0;
			R2LOC	<= 1'b1;
			WDmux	<= 1'b0;
			PCC		<= 1'b0;
			BSC		<= 1'b1;
			BGR		<= 1'b0;
			ALUShift<= 1'b0;
		end else if (InstxOp == B) begin // Branch Type
			ALUop	<= 3'b000;
			SWE		<= 1'b0;
			OE		<= 1'b0;
			RNW		<= 1'b1;
			R2LOC	<= 1'b0;
			WDmux	<= 1'b0;
			PCC		<= 1'b1;
			BSC		<= 1'b0;
			BGR		<= 1'b0;
			ALUShift<= 1'b0;
		end else if (InstxOp == BR) begin // Branch from Register
			ALUop	<= 3'b000;
			SWE		<= 1'b0;
			OE		<= 1'b0;
			RNW		<= 1'b1;
			R2LOC	<= 1'b0;
			WDmux	<= 1'b0;
			PCC		<= 1'b1;
			BSC		<= 1'b1;
			BGR		<= 1'b0;
			ALUShift<= 1'b0;
		end else if (InstxOp == BGT) begin // Branch Greater Than
			ALUop	<= 3'b000;
			SWE		<= 1'b0;
			OE		<= 1'b0;
			RNW		<= 1'b1;
			R2LOC	<= 1'b1;
			WDmux	<= 1'b0;
			PCC		<= 1'b0;
			BSC		<= 1'b0;
			BGR		<= 1'b1;
			ALUShift<= 1'b0;	
		end else if (InstxOp == ADDI) begin // Add Immediate
			ALUop	<= 3'b001;
			SWE		<= 1'b1;
			OE		<= 1'b0;
			RNW		<= 1'b1;
			R2LOC	<= 1'b0;
			WDmux	<= 1'b0;
			PCC		<= 1'b0;
			BSC		<= 1'b1;
			BGR		<= 1'b0;
			ALUShift<= 1'b1;
		end else if (InstxOp == NOP) begin // NO OP
			ALUop	<= 3'b000;
			SWE		<= 1'b0;
			OE		<= 1'b0;
			RNW		<= 1'b1;
			R2LOC	<= 1'b0;
			WDmux	<= 1'b0;
			PCC		<= 1'b0;
			BSC		<= 1'b1;
			BGR		<= 1'b0;
			ALUShift<= 1'b1;
		end
endmodule