`timescale 1ns/10ps
module lab9(input logic clk, reset, A,
			output logic Q);//[7:0]AN, [7:0] Display);
		reg [6:0]count;
		//reg Q;
		
		seqDetectMoore(clk, reset, A, Q);
		
		//counter(reset, Q, count);
endmodule
