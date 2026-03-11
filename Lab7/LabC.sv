`timescale 1ns / 1ps

module lab7(
    output reg [7:0] anode,  // anode signals for 7-segment displays
    output reg [6:0] seg,    // segment signals for 7-segment display
    input logic clk,         // system clock (100 MHz)
    input logic write,       // write signal
    input logic reset,       // reset signal
    input logic [3:0] num,   // 4-bit number input
    input logic [2:0] sel,
    output logic dp          // selector input
);
    // internal signals
    logic clk_div;            // 100 Hz clock
    logic [3:0] display_reg[7:0]; // registers for display values
    logic [2:0] disp_counter; // counter for display selection
    logic [7:0] enable_reg;   // enable signals for storage
    logic [3:0] mux_out;      // multiplexer output
    logic [16:0] clk_counter;
    logic [2:0] scan_counter;
    logic [2:0] active_sel;
    
    assign dp = 1;
    
    // Clock frequency divider: reduces frequency to 763Hz
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            clk_counter <= 0;
        else
            clk_counter <= clk_counter + 1'b1;
    end
    assign clk_div = clk_counter[16];
    
    // Further frequency division to 100Hz for each segment
    always_ff @(posedge clk_div or posedge reset) begin
        if (reset)
            scan_counter <= 0;
        else
            scan_counter <= scan_counter + 1'b1;
    end

    // Select active display
    always_comb begin
        if (write)
            active_sel = sel;
        else
            active_sel = scan_counter;
    end
    
    // Multiplexer for selecting the active display value
    always_comb begin
        case (active_sel)
            3'b000: mux_out = display_reg[0];
            3'b001: mux_out = display_reg[1];
            3'b010: mux_out = display_reg[2];
            3'b011: mux_out = display_reg[3];
            3'b100: mux_out = display_reg[4];
            3'b101: mux_out = display_reg[5];
            3'b110: mux_out = display_reg[6];
            3'b111: mux_out = display_reg[7];
        endcase
    end
    
    // Anode control for cycling through displays
    always_comb begin
        case (active_sel)
            3'b000: anode = 8'b11111110;
            3'b001: anode = 8'b11111101;
            3'b010: anode = 8'b11111011;
            3'b011: anode = 8'b11110111;
            3'b100: anode = 8'b11101111;
            3'b101: anode = 8'b11011111;
            3'b110: anode = 8'b10111111;
            3'b111: anode = 8'b01111111;
        endcase
    end
    
    // Enable signal generation for registers
    always_comb begin 
        for (int i = 0; i < 8; i = i + 1) begin 
            enable_reg[i] = write & ~anode[i];
        end
    end
    
    // Flip-flops for storing values
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 8; i = i + 1) begin
                display_reg[i] <= 4'b0000;
            end
        end else begin
            for (int i = 0; i < 8; i = i + 1) begin
                if (enable_reg[i]) display_reg[i] <= num;
            end
        end
    end
    
    // Seven-segment display decoder
    always_comb begin
        case (mux_out)
            4'b0000 : seg = 7'b0000001;
            4'b0001 : seg = 7'b1001111;
            4'b0010 : seg = 7'b0010010;
            4'b0011 : seg = 7'b0000110;
            4'b0100 : seg = 7'b1001100;
            4'b0101 : seg = 7'b0100100;
            4'b0110 : seg = 7'b0100000;
            4'b0111 : seg = 7'b0001111;
            4'b1000 : seg = 7'b0000000;
            4'b1001 : seg = 7'b0000100;
            4'b1010 : seg = 7'b0001000;
            4'b1011 : seg = 7'b1100000;
            4'b1100 : seg = 7'b0110001;
            4'b1101 : seg = 7'b1000010;
            4'b1110 : seg = 7'b0110000;
            4'b1111 : seg = 7'b0111000;
        endcase
    end
    
endmodule
