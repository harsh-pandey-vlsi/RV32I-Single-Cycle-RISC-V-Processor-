# RV32I Single-Cycle RISC-V Processor (Verilog Simulation Project)

## Overview

This project implements a 32-bit RV32I Single-Cycle RISC-V Processor in synthesizable Verilog and verifies it using a SystemVerilog self-checking testbench.

The processor executes one instruction per clock cycle and supports arithmetic, logical, memory, branch, and jump instructions.

---

## ISA Coverage

### Supported Instructions

- R-Type: ADD, SUB, AND, OR, XOR, SLT
- I-Type: ADDI, ANDI, ORI, LW, JALR
- S-Type: SW
- B-Type: BEQ, BNE
- U-Type: LUI, AUIPC
- J-Type: JAL

---

## Architecture Blocks

- Program Counter (PC)
- Instruction Memory
- Control Unit
- Register File (32 × 32)
- Immediate Generator
- ALU Control
- ALU
- Data Memory
- Writeback MUX

---

## Directory Structure

- `rtl/` — Verilog RTL modules
- `tb/` — SystemVerilog testbench
- `programs/` — Instruction memory file
- `docs/` — waveform and Log values

---

## Simulation

The design can be simulated using:

- Questa / ModelSim
- Riviera-PRO
- EDA Playground

### Steps

1. Compile all RTL files
2. Compile testbench
3. Ensure `program.mem` is accessible
4. Run simulation
5. Enable waveform dump

Expected Results:

- PC increments correctly
- x5 = 15
- x6 = 5
- x7 = 15
- Memory[0] = 15
- x0 remains 0

The testbench is self-checking and prints PASS/FAIL.

---

## Features

- Fully synthesizable RTL
- Modular clean design
- Self-checking verification
- Waveform-based debugging
- ISA-compliant implementation

---

## Future Enhancements

- 5-stage pipelined architecture
- Hazard detection and forwarding
- Branch prediction
- Cache integration
- Performance counters

---

## Author

Harsh Pandey  
Electronics & Communication Engineering  
VLSI Design & Verification
