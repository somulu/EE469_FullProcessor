
/*
	The Top-Level module that describes the register file
	
	The Register File is 32x32.
	RegisterRow[31] is set to always output 32'h00000000
	Inputs:
		Reg 1 Read Select R1RS [4:0]
		Reg 2 Read Select R2RS [4:0]
		Write Reg Select  WRS  [4:0]
		Write Data		  WD   [31:0]
		Write Enable	  SWE
		Reset 			  RST

	Outputs:
		Reg 1 Read Data	  R1ReadData [31:0]
		Reg 2 Read Data   R2ReadData [31:0]

	Author: Mitchell Orsucci
	Last Modified: 1.15.17

*/


module RegisterFile(R1ReadData, R2ReadData, R1RS, R2RS, WRS, WD, SWE, RST, Phi5);

	output 	[31:0] R1ReadData, R2ReadData;
	input 	[31:0] WD;
	input   [4:0]  R1RS, R2RS, WRS;
	input 		   SWE, RST, Phi5;
	wire 	[31:0] decodeSelect, enableBus;
	wire 	[31:0] DFFdata[31:0];    

	// uses WRS to select which register to be written to
	// output is whichever line is turned on by the decoder
	Five_32Decoder WriteSelect (.out(decodeSelect), .select(WRS));
	
	
	/* This is where DFFs go */
	// using module RegisterRow, which describes one row of registers,
	// we now create 32 rows of these registers
	// This generate statement is set to 31 rows, because the 32nd register
	// will be hardwired to output 0 always
	genvar i, j, k;
	generate
		for (i = 0; i < 31; i = i+1)
		begin : Register
			RegisterRow  RR (.rowQ(DFFdata[i]), .clk(Phi5), .reset(RST), .data(WD), .rowSelect(decodeSelect[i]), .enable(SWE));
		end // Register
	endgenerate

	// Special case for Reg 32. Always outputs 0
	RegisterRow Row32 (.rowQ(DFFdata[31][31:0]), .clk(1'b0), .reset(RST), .data(WD), .rowSelect(decodeSelect[31]), .enable(SWE));


	/* This is where the Multiplexors go 
	 Each mux takes one bit from each reg in the column */
	// 64 32:1 Muxes total
	// 32 for R1ReadData
	// 32 for R2ReadData
	generate
		for (j = 0; j < 32; j = j + 1)
		begin: ReadMux1
			ThirtyTwoMux bitRS1 (.out(R1ReadData[j]), .sel(R1RS), .w({DFFdata[31][j], DFFdata[30][j], DFFdata[29][j], DFFdata[28][j], DFFdata[27][j],
				 DFFdata[26][j], DFFdata[25][j], DFFdata[24][j], DFFdata[23][j], DFFdata[22][j],
				 DFFdata[21][j], DFFdata[20][j], DFFdata[19][j], DFFdata[18][j], DFFdata[17][j],
				 DFFdata[16][j], DFFdata[15][j], DFFdata[14][j], DFFdata[13][j], DFFdata[12][j], 
				 DFFdata[11][j], DFFdata[10][j], DFFdata[9][j], DFFdata[8][j], DFFdata[7][j], 
				 DFFdata[6][j], DFFdata[5][j], DFFdata[4][j], DFFdata[3][j], DFFdata[2][j], 
				 DFFdata[1][j], DFFdata[0][j]}));
		end
	endgenerate

	generate
		for (k = 0; k < 32; k = k + 1)
		begin: ReadMux2
			ThirtyTwoMux bitRS2 (.out(R2ReadData[k]), .sel(R2RS), .w(
				{DFFdata[31][k], DFFdata[30][k], DFFdata[29][k], DFFdata[28][k], DFFdata[27][k],
				 DFFdata[26][k], DFFdata[25][k], DFFdata[24][k], DFFdata[23][k], DFFdata[22][k],
				 DFFdata[21][k], DFFdata[20][k], DFFdata[19][k], DFFdata[18][k], DFFdata[17][k],
				 DFFdata[16][k], DFFdata[15][k], DFFdata[14][k], DFFdata[13][k], DFFdata[12][k], 
				 DFFdata[11][k], DFFdata[10][k], DFFdata[9][k], DFFdata[8][k], DFFdata[7][k], 
				 DFFdata[6][k], DFFdata[5][k], DFFdata[4][k], DFFdata[3][k], DFFdata[2][k], 
				 DFFdata[1][k], DFFdata[0][k]}));
		end
	endgenerate

endmodule // RegisterFile





