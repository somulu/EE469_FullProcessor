


/*
	A module that emulates a 16 by 2048 SRAM with an 11 bit address port
	a 32 bit data port and control signals read/'write, output enable and
	clock. It can hold 1024 pieces of 32 bit data and read and write in 
	a clock cycle.
	
	to write to the SRAM, input the address and the data, then lower 
	RNW before the posedge of the clock. Hold RNW down until after the 
	negedge of the clock cycle, and then raise it to write to the SRAM
	
	to read from the SRAM, input the address you want to read before the
	posedge of the clock and the data will be returned on the posedge of
	the next clock.
*/

module SRAM(DataBus, AdxBus, OE, RNW, Clock1, Clock2, Clock3, RST);
	inout wire [31:0] DataBus; 
	input wire [10:0] AdxBus, RST;
	input wire OE, RNW, Clock1, Clock2, Clock3;

	// the structures that we need for the module
	reg [15:0] Memory [2047:0];
	reg [31:0] MDR;
	reg [9:0] MAR;
	
	// This code controls the Memory Address Register
	always @(posedge Clock1) // Clock 1
		MAR <= AdxBus[9:0];

	// defines the dataflow in the MDR
	// when RNW is low, data is taken from the bus into the MDR,
	// when RNW is high, data is taken from the memory to the bus.
	always @(posedge Clock2)
		if (RNW)
			MDR <= {Memory[{1'b1, MAR}], Memory[{1'b0, MAR}]};
		else
			MDR <= DataBus;

	// The DataBus is low impedance when OE is high
	assign DataBus = !OE ? MDR : 32'bz;

	// On posedge RNW, write the contents of the MDR
	// To the relevant locations in memory
	always @(posedge Clock3) begin
		if(!RST) begin
			Memory[1] <= 16'h0008;
			Memory[2] <= 16'h0003;
			Memory[3] <= 16'h0003;
			Memory[4] <= 16'h0005;
			Memory[5] <= 16'h5a5a;
			Memory[6] <= 16'h6767;
			Memory[7] <= 16'h003c;
			Memory[8] <= 16'h00ff;
			Memory[1025] <= 16'h0000;
			Memory[1026] <= 16'h0000;
			Memory[1027] <= 16'h0000;
			Memory[1028] <= 16'h0000;
			Memory[1029] <= 16'h0000;
			Memory[1030] <= 16'h0000;
			Memory[1031] <= 16'h0000;
			Memory[1032] <= 16'h0000;
		end else if (!RNW) begin
			Memory[{1'b1, MAR}] <= MDR[31:16];
			Memory[{1'b0, MAR}] <= MDR[15:0];
		end
	end
	
endmodule
