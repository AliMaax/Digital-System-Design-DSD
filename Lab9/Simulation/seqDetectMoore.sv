`timescale 1ns/10ps
module seqDetectMoore(input  logic       clk, reset, A,
                      output logic       smile);

   typedef enum logic [1:0] {S0, S1, S2} statetype;
   statetype state, nextstate;  
 
   // state register
   always_ff @(posedge clk, posedge reset)
      if (reset) state <= S0;
      else       state <= nextstate;

   // next state logic
   always_comb
      case (state)
        S0:      if (A) nextstate = S0; 
                 else   nextstate = S1;
        S1:      if (A) nextstate = S2;
                 else   nextstate = S1;
        S2:      if (A) nextstate = S0;
                 else   nextstate = S1;
        default:        nextstate = S0;
      endcase

   // output logic
   assign smile = (state == S2);
endmodule 
