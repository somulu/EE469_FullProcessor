`timescale 1ns / 1ns


/* the InstxMemory is specified on it's own.
	It takes in an adx from the Program Counter
	and outputs 32 bits to the Instruction Decoder
	*/

//`include "SampleData.hex"

module InstxMem (Instruction, ProgramCounter, PCin, Clock1, Clock2, Reset);
	output reg [31:0] Instruction;
	input [6:0] PCin;
	input Clock1, Clock2, Reset;

	// Declaration of InstxMemory array
	// Memory is 512x8, but Instructions are 32 bit
	reg [31:0] IM [127:0];

	// MAR and MDR
	output reg [6:0] ProgramCounter;

	always @(posedge Clock1 or negedge Reset) begin
		if(!Reset)
			ProgramCounter <= 7'h00;
		else
			ProgramCounter <= PCin;
	end

	always @(posedge Clock2) begin
		Instruction[31:0] <= IM[ProgramCounter];
	end

	//$readmemh(file_name, input_memory, first_index, last_index);
	initial begin
		$readmemh("machine_init.list", IM);
	end

endmodule
