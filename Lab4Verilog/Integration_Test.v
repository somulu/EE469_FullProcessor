`include "alu.sv"
`include "BarrelShifter.v"
`include "Control.v"
`include "D_FF.v"
`include "Datapath.sv"
`include "DE1SingleClock.v"
`include "eightbitfastadder.sv"
`include "fastadder.sv"
`include "Five_32Decoder.v"
`include "fourbitcarrylookaheadadder.sv"
`include "InstxMem.v"
`include "RegisterFile.v"
`include "RegisterRow.v"
`include "SixPhaseClock.v"
`include "SRAM.v"
`include "ThirtyTwoMux.v"
`include "WriteEnGates.v"
`include "mux2_1.sv"
`include "StateCounter.v"
`include "hex.v"
`timescale 1ns / 1ns

module Integration_Test();
	reg CLOCK_50;
	reg [3:0] KEY;
	reg [9:0] SW;
	wire [9:0] LEDR;
	wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

	DE1SingleClock dut (LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, SW, KEY, CLOCK_50);
	
	initial begin
		$dumpfile("Integration_Test.vcd");
		$dumpvars;
	end

	initial begin
		CLOCK_50 = 0;
		forever #10 CLOCK_50 <= ~CLOCK_50;
	end

	initial begin
		KEY <= 4'hF; @(posedge CLOCK_50)
		#200 KEY <= 4'h7; @(posedge CLOCK_50)
		#200 KEY <= 4'hF; @(posedge CLOCK_50)
		#200 KEY <= 4'hB; @(posedge CLOCK_50)
		#200 KEY <= 4'hF; @(posedge CLOCK_50)

		repeat(500) @(posedge CLOCK_50);


	$stop;
	end
endmodule
