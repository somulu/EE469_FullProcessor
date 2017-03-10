/* This handles the execute portion of our pipeline */


module stage2(wBack, dCode, Phases, RST);
	/* formatting for Decode */
	/*	
		R-TYPE
		[15:0] =	R1Data
		[31:16] =	R2Data or SHAMT
		[36:32] = 	WRS

		D-TYPE
		
	*/
	input [73:0] dCode;

endmodule