module mux_2(input [3:0] a, input [3:0] b, input w, output reg [3:0] y);

always_comb
    if (w==1)
        y = a;
    else if (w == 0)
        y = b;
        
endmodule
