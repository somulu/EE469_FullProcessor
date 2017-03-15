module eightbitfastadder (addend, augend, carryin, sum, carryout);
	input [7:0] addend, augend;
	input carryin;
	output [7:0] sum;
	output carryout;
	
	wire midcarry;
	
	fourbitcarrylookaheadadder firsthalf (addend[3:0], augend[3:0], carryin, sum[3:0], midcarry, );
	fourbitcarrylookaheadadder otherhalf (addend[7:4], augend[7:4], midcarry, sum[7:4], carryout, );
	
endmodule

// module eightbit_tester ();
// 	reg [7:0] addend, augend, sum;
// 	reg carryin, carryout;
	
// 	eightbitfastadder dut (addend, augend, carryin, sum, carryout);
	
// 	initial begin
// 	carryin = 0;
// 	addend = 7; augend = 16;
// 	#150;
// 	addend = 6; augend = 3;
// 	#150;
// 	$stop;
// 	end
	
// endmodule