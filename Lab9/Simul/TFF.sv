module TFF(input T, clk, output reg Q);
always_ff @(posedge clk)
    if (T ==1)
        Q <= ~ Q;
endmodule
