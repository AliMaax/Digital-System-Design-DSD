`timescale 1ns/10ps
module lab9(input logic clk, reset, A,
			output logic [6:0]count);//[7:0]AN, [7:0] Display);
		
	wire Q;
		
	seqDetectMoore D1 (clk, reset, A, Q);
		
	//assign count = 7'b0000000;
		
	always_ff @ (posedge Q)
   	 if (reset == 1 )
        	count <= 7'b0000000;
	 else if  (count == 100)
		count <= 7'b0000000;
   	 else
        	count <= count + 7'b0000001;
		//counter(reset, Q, count);
endmodule

