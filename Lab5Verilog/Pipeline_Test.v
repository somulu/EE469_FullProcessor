`timescale 1ns / 1ns
`include "ThirtyTwoMux.v"
`include "BarrelShifter.v"
`include "Control.v"
`include "D_FF.v"
`include "eightbitfastadder.sv"
`include "Five_32Decoder.v"
`include "FivePhaseClock.v"
`include "fourbitcarrylookaheadadder.sv"
`include "InstxMem.v"
`include "mux2_1.sv"
`include "RegisterFile.v"
`include "RegisterRow.v"
`include "SRAM.v"
`include "StateCounter.v"
`include "fastadder.sv"
`include "alu.sv"
`include "PilelinedCPU.sv"

module Pipeline_Test();
	reg SysCLK, RST, SysRST;

	PilelinedCPU dut (SysCLK, RST, SysRST);

	initial begin
		$dumpfile("Pipeline_Test.vcd");
		$dumpvars();
	end

	initial begin
		SysCLK = 0;
		forever #10 SysCLK <= ~SysCLK;
	end

	initial begin SysRST <= 1; @(posedge SysCLK)
		SysRST <= 0; @(posedge SysCLK)  repeat(5) @(posedge SysCLK);
		SysRST <= 1; @(posedge SysCLK)
		repeat(10) @(posedge SysCLK);

		RST <= 1; @(posedge SysCLK)
		RST <= 0; @(posedge SysCLK) repeat(8) @(posedge SysCLK);
		RST <= 1; @(posedge SysCLK)
		repeat(150) @(posedge SysCLK);
		$stop;
	end
endmodule