`timescale 1ns/10ps
module lab9(input logic clk, reset, PB,
			output logic Q);//[7:0]AN, [7:0] Display);
		
	//DeBounce D (clk, reset, PB, [3:0]count1, [3:0]count2);
	//wire Q;
	/*wire A;
	reg d1, d2;
	wire T=1;
	reg q1, q2, q3 , q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14,
	q15, q16, q17,q18,q19,q20,q21,q22,q23,q24,q25;
		
    TFF tff1 (T, clk, q1);
    TFF tff2 (T, q1, q2);
    TFF tff3 (T, q2, q3);
    TFF tff4 (T, q3, q4);
    TFF tff5 (T, q4, q5);
    TFF tff6 (T, q5, q6);
    TFF tff7 (T, q6, q7);
    TFF tff8 (T, q7, q8);
    TFF tff9 (T, q8, q9);
    TFF tff10 (T, q9, q10);
    TFF tff11 (T, q10, q11);
    TFF tff12 (T, q11, q12);
    TFF tff13 (T, q12, q13);
    TFF tff14 (T, q13, q14);
    TFF tff15 (T, q14, q15);
    TFF tff16 (T, q15, q16);
    TFF tff17 (T, q16, q17);
    TFF tff18 (T, q17, q18);
    TFF tff19 (T, q18, q19);
    TFF tff20 (T, q19, q20);
    TFF tff21 (T, q20, q21);
    TFF tff22 (T, q21, q22);
    TFF tff23 (T, q22, q23);
    TFF tff24 (T, q23, q24);
    TFF tff25 (T, q24, q25);
		
	always_ff @ (posedge q25)
	begin
	if (reset)
		d1<=0;
	else
		d1<=PB;
	end


	always_ff @ (posedge q25)
	begin
	if (reset)
		d2<=0;
	else
		d2<=d1;	
	end
	
	assign A = d1&d2;*/
		
	seqDetectMoore D1 (clk, reset, A, Q);
	logic [3:0]count1=0;
	logic [3:0]count2=0;

	
always_comb
begin
	if (count1 == 4'b1010)
	begin
		count1<=0;
		count2<=count2+4'b0001;
	end
	if (count2 == 4'b1010)
	begin
		count1<=0;
		count2<=0;
	end
end
endmodule

