// File: spi_master.sv
// Simple SPI master for 1 MHz SCLK (CPOL=0, CPHA=0, MSB-first).
module spi_master (
    input  logic       clk,    // input clock (4 MHz)
    input  logic       rst,    // active-high reset
    input  logic       start,  // start transfer (1-cycle pulse)
    input  logic [7:0] tx,     // byte to transmit
    output logic [7:0] rx,     // byte received
    output logic       busy,   // high while transfer in progress
    output logic       done,   // pulse when transfer complete
    output logic       MOSI,
    input  logic       MISO,
    output logic       SCLK
);
    // Internal state: 8-bit shift registers and counters
    logic [7:0] tx_shift, rx_shift;
    logic [3:0] bitcnt;      // bit counter (0-7)
    logic [1:0] phase;       // 2-bit phase for generating SCLK (0-3)
    logic       sclk_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            busy      <= 1'b0;
            done      <= 1'b0;
            SCLK      <= 1'b0;
            MOSI      <= 1'b0;
            tx_shift  <= 8'h00;
            rx_shift  <= 8'h00;
            bitcnt    <= 4'd0;
            phase     <= 2'd0;
        end else begin
            done <= 1'b0; // default: clear done
            if (start && !busy) begin
                // Initialize transfer
                busy     <= 1'b1;
                tx_shift <= tx;
                rx_shift <= 8'h00;
                bitcnt   <= 4'd7;  // start with MSB
                phase    <= 2'd0;
                SCLK     <= 1'b0;
                MOSI     <= tx[7];
            end else if (busy) begin
                // SPI clock generation (divide clk by 4 => 1 MHz SCLK)
                phase <= phase + 2'd1;
                case (phase)
                    2'd1: begin
                        SCLK <= 1'b1;            // rising edge of SCLK
                        rx_shift[bitcnt] <= MISO; // sample MISO
                    end
                    2'd3: begin
                        SCLK <= 1'b0;            // falling edge of SCLK
                        if (bitcnt == 0) begin
                            busy <= 1'b0;
                            done <= 1'b1;        // transfer done
                        end else begin
                            bitcnt <= bitcnt - 1;
                            MOSI   <= tx_shift[bitcnt-1]; // next bit
                        end
                    end
                endcase
            end
        end
    end

    assign rx = rx_shift; // final received byte

endmodule
