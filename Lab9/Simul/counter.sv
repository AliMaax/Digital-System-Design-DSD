`timescale 1ns/10ps
module counter(input reset, input clk, output reg [3:0]q);
always_ff @ (posedge clk)
	begin
    if (reset)
		q <= 0;
    else
        q <= q + 1;
	end
endmodule
