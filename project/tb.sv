`timescale 1ns/1ps
module tb_adxl_spi_display;
  // Clock and switches
  reg clk = 0;
  reg [1:0] SW = 2'b00;
  // SPI signals
  wire spi_sclk, spi_mosi, spi_cs;
  reg  spi_miso = 1'b0;

  // Instantiate the top module (DUT)
  top_adxl_spi_display uut (
    .clk(clk),
    .SW(SW),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi),
    .spi_miso(spi_miso),
    .spi_cs(spi_cs)
    // (7-segment and other ports omitted for brevity)
  );

  // 100 MHz clock generation
  always #5 clk = ~clk;

  // Monitor SPI signals and time
  initial begin
    $display("Time | CS SCLK MOSI MISO | Event");
    $monitor("%4t |   %b    %b    %b    %b", $time, spi_cs, spi_sclk, spi_mosi, spi_miso);
  end

  // Initial reset and control stimulus
  initial begin
    // Assert reset (SW[0]) for 2 cycles, then deassert
    #10;
    SW[0] = 1;
    #20;
    SW[0] = 0;
    // Activate SPI transaction (if SW[1] is used to start read)
    #50;
    SW[1] = 1;
    // Keep simulation running to capture transactions
    #1000;
    $finish;
  end

  // Parameters for ADXL345 register addresses (LSB bytes)
  localparam byte X_ADDR = 8'h32;  // DATAX0
  localparam byte Y_ADDR = 8'h34;  // DATAY0
  localparam byte Z_ADDR = 8'h36;  // DATAZ0
  localparam byte X_VAL  = 8'h12;
  localparam byte Y_VAL  = 8'h34;
  localparam byte Z_VAL  = 8'h56;

  // SPI slave (accelerometer) state
  reg [7:0] recv_byte;
  reg [7:0] send_byte;
  reg [3:0] bit_cnt = 0;
  reg       sending = 0;

  // On rising edge of SCLK, shift in MOSI when CS is low
  always @(posedge spi_sclk or posedge spi_cs) begin
    if (spi_cs) begin
      // CS went high: reset byte counters
      bit_cnt <= 0;
      sending <= 0;
    end else begin
      // Capture bit on MOSI
      recv_byte <= {recv_byte[6:0], spi_mosi};
      bit_cnt <= bit_cnt + 1;
      if (bit_cnt == 7) begin
        // Full command byte received
        bit_cnt <= 0;
        // Check for read command (MSB=1)
        if (recv_byte[7] == 1) begin
          // Extract register address (bits [5:0])
          if (recv_byte[5:0] == X_ADDR) begin
            send_byte <= X_VAL;
            sending <= 1;
            $display("%0t ns: Detected read of X register (0x%0h), returning 0x%0h", $time, X_ADDR, X_VAL);
          end
          else if (recv_byte[5:0] == Y_ADDR) begin
            send_byte <= Y_VAL;
            sending <= 1;
            $display("%0t ns: Detected read of Y register (0x%0h), returning 0x%0h", $time, Y_ADDR, Y_VAL);
          end
          else if (recv_byte[5:0] == Z_ADDR) begin
            send_byte <= Z_VAL;
            sending <= 1;
            $display("%0t ns: Detected read of Z register (0x%0h), returning 0x%0h", $time, Z_ADDR, Z_VAL);
          end
        end
      end
    end
  end

  // On falling edge of SCLK, drive MISO (if sending data)
  always @(negedge spi_sclk) begin
    if (!spi_cs && sending) begin
      // Output MSB first
      spi_miso <= send_byte[7];
      send_byte <= {send_byte[6:0], 1'b0};
      // After 8 bits, stop sending
      if (&send_byte[7:1] === 1'b0) begin
        sending <= 0;
      end
    end else begin
      spi_miso <= 1'b0; // idle
    end
  end

endmodule
