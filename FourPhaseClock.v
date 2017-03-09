`timescale 1ns / 1ps
module FourPhaseClock(inClock, Phi1, Phi2, Phi3, Phi4, Reset);
	input wire inClock, Reset;
	output wire Phi1, Phi2, Phi3, Phi4;
	wire [1:0] Q, QBar;

	D_FF BIT0 (Q[0], QBar[0], QBar[1], inClock, Reset);
	D_FF BIT1 (Q[1], QBar[1], Q[0], inClock, Reset);

	assign Phi1 = ~Q[0] & ~Q[1];
	assign Phi2 = Q[0] & ~Q[1];
	assign Phi3 = Q[0] & Q[1];
	assign Phi4 = ~Q[0] & Q[1];
endmodule
/*
module FPCTester();
	reg inClock, Reset;
	wire Phi1, Phi2, Phi3, Phi4;


	FourPhaseClock dut (inClock, Phi1, Phi2, Phi3, Phi4, Reset);


	initial begin
		inClock <= 0;
		forever #25 inClock <= ~inClock;
	end

	// GTKWave file = FPCTester.vcd
	initial begin
		$dumpfile("FPCTester.vcd");
		$dumpvars;
	end	

	initial begin
		Reset <= 1;
		@(posedge inClock)
		Reset <= 0;
		@(posedge inClock)
		Reset <= 1;
		repeat(20) @(posedge inClock);
		$stop;
	end
	endmodule
*/