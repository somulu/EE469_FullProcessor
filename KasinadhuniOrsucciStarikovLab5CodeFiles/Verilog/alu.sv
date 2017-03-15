


module alu (busA, busB, control, busOut, flags);
    input wire [15:0] busA, busB;
    input wire [2:0] control;
    output reg [15:0] busOut;
    output wire [3:0] flags;
     
    reg v, c; //Z = zero, V = overflow, C = carryout, N = negative
    wire z, n;
    assign flags = {z, n, v, c};

    assign z = (busOut == 0);
    assign n = busOut[15];
	 
	 // builds a fast adder for adding and subtracting.
	 reg [15:0] addend, augend;
	 wire [15:0] sum;
	 wire carryout, overflow;
	 reg carryin;
	 fastadder adder (addend, augend, carryin, sum, carryout, overflow);
	 
	 // builds a barrel shifter the least two significant bits of busb are the shift ammount.
	 wire [15:0] result;
	 reg [15:0] operand;
	 reg [1:0] shiftsel;
	 BarrelShifter shifter (result, shiftsel, operand);
	 
    always @*
        case (control)
            3'b001: begin
					addend = busA;
					augend = busB;
					busOut = sum;
					carryin = 0;
					c = carryout;
					v = overflow;
				end
            3'b010: begin
					// inverts augedn and adds 1 to get negative two's complement version of number.
					addend = busA;
					augend = ~busB;
					busOut = sum;
					carryin = 1;
					c = carryout;
					v = overflow;
				end
            3'b011: busOut = busA & busB;
            3'b100: busOut = busA | busB;
            3'b101: busOut = busA ^ busB;
            3'b110: begin
					busOut = result;
					operand = busA;
					shiftsel = busB[1:0];
				end
            default: busOut = busOut;
        endcase
		  
endmodule

// module alu_tester ();
// 	reg [15:0] busA, busB, busOut;
// 	reg [2:0] control;
// 	reg [3:0] flags;
	
// 	alu dut (busA, busB, control, busOut, flags);
	
// 	initial begin
// 		control = 1;
// 		busA = 3; busB = 18;
// 		#150;
// 		busA = 32767; busB = 1;
// 		#150;
// 		busA = -1; busB = 32767;
// 		#150;
// 		control = 2;
// 		busA = 400; busB = 70;
// 		#150;
// 		control = 3;
// 		busA = -1; busB = 255;
// 		#150;
// 		control = 4;
// 		#150;
// 		control = 5;
// 		#150;
// 		control = 6;
// 		busA = 255; busB = 3;
// 		#150;
		
// 	$stop;
// 	end
	
// endmodule
