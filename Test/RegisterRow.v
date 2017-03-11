/*
	This module instantiates a register of
	32 D flop flops that all share the same clock signal
	and have respective D inputs from a 32 bit bus
	The output of this module is a 32 bit bus
	which is respective of the 32 Q signals of each register in the row
*/

module RegisterRow(rowQ, clk, reset, data, rowSelect, enable);
	output [31:0]	rowQ;
	input  [31:0]	data;
	input 			clk, reset, rowSelect, enable;
	wire [31:0] rowData;
	
	genvar i, j;
	
	generate
		for (j = 0; j < 32; j = j+1)
		begin: Mux
			mux2_1 m2 (.out(rowData[j]), .i0(rowQ[j]), .i1(data[j]), .sel(enable & rowSelect));
		end // Column
	endgenerate
	
	generate
		for (i = 0; i < 32; i = i+1)
		begin: Column
			D_FF flipflop(.Q(rowQ[i]), .Qbar(), .D(rowData[i]), .clk(clk), .rst(reset));
		end // Column
	endgenerate
	
endmodule // RegisterRow

