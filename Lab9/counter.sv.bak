module counter(input reset, input clk, output reg [6:0]q);
	assign a = 1;
always_ff @ (posedge clk)
    if (reset == 1 )
        q <= 0;
	else if  (q == 100)
		q <= 0;
    else
        q <= q + a;
endmodule
