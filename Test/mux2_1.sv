module mux2_1(out,i0, i1, sel);
	output out;
	input wire i0, i1, sel;
	
	assign out = (i1 & sel) | (i0 & ~sel);
endmodule

