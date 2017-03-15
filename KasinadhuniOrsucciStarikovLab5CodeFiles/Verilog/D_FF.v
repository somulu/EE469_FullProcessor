/* This module is a D Flip Flop with two outputs,
	Q and Qbar
	This module has an active low reset
	*/
		


	module D_FF(Q, Qbar, D, clk, rst);
		input D, clk, rst;
		output Q, Qbar;
		reg Q;

		not n1 (Qbar, Q);
			always @(negedge rst or posedge clk)
				begin
					if (!rst)
						Q <= 0;
					else
						Q <= D;
				end
	endmodule
