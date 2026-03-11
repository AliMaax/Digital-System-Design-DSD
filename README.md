# Digital System Design (DSD) Portfolio

Welcome to my Digital System Design repository! This collection showcases my progression in Hardware Description Languages (HDL) and digital logic design, completed as part of my Electrical Engineering studies at the University of Engineering and Technology (UET), Lahore.

This repository serves as a record of my practical experience in designing, simulating, and verifying digital circuits, progressing from basic logic gates to complex system-level projects.

## 🛠️ Tech Stack & Skills
- **Languages:** SystemVerilog, Verilog, Tcl
- **Core Competencies:** - Register-Transfer Level (RTL) Design
  - Combinational and Sequential Logic
  - Finite State Machines (FSM)
  - SPI Protocol Implementation
  - Hardware/Sensor Interfacing (ADXL345 Accelerometer)
  - Testbench Creation and Functional Verification

## 📁 Repository Structure

The repository is divided into foundational laboratory exercises and a comprehensive final project:

### 🔬 Laboratory Exercises (Lab 1 - Lab 9)
*A series of progressive modules demonstrating core digital design principles.*
- **Lab 1 - Lab 3:** Basic digital logic, multiplexers, decoders, and simple arithmetic circuits. 
- **Lab 4 - Lab 6:** Sequential logic, flip-flops, counters, and shift registers.
- **Lab 7 - Lab 9:** Advanced state machines, memory modules, and datapath design.

### 🚀 Final Project: ADXL345 SPI Accelerometer with 7-Segment Display
The `project` directory contains my capstone work for this course, demonstrating a full hardware integration using a Nexys A7 FPGA.

* **Objective:** Designed a complete digital system to interface with an ADXL345 accelerometer over the SPI protocol. The system continuously polls the X, Y, and Z acceleration registers and multiplexes the extracted data onto a 6-digit 7-segment display in real-time.
* **Architecture & Key Modules:**
  - **`spi.sv`:** A custom-built, fully synthesizable SPI master operating at 1 MHz (CPOL=0, CPHA=0) to handle 8-bit read/write transactions.
  - **Control FSM (`top.sv`):** A state machine that sequences the operations: waiting for chip select, and automatically cycling through read commands for the X (0x32), Y (0x34), and Z (0x36) data registers.
  - **Clock Dividers (`clk.sv`):** Scales the onboard 100 MHz clock down to appropriate frequencies for the SPI clock and display multiplexing.
  - **`seg7.sv`:** A dynamic multiplexing driver that decodes binary acceleration data into BCD (Binary Coded Decimal) and drives the common-anode 7-segment display.
  - **`tb.sv`:** A robust testbench that simulates the ADXL345 slave responses, ensuring the SPI timing and FSM transitions function perfectly before physical deployment.

## 💡 Why This Matters
- **Full-System Design:** Demonstrates the ability to take a system from clock generation and low-level protocol implementation (SPI) up to high-level state machine control and user-facing I/O.
- **Clean, Synthesizable Code:** Focuses on writing hardware descriptions that easily map to actual physical gates.
- **Verification Mindset:** Emphasizes writing robust testbenches alongside RTL to catch bugs early in the design cycle.

## 📬 Let's Connect
**Ali Maaz** *Electrical Engineering* - **GitHub:** [@Ali Maaz](https://github.com/AliMaax)
- **LinkedIn:** [Ali Maaz](www.linkedin.com/in/ali-maaz-64986b29b)
- **Email:** alimaaz7865@gmail.com