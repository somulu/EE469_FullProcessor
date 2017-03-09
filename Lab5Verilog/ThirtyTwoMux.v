/*
	A 32:1 mux with:
		output: out
		inputs:
			sel[4:0] the line selector
			w[31:0] the input lines to the mux
*/

module ThirtyTwoMux(out, sel, w);
	output		out;
	input [4:0]	sel;
	input [31:0]  w;
	wire [1:0] LSB, ands;
	wire		Sel4Bar;

	SixteenMux Zeroto15		(LSB[0], sel[3:0], w[15:0]);
	SixteenMux Sixteento31	(LSB[1], sel[3:0], w[31:16]);

	not n0 (Sel4Bar, sel[4]);

	and and0 (ands[0], Sel4Bar, LSB[0]);
	and and1 (ands[1], sel[4], LSB[1]);

	or result (out, ands[1], ands[0]);
endmodule // ThirtyTwoMux




/*
	This module instantiates 5 4:1 muxes
	to create a 16:1 mux

	Design taken from "Fundamentals of Digital Design" 2nd Ed.
	Chapter 4, Page 192, Figure 4.4

	Verilog Synthesis by Mitchell Orsucci
	Last Modified: 1.15.17
 */

module SixteenMux (out, sel, w);
	output out;
	input  [15:0] w;
	input  [3:0] sel;
	
	// Pool the outputs of the two LSB and the four 4:1
	// Muxes that they come from
	wire	[3:0] LSB;

	FourMux bits0to3	(LSB[0], sel[1:0], w[3:0]);
	FourMux bits7to4	(LSB[1], sel[1:0], w[7:4]);
	FourMux bits11to8	(LSB[2], sel[1:0], w[11:8]);
	FourMux bits15to12	(LSB[3], sel[1:0], w[15:12]);

	FourMux MSB			(out, sel[3:2], LSB);

endmodule // SixteenMux





/*
	A 4:1 multiplexor with input lines: W[3:0]
	select lines: sel[1:0]
	and output: out
*/

module FourMux(out, sel, w);
	output 		 out;
	input  [3:0] w;
	input  [1:0] sel;
	wire   [1:0] selBar;
	wire   [3:0] ands;

	not n0 (selBar[0], sel[0]);
	not n1 (selBar[1], sel[1]);

	and a0 (ands[0], selBar[1], selBar[0], w[0]);   //Case 0
	and a1 (ands[1], selBar[1], sel[0], w[1]); 		//Case 1
	and a2 (ands[2], sel[1], selBar[0], w[2]);		//Case 2
	and a3 (ands[3], sel[1], sel[0], w[3]);			//Case 3

	// The output of this "or" gate collects criteria from
	// The previous "and" gates and connects to the
	// output of the module
	or outputOr (out, ands[3], ands[2], ands[1], ands[0]);

endmodule // FourMux