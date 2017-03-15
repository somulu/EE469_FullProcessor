module FivePhaseClock(Phases, RST, CLK);
	input RST, CLK;
	output wire [4:0] Phases;

	reg [2:0] ps;
	wire [2:0] ns;

	assign ns[2] = ~(ps[1] & ps[0]);
	assign ns[1] = ps[2];
	assign ns[0] = ps[2] & ps[1];	

	assign Phases[0] = (ps == 3'b000);
	assign Phases[1] = (ps == 3'b100);
	assign Phases[2] = (ps == 3'b110);
	assign Phases[3] = (ps == 3'b111);
	assign Phases[4] = (ps == 3'b011);

	always@(posedge CLK)
		if(!RST)
			ps <= 3'b000;
		else
			ps <= ns;
endmodule