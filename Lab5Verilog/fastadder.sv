


/*
	Designed by Walker Kasinadhuni
	EE 469 Peckol
	Last Modified 2-9-2017

	The fast adder module. Uses four instances of the four bit carry look ahead
	adder to add two 16 bit inputs and a carry in bit and produces a 16 bit 
	sum and and a carry out bit.
	
	even though it uses a ripple structure, it should still be fast enough to do
	addition in a clock cycle.
*/
module fastadder (addend, augend, carryin, sum, carryout, overflow);
	input wire [15:0] addend, augend;
	input wire carryin;
	output wire [15:0] sum;
	output wire carryout, overflow;
	
	// ties the internal carrybits together.
	wire midcarry [2:0];
	
	wire carryoutless;
	
	fourbitcarrylookaheadadder adder1 (addend[3:0], 	augend[3:0], 	carryin, 		sum[3:0], 	midcarry[0], );
	fourbitcarrylookaheadadder adder2 (addend[7:4], 	augend[7:4], 	midcarry[0], 	sum[7:4], 	midcarry[1], );
	fourbitcarrylookaheadadder adder3 (addend[11:8], 	augend[11:8], 	midcarry[1], 	sum[11:8], 	midcarry[2], );
	fourbitcarrylookaheadadder adder4 (addend[15:12], 	augend[15:12], midcarry[2], 	sum[15:12], carryout, carryoutless);
	
	assign overflow = carryout ^ carryoutless;
	
endmodule



//	tests the fast adder with a few simple test cases to see if it is wired up correctly.
//
// module fastadder_tester();
// 	reg [15:0] addend, augend, sum;
// 	reg carryin, carryout, overflow;
	
// 	fastadder dut (addend, augend, carryin, sum, carryout, overflow);
	
// 	initial begin
// 		carryin = 0;
// 		addend = 100; augend = 100;
// 		#150;
// 		addend = 65535; augend = 10;
// 		#150;
// 		addend = 32767; augend = 32767;
// 		#150;
// 		addend = -1; augend = -2;
// 		#150;
// 		addend = -32768; augend = -4;
// 		#150;
		
		
// 		$stop;
// 	end
	
// endmodule

		