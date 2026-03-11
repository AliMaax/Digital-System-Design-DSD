`timescale 1ns/10ps
module lab9_tb;
	reg clk;
	reg	reset;
	reg A;
	
	//wire Q;
	//wire Q;
	
	lab9 dut (clk, reset, A, Q);
	
	initial
	begin
	clk<=0;
	forever #5 clk<=~clk;
	end
	
	
	initial
	begin
	A<=0; reset<=1;
	//$monitor("A=%d,reset=%d,count=%d",A,reset,count);
	
	
	 @ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=1; reset<=0;

	 @ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=0;
	
	@ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=0;
	
	 @ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=1;
	
	@ (posedge clk);
	A<=0;
	
	 @ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=0;
	
	@ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=0;
	
	 @ (posedge clk);
	A<=1;
	
	 @ (posedge clk);
	A<=1;
	
	@ (posedge clk);
	reset<=1;
	
	//$stop;
	end
endmodule