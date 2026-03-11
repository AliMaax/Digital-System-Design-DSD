`timescale 1ns/10ps
module lab6_tb;
	reg [3:0] num,
	reg [2:0] sel,
	reg write,reset,
	//wire [7:0] char;
	//wire [3:0]AN;
    //wire [3:0]seg;
	wire [3:0] y;
	wire [7:1]F;
	wire [3:0] q7,q6,q5,q4,q3,q2,q1,q0;
	lab6 sqc(char,AN,num,sel,write,reset);
	initial
		begin
			reset=0;
			write=1;
			num[3]=0; num[2]=0; num[1]=0; num[0]=0;
			sel[1]=0; sel[0]=0;
			(@posedge clk)
			num[3]=0; num[2]=0; num[1]=0; num[0]=1;
			sel[1]=0; sel[0]=1;
			(@posedge clk)
			num[3]=0; num[2]=0; num[1]=1; num[0]=0;
			sel[1]=1; sel[0]=0;
			(@posedge clk)
			
			$stop;
		end
	
endmodule