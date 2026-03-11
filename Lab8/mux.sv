module mux(input a, input  b, input w, output reg y);

always_comb
    if (w==1)
        y = a;
    else if (w == 0)
        y = b;
        
endmodule
