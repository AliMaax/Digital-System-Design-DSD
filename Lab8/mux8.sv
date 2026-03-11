module mux8 (input [3:0] a, input [3:0] b, input [3:0] c, input [3:0] d, 
             input [3:0] e, input [3:0] f, input [3:0] g, input [3:0] h,
             input [2:0] s, 
             output reg [3:0] y);

    always_comb 
        begin 
        if ((s[2] == 0) & (s[1] == 0) & (s[0] == 0))
			y = a;
		else if ((s[2] == 0) & (s[1] == 0) & (s[0] == 1))
			y = b;
		else if ((s[2] == 0) & (s[1] == 1) & (s[0] == 0))
			y = c;
		else if ((s[2] == 0) & (s[1] == 1) & (s[0] == 1))
			y = d;
        else if ((s[2] == 1) & (s[1] == 0) & (s[0] == 0))
            y = e;
        else if ((s[2] == 1) & (s[1] == 0) & (s[0] == 1))
            y = f;
        else if ((s[2] == 1) & (s[1] == 1) & (s[0] == 0))
            y = g;
        else if ((s[2] == 1) & (s[1] == 1) & (s[0] == 1))
            y = h;
        end		
endmodule
