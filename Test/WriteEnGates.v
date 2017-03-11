/*
	This module connects the write enable signal
	with the output of the Decoder to highlight
	which register file row will receive new data

	Set in new module to save space because
	of 32 and gates
*/

module WriteEnGates (Enable, writeEnable, decoderOut);
	output [31:0] Enable;
	input [31:0] decoderOut;
	input writeEnable;
	genvar i;

	// Each register row will only be activated
	// when writeEnable is high and the line is activated
	// by the 5:32 decoder
	generate
		for (i = 0; i < 32; i = i+1) 
		begin: bit
			and AndG (Enable[i], writeEnable, decoderOut[i]);
		end
	endgenerate
endmodule // WriteEnGates