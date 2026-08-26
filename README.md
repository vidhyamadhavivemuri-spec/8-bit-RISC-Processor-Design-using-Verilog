# 8-bit RISC Processor Design using Verilog

## Overview

This project presents the design and simulation of a basic 8-bit RISC (Reduced Instruction Set Computing) processor using Verilog HDL.

The processor follows a simple single-cycle architecture and demonstrates the fundamental components of a CPU, including instruction fetching, instruction decoding, register operations, arithmetic and logical operations, and memory access.

## Architecture

The processor consists of the following major components:

- Program Counter (PC)
- Instruction Memory
- Control Unit
- Register File
- Arithmetic Logic Unit (ALU)
- Data Memory

### Processor Datapath

```text
             ┌─────────────────────┐
             │ Instruction Memory  │
             └──────────┬──────────┘
                        │
                        ▼
             ┌─────────────────────┐
             │    Control Unit     │
             └──────────┬──────────┘
                        │
                        ▼
             ┌─────────────────────┐
             │    Register File    │
             └──────────┬──────────┘
                        │
                        ▼
                  ┌───────────┐
                  │    ALU    │
                  └─────┬─────┘
                        │
                        ▼
             ┌─────────────────────┐
             │    Data Memory      │
             └─────────────────────┘
