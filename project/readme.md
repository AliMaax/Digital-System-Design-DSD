# 🚀 ADXL345 Accelerometer SPI Interface & Display (SystemVerilog)

A complete Register-Transfer Level (RTL) digital system designed to interface an **ADXL345 Accelerometer** using the **SPI protocol**, implemented on an FPGA (e.g., Nexys A7). The system continuously polls 3-axis acceleration data (X, Y, Z) and dynamically multiplexes the extracted values onto a 6-digit 7-segment display in real-time.

## 🛠️ Hardware Requirements
* **FPGA Board:** Nexys A7 (or equivalent board with a 100MHz clock and 7-segment displays)
* **Sensor:** ADXL345 Accelerometer (Onboard or external via PMOD)
* **Switches:** 2 hardware switches for Reset and Chip Select (CS) control

## 🔌 Top-Level I/O Mapping
| Port Name | Direction | Description |
| :--- | :--- | :--- |
| `CLK100MHZ` | Input | 100 MHz onboard system clock |
| `SW[0]` | Input | Active-high asynchronous reset |
| `SW[1]` | Input | SPI Chip Select (CS) enable (Active high turns CS low/active) |
| `MOSI` / `MISO` | Out / In | SPI Master Out Slave In / Master In Slave Out |
| `SCLK` / `CS` | Output | 1 MHz SPI Clock / Active-Low Chip Select |
| `AN[7:0]` | Output | 7-Segment Anode enables (Multiplexing) |
| `CA - CG, DP` | Output | 7-Segment Cathodes (Active low for lit segments) |

---

## 🏗️ System Architecture & Modules

The system is fully modular, written in synthesizable SystemVerilog, and consists of the following key components:

### 1. SPI Master (`spi_master.sv`)
A custom-built, standard SPI master operating at **1 MHz** with `CPOL=0` and `CPHA=0`. It handles 8-bit, MSB-first data transmission and reception, utilizing a `busy` and `done` flag handshake to communicate with the main controller.

### 2. Control FSM (`top_adxl_spi_display.sv`)
The brain of the system. A continuous state machine that manages the SPI reads:
* **`IDLE`:** Waits for `SW[1]` to activate the Chip Select.
* **`READ_X` (0x32):** Transmits the X-axis register address and captures the incoming byte.
* **`READ_Y` (0x34):** Transmits the Y-axis register address and captures the incoming byte.
* **`READ_Z` (0x36):** Transmits the Z-axis register address, captures the byte, and loops back to `READ_X`.
* *Data Parsing:* Automatically extracts the 4-bit magnitude and converts it into BCD (Tens and Ones) via division/modulo logic for the display.

### 3. Clock Dividers (`clk_div_25.sv`, `clk_div_4.sv`)
Derives the necessary operating frequencies from the main 100 MHz clock:
* **4 MHz Clock:** Drives the SPI FSM and the 7-segment multiplexing refresh rate.
* **1 MHz Clock:** Driven directly to the `SCLK` line for sensor communication.

### 4. 7-Segment Display Controller (`seg7_control.sv`)
A dynamic multiplexing driver. It cycles through the 6 BCD digits (X_tens, X_ones, Y_tens, Y_ones, Z_tens, Z_ones) at high speed using the 4 MHz clock, providing the illusion that all 6 digits are illuminated simultaneously.

### 5. Testbench (`tb_adxl_spi_display.sv`)
A comprehensive simulation environment that mocks the ADXL345 slave device. It monitors the `MOSI` line for the correct register addresses (0x32, 0x34, 0x36) and responds on the `MISO` line with dummy data (0x12, 0x34, 0x56) to verify RTL functionality before FPGA synthesis.

---

## 🚀 How to Simulate & Synthesize (Vivado / QuestaSim)
1. **Simulation:** * Add all `.sv` files to your simulation tool.
   * Set `tb_adxl_spi_display.sv` as the top module.
   * Run the simulation for at least `1000ns` to observe the SPI `busy`/`done` handshake and the MISO/MOSI data exchange.
2. **Synthesis/Implementation:**
   * Create a new RTL project in Vivado and add all design sources (excluding the testbench).
   * Import your board-specific `.xdc` constraint file to map the I/O ports to physical pins.
   * Generate the Bitstream and program the FPGA.

---

## 👨‍💻 Author
**Ali Maaz** * Electrical Engineering Student at UET Lahore
* Connect with me on [LinkedIn](https://www.linkedin.com/in/ali-maaz-64986b29b)
