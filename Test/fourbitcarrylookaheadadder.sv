/*
	Designed by Walker Kasinadhuni
	EE 469 Peckol
	Last modified 2-9-2017
	
	Four bit carry lookahead adder for use in the 16 bit fast adder
	adds two four bit inputs with a carry in bit. produces a four bit sum and 
	one bit of carry out. 
	
	Should finish an addition in four gate delays or something like that
	either way it's better than the 16 or something from the ripple carry version
*/
module fourbitcarrylookaheadadder(addend, augend, carryin, sum, carryout, carryoutless);
	input wire [3:0] addend, augend;
	input wire carryin;
	output wire [3:0] sum;
	output wire carryout, carryoutless; // for testing overflow.
	
	// declare propigate and generate wires and the wires for the carry bits
	wire [3:0] prop, gen;
	wire [4:0] carrybits;
	
	// carry in is assigned to carrybits[0] for no real reason other than style.
	assign carrybits[0] = carryin;
	
	// the comb logic that defines the carry look ahead structure.
	assign carrybits[4] = gen[3] + prop[3]*gen[2] + prop[3]*prop[2]*gen[1] + prop[3]*prop[2]*prop[1]*gen[0] + prop[3]*prop[2]*prop[1]*prop[0]*carryin;
	assign carrybits[3] = gen[2] + prop[2]*gen[1] + prop[2]*prop[1]*gen[0] + prop[2]*prop[1]*prop[0]*carryin;
	assign carrybits[2] = gen[1] + prop[1]*gen[0] + prop[1]*prop[0]*carryin;
	assign carrybits[1] = gen[0] + prop[0]*carryin;
	
	// the comb logic that defines the output of the sum bits and the state of the
	// propigate and generate bits.
	genvar i;
	generate
		for(i = 0; i < 4; i = i + 1) 
		begin : wires
			assign sum[i] = addend[i] ^ augend[i] ^ carrybits[i];
			assign prop[i] = addend[i] ^ augend[i];
			assign gen[i] = addend[i] * augend[i];
		end
	endgenerate
	
	// carryout is equal to the fourth carry bit.
	assign carryout = carrybits[4];
	assign carryoutless = carrybits[3]; // for testing overflow.
	
endmodule

