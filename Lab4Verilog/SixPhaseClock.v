module SixPhaseClock(Phases, inClk, Reset);
	output wire [5:0] Phases;
	reg[2:0] Count;
	input Reset, inClk;
	
	assign Phases[0] = (Count == 3'b000);
	assign Phases[1] = (Count == 3'b100);
	assign Phases[2] = (Count == 3'b110);
	assign Phases[3] = (Count == 3'b111);
	assign Phases[4] = (Count == 3'b011);
	assign Phases[5] = (Count == 3'b001);

	always@(posedge inClk)
		if(!Reset | (Count == 3'b101) | (Count == 3'b010))
			Count <= 3'b000;
		else begin
			Count[0] <= Count[1];
			Count[1] <= Count[2];
			Count[2] <= ~Count[0];
		end
endmodule

// module SixPC_Test();
// 	reg inClk, Reset;
// 	wire [5:0] Phases;

// 	SixPhaseClock dut (Phases, inClk, Reset);

// 	initial begin
// 		$dumpfile("SixPC_Test.vcd");
// 		$dumpvars;
// 	end

// 	initial begin
// 		inClk = 0;
// 		forever #10 inClk <= ~inClk;
// 	end

// 	initial begin
// 		Reset <= 1; @(posedge inClk)
// 		Reset <= 0; @(posedge inClk)
// 		Reset <= 1; @(posedge inClk)
// 		repeat(80) @(posedge inClk);
// 		$stop;
// 	end
// endmodule