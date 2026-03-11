`timescale 1ns / 1ps

module lab7tb;

    // Testbench Signals
    reg clk_tb;
    reg rst_tb;
    reg wr_tb;
    reg [3:0] data_in;
    reg [2:0] selector;
    wire [7:0] anode_out;
    wire [6:0] seg_out;
    wire dp_out;

    lab7 dut (
        .clk(clk_tb), .reset(rst_tb), .write(wr_tb), .num(data_in), .sel(selector), .anode(anode_out), .seg(seg_out), .dp(dp_out)
    );

    // Generate a 100 MHz clock
    always #5 clk_tb = ~clk_tb;

    initial begin
        $display("Starting testbench...");
        clk_tb = 0;
        rst_tb = 1;
        wr_tb = 0;
        data_in = 4'b0000;
        selector = 3'b000;

        #10 rst_tb = 0;
        
        // Rearranged pattern
        #10 wr_tb = 1;
        #10 selector = 3'b000;
        #10 data_in = 4'b1100; // Store 'C'
        
        #10 wr_tb = 1;
        #10 selector = 3'b001;
        #10 data_in = 4'b0010; // Store '2'
        
        #10 wr_tb = 1;
        #10 selector = 3'b010;
        #10 data_in = 4'b1000; // Store '8'
        
        #10 wr_tb = 1;
        #10 selector = 3'b011;
        #10 data_in = 4'b1110; // Store 'E'
        
        #10 wr_tb = 1;
        #10 selector = 3'b100;
        #10 data_in = 4'b1011; // Store 'B'
        
        #10 wr_tb = 1;
        #10 selector = 3'b101;
        #10 data_in = 4'b0110; // Store '6'
        
        #10 wr_tb = 1;
        #10 selector = 3'b110;
        #10 data_in = 4'b0000; // Store '0'
        
        #10 wr_tb = 1;
        #10 selector = 3'b111;
        #10 data_in = 4'b0101; // Store '5'
        
        #10 wr_tb = 0; // Hold write low and check stored values
        
        #100;

        // End the simulation
        $display("Testbench completed.");
    end
endmodule
