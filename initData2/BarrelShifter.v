
`timescale 1ns / 1ps
module BarrelShifter(Result, ShiftSel, Operand);
	output wire [15:0] Result;
	input wire [15:0] Operand;
	input wire [1:0] ShiftSel;


	FourMux mux0 (.out(Result[0]), .sel(ShiftSel), .w({3'b0, Operand[0]}));
	FourMux mux1 (.out(Result[1]), .sel(ShiftSel), .w({2'b0, Operand[0], Operand[1]}));
	FourMux mux2 (.out(Result[2]), .sel(ShiftSel), .w({1'b0, Operand[0], Operand[1], Operand[2]}));
	genvar i;
	generate
		for(i = 3; i < 16; i = i + 1)
		begin: muxes
			FourMux MX (.out(Result[i]), .sel(ShiftSel), 
				.w({Operand[i-3], Operand[i-2], Operand[i-1], Operand[i]}));
		end
	endgenerate
endmodule // BarrelShifter


// module BarrelTester();
// 	reg [15:0] Operand;
// 	reg [1:0] ShiftSel;
// 	wire [15:0] Result;

// 	BarrelShifter dut (Result, ShiftSel, Operand);
// 	integer i, j, k, l;

// 	// GTKWave file = BarrelTester.vcd
// 	initial begin
// 		$dumpfile("BarrelTester.vcd");
// 		$dumpvars;
// 	end	

// 	initial begin
// 		#10;
// 		Operand = 16'hFFFF;
// 		#10;
// 		for (i = 0; i < 4; i = i + 1) begin
// 			ShiftSel = i;
// 			#10;
// 		end
// 		Operand = 16'h8888;
// 		#10;
// 		for (j = 0; j < 4; j = j + 1) begin
// 			ShiftSel = j;
// 			#10;
// 		end
// 		Operand = 16'h7777;
// 		#10;
// 		for (k = 0; k < 4; k = k + 1) begin
// 			ShiftSel = k;
// 			#10;
// 		end
// 		Operand = 16'hBBBB;
// 		#10;
// 		for (l = 0; l < 4; l = l + 1) begin
// 			ShiftSel = l;
// 			#10;
// 		end
// 	end
// endmodule
