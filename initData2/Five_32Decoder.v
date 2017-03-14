/*
	This is a 5:32 decoder.
	Only one output line can be true at a time
	based on the 5-bit select conditions

	This decoder is made up of:
		*One 2:4 no enable decoder
		covering the two MSB of the five bit input

		*Four 3:8 enable decoders
		which cover the three LSB of the five bit input
*/

module Five_32Decoder(out, select);
	// Only one of these output lines can be true at a time
	output [31:0] out;
	input  [4:0]  select;

	wire [3:0] LSBselect;

	// This module instantiation handles the logic for
	// The two MSBs of our five-bit input
	Two_FourDecoderNoEn MSB (.out(LSBselect), .sel(select[4:3]));


	// These module instantiations handle the logic four our three LSB
	// With the enable controlled by the earlier 2:4 decoder call
	Three_EightEnableDecoder ZeroThrough7 (.out(out[7:0]), .sel(select[2:0]), .enable(LSBselect[0]));
	Three_EightEnableDecoder EightThrough15 (.out(out[15:8]), .sel(select[2:0]), .enable(LSBselect[1]));
	Three_EightEnableDecoder SixteenThrough23 (.out(out[23:16]), .sel(select[2:0]), .enable(LSBselect[2]));
	Three_EightEnableDecoder TwentyFourThrough31 (.out(out[31:24]), .sel(select[2:0]), .enable(LSBselect[3]));

endmodule // Five_32Decoder


/*
	A 3:8 Enable Decoder using 2:4 Enable Decoders
	Design taken from "Fundamentals of Digital Design"
	2nd edition by Brown and Vranesic
	Chapter 4, page 204, Figure 4.15

	Synthesized into verilog by Mitchell Orsucci
	Last Modified: 1.15.17
*/

module Three_EightEnableDecoder(out, sel, enable);
	output [7:0] out;
	input  [2:0] sel;
	input		 enable;
	wire S2Bar, LSBenable, MSBenable;

	not n2 (S2Bar, sel[2]);

	// This enable goes high when Sel2 is low and enable is high
	and a0 (LSBenable, S2Bar, enable);
	
	// This enable goes high when sel2 and enable are high
	and a1 (MSBenable, sel[2], enable);

	// These two 2:4 decoders cover the four different
	// possibilities for the Least sig. bits and Most sig. bits
	// The enable controls are fed by logic from the enable to
	// this upper module and sel[2]
	Two_FourEnableDecoder LS4 (.out(out[3:0]), .sel(sel[1:0]), .enable(LSBenable));
	Two_FourEnableDecoder MS4 (.out(out[7:4]), .sel(sel[1:0]), .enable(MSBenable));

endmodule // Three_EightEnableDecoder



/*
	This is a 2:4 Decoder with no enable
*/

module Two_FourDecoderNoEn(out, sel);
	output	[3:0] out;
	input	[1:0] sel;
	wire S1Bar, S0Bar;

	not n0 (S0Bar, sel[0]);
	not n1 (S1Bar, sel[1]);

	// These and gates are exclusive to each other
	// only one can evaluate to "true" at a time
	// driving the output line
	and and0 (out[0], S1Bar, S0Bar);
	and and1 (out[1], S1Bar, sel[0]);
	and and2 (out[2], sel[1], S0Bar);
	and and3 (out[3], sel[1], sel[0]);

endmodule // Two_FourDecoderNoEn



/* 
	A 2:4 Decoder with enable
*/

module Two_FourEnableDecoder(out, sel, enable);
	output [3:0] out;
	input  [1:0] sel;
	input 		enable;
	wire S1Bar, S0Bar;

	not n0 (S0Bar, sel[0]);
	not n1 (S1Bar, sel[1]);

	// These and gates are exclusive to each other
	// only one can evaluate to "true" at a time
	// driving the output line
	// Must have "enable" high to be active
	and a0 (out[0], S1Bar, S0Bar, enable);
	and a1 (out[1], S1Bar, sel[0], enable);
	and a2 (out[2], sel[1], S0Bar, enable);
	and a3 (out[3], sel[1], sel[0], enable);

endmodule // Two_FourEnableDecoder