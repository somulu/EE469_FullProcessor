module StateCounter(OUT, in, clk, reset);
	output wire OUT;
	input wire in, clk, reset;
	
	reg [1:0] ps, ns;
	
	parameter NOTHING = 2'b00;
	parameter ONECLICK = 2'b01;
	parameter HOLD = 2'b10;
	
	always@(*)
		case(ps)
			NOTHING: if (in) ns = ONECLICK;
					else ns = NOTHING;
			
			ONECLICK: ns = HOLD;
			
			HOLD: if(!in) ns = NOTHING;
					else ns = HOLD;
					
			default: ns = 2'bxx;
		endcase // ps

	assign OUT = ~(ps == ONECLICK);

	always@(posedge clk)
		if (!reset)
			ps <= NOTHING;
		else
			ps <= ns;
			
endmodule