module hex (data, HEX);
	input [3:0] data;
	output reg [6:0] HEX;
	
	always@(*)
		case (data)
		4'h0: HEX = 7'b1000000;
		4'h1: HEX = 7'b1111001;
		4'h2: HEX = 7'b0100100;
		4'h3: HEX = 7'b0110000;
		4'h4: HEX = 7'b0011001;
		4'h5: HEX = 7'b0010010;
		4'h6: HEX = 7'b0000010;
		4'h7: HEX = 7'b1111000;
		4'h8: HEX = 7'b0000000;
		4'h9: HEX = 7'b0010000;
		4'hA: HEX = 7'b0001000; //a
		4'hB: HEX = 7'b0000011; //b
		4'hC: HEX = 7'b0100111; //c
		4'hD: HEX = 7'b0100001; //d
		4'hE: HEX = 7'b0000110; //e
		4'hF: HEX = 7'b0001110; //f
		default: HEX = 7'b1111111;
	endcase
endmodule
