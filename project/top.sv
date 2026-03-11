// File: top_adxl_spi_display.sv
// Top-level module integrating SPI, display, FSM, and I/O for Nexys A7 and ADXL accelerometer.

module top_adxl_spi_display (
    input  logic        CLK100MHZ,    // 100 MHz onboard clock
    input  logic [1:0]  SW,           // SW[0]=reset, SW[1]=CS control (active high turns CS on)
    output logic [7:0]  AN,           // 7-seg anodes (AN[0] is rightmost digit)
    output logic        CA, CB, CC, CD, CE, CF, CG, DP, // 7-seg segment cathodes
    output logic        MOSI,         // SPI Master Out
    input  logic        MISO,         // SPI Master In
    output logic        SCLK,         // SPI Clock (1 MHz)
    output logic        CS            // SPI Chip Select (active low)
);

    // =========================================================================
    // Clock generation: divide 100MHz to 4MHz and 1MHz
    // =========================================================================
    logic clk4, clk1;
    // Divide by 25: 100MHz -> 4MHz
    clk_div_25 clkdiv4(.clk_in(CLK100MHZ), .rst(SW[0]), .clk_out(clk4));
    // Divide by 4: 4MHz -> 1MHz
    clk_div_4  clkdiv1(.clk_in(clk4), .rst(SW[0]), .clk_out(clk1));

    // =========================================================================
    // SPI master instance (runs on clk4 to generate SCLK at 1MHz)
    // =========================================================================
    logic [7:0] spi_rx_data;
    logic       spi_busy, spi_done;
    logic [7:0] spi_tx_data;
    logic       spi_start;

    spi_master spi0 (
        .clk   (clk4),        // 4 MHz clock driving SPI state machine
        .rst   (SW[0]),       // reset from SW0
        .start (spi_start),   // start a transfer
        .tx    (spi_tx_data), // byte to send (command/address)
        .rx    (spi_rx_data), // byte received
        .busy  (spi_busy),    // busy flag
        .done  (spi_done),    // done flag (pulse)
        .MOSI  (MOSI),
        .MISO  (MISO),
        .SCLK  (SCLK)         // 1 MHz SPI clock output
    );

    // CS is active-low; controlled by SW[1]
    // SW[1]=1 => CS=0 (selected); SW[1]=0 => CS=1 (deselected)
    assign CS = ~SW[1];

    // =========================================================================
    // Control FSM: sequence reads of X, Y, Z when CS is active
    // =========================================================================
    typedef enum logic [1:0] {IDLE, READ_X, READ_Y, READ_Z} state_t;
    state_t state, next_state;

    // 5-bit signed data for each axis
    logic [4:0] x_data, y_data, z_data;
    // After each SPI transfer, interpret the 8-bit rx into 5-bit (sign+magnitude)
    // For simplicity, we use rx[7] as sign, and rx[6:3] as magnitude bits (4-bit).
    // (This effectively takes the top 5 bits of the returned byte.)
    always_ff @(posedge clk4 or posedge SW[0]) begin
        if (SW[0]) begin
            state <= IDLE;
            x_data <= 0;
            y_data <= 0;
            z_data <= 0;
        end else begin
            state <= next_state;
            // Capture received data when done, and store into appropriate axis
            if (spi_done) begin
                case (state)
                    READ_X: x_data <= {spi_rx_data[7], spi_rx_data[6:3]};
                    READ_Y: y_data <= {spi_rx_data[7], spi_rx_data[6:3]};
                    READ_Z: z_data <= {spi_rx_data[7], spi_rx_data[6:3]};
                    default: ;
                endcase
            end
        end
    end

    // FSM next-state logic and control signals
    always_comb begin
        // Defaults
        spi_start   = 1'b0;
        spi_tx_data = 8'h00;
        next_state  = state;
        case (state)
            IDLE: begin
                // Wait for CS active (SW[1]=1). If asserted, go read X
                if (SW[1]) begin
                    next_state = READ_X;
                    // Prepare to send X-axis read command (e.g., ADXL register 0x32 | 0x80 for read)
                    spi_tx_data = 8'h32; 
                    spi_start   = 1'b1;
                end
            end
            READ_X: begin
                if (spi_done) begin
                    next_state = READ_Y;
                    spi_tx_data = 8'h34; // Y-axis register
                    spi_start   = 1'b1;
                end
            end
            READ_Y: begin
                if (spi_done) begin
                    next_state = READ_Z;
                    spi_tx_data = 8'h36; // Z-axis register
                    spi_start   = 1'b1;
                end
            end
            READ_Z: begin
                if (spi_done) begin
                    // Done reading Z; go back to IDLE or repeat if CS still asserted
                    if (SW[1]) begin
                        next_state = READ_X;
                        spi_tx_data = 8'h32;
                        spi_start   = 1'b1;
                    end else begin
                        next_state = IDLE;
                    end
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Pack the 5-bit axis data into acl_data (15 bits: {Z,Y,X})
    logic [14:0] acl_data;
    assign acl_data = {z_data, y_data, x_data}; // [14:10]=Z, [9:5]=Y, [4:0]=X

    // =========================================================================
    // Prepare decimal digits for display (6 digits: X_tens, X_ones, Y_tens, ... Z_ones)
    // =========================================================================
    logic [3:0] X_mag, Y_mag, Z_mag;
    assign X_mag = x_data[3:0]; // ignore sign for display (magnitude only)
    assign Y_mag = y_data[3:0];
    assign Z_mag = z_data[3:0];

    logic [3:0] X_tens, X_ones, Y_tens, Y_ones, Z_tens, Z_ones;
    // Simple divide/mod10 (since max magnitude is 15)
    assign X_tens = X_mag / 10;
    assign X_ones = X_mag % 10;
    assign Y_tens = Y_mag / 10;
    assign Y_ones = Y_mag % 10;
    assign Z_tens = Z_mag / 10;
    assign Z_ones = Z_mag % 10;

    // =========================================================================
    // Seven-segment display driver
    // =========================================================================
    seg7_control disp0 (
        .clk   (clk4),        // fast clock for multiplexing
        .x_ten (X_tens), .x_one (X_ones),
        .y_ten (Y_tens), .y_one (Y_ones),
        .z_ten (Z_tens), .z_one (Z_ones),
        .AN    (AN),
        .CA    (CA), .CB (CB), .CC(CC), .CD (CD),
        .CE    (CE), .CF (CF), .CG(CG), .DP (DP)
    );

endmodule
