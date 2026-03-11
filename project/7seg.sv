// File: seg7_control.sv
// Multiplexed 6-digit 7-segment display driver (common-anode).
// Inputs: digit values for X, Y, Z axes (tens and ones).
// Outputs: segment lines CA-CG, DP, and 8-bit anode enable.
module seg7_control (
    input  logic       clk,       // fast clock for refreshing display
    input  logic [3:0] x_ten,
    input  logic [3:0] x_one,
    input  logic [3:0] y_ten,
    input  logic [3:0] y_one,
    input  logic [3:0] z_ten,
    input  logic [3:0] z_one,
    output logic [7:0] AN,        // AN[7]=leftmost digit ... AN[0]=rightmost
    output logic       CA, CB, CC, CD, CE, CF, CG, DP
);
    // Digit select index (0 to 5 for 6 digits: X_ten, X_one, Y_ten, Y_one, Z_ten, Z_one)
    logic [2:0] idx;
    always_ff @(posedge clk) begin
        if (idx == 3'd5) idx <= 3'd0;
        else idx <= idx + 3'd1;
    end

    // Select which digit to display based on idx
    logic [3:0] digit;
    always_comb begin
        case (idx)
            3'd0: digit = x_ten;
            3'd1: digit = x_one;
            3'd2: digit = y_ten;
            3'd3: digit = y_one;
            3'd4: digit = z_ten;
            3'd5: digit = z_one;
            default: digit = 4'd0;
        endcase
    end

    // Set anode (active HIGH) for the current digit, others low
    always_comb begin
        // AN[7:0] = {AN7,...,AN0}; use only AN5..AN0
        case (idx)
            3'd0: AN = 8'b0010_0000; // AN5 = 1 (X tens)
            3'd1: AN = 8'b0001_0000; // AN4 = 1 (X ones)
            3'd2: AN = 8'b0000_1000; // AN3 = 1 (Y tens)
            3'd3: AN = 8'b0000_0100; // AN2 = 1 (Y ones)
            3'd4: AN = 8'b0000_0010; // AN1 = 1 (Z tens)
            3'd5: AN = 8'b0000_0001; // AN0 = 1 (Z ones)
            default: AN = 8'b0000_0000;
        endcase
    end

    // 7-segment font (active LOW for lit segments)
    always_comb begin
        // Default: all segments off (HIGH)
        {CA, CB, CC, CD, CE, CF, CG} = 7'b111_1111;
        case (digit)
            4'h0: {CA,CB,CC,CD,CE,CF,CG} = 7'b000_0001;
            4'h1: {CA,CB,CC,CD,CE,CF,CG} = 7'b100_1111;
            4'h2: {CA,CB,CC,CD,CE,CF,CG} = 7'b001_0010;
            4'h3: {CA,CB,CC,CD,CE,CF,CG} = 7'b000_0110;
            4'h4: {CA,CB,CC,CD,CE,CF,CG} = 7'b100_1100;
            4'h5: {CA,CB,CC,CD,CE,CF,CG} = 7'b010_0100;
            4'h6: {CA,CB,CC,CD,CE,CF,CG} = 7'b010_0000;
            4'h7: {CA,CB,CC,CD,CE,CF,CG} = 7'b000_1111;
            4'h8: {CA,CB,CC,CD,CE,CF,CG} = 7'b000_0000;
            4'h9: {CA,CB,CC,CD,CE,CF,CG} = 7'b000_0100;
            default: {CA,CB,CC,CD,CE,CF,CG} = 7'b111_1111; // blank
        endcase
    end

    // Decimal point unused
    assign DP = 1'b1;

endmodule
