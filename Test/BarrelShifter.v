

`timescale 1ns / 1ps
module BarrelShifter(Result, ShiftSel, Operand);
	output wire [15:0] Result;
	input wire [15:0] Operand;
	input wire [1:0] ShiftSel;


	FourMux mux0 (.out(Result[0]), .sel(ShiftSel), .w({3'b0, Operand[0]}));
	FourMux mux1 (.out(Result[1]), .sel(ShiftSel), .w({2'b0, Operand[0], Operand[1]}));
	FourMux mux2 (.out(Result[2]), .sel(ShiftSel), .w({1'b0, Operand[0], Operand[1], Operand[2]}));
	genvar i;
	generate
		for(i = 3; i < 16; i = i + 1)
		begin: muxes
			FourMux MX (.out(Result[i]), .sel(ShiftSel), 
				.w({Operand[i-3], Operand[i-2], Operand[i-1], Operand[i]}));
		end
	endgenerate
endmodule // BarrelShifter

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
