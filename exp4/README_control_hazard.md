# Control Hazard Handling Implementation

## Overview
This module implements control hazard detection and handling for the pipelined CPU. Control hazards occur when branch or jump instructions change the program counter, requiring the pipeline to be flushed.

## Module: DetUnit_control
- **Location**: `exp4/DetUnit_control.v`
- **Purpose**: Detects when a branch or jump is taken and generates a flush signal

### Functionality
- Monitors the `PCSrc` signal from the MEM stage
- When `PCSrc = 1` (branch/jump taken), asserts `flush = 1`
- The flush signal is propagated to IF/ID, ID/EX, and EX/MEM pipeline registers

## Pipeline Flush Mechanism

### Modified Modules

1. **REG_IF_ID** (`exp3/REG_IF_ID.v`)
   - Added `flush` input port
   - When flush is asserted, inserts NOP (all zeros) into the ID stage
   - Flush takes priority over stall

2. **REG_ID_EX** (`exp3/REG_ID_EX.v`)
   - Added `flush` input port
   - When flush or bubble is asserted, clears control signals (RegWr, MemWr, Branch, Jump, MemtoReg)
   - Preserves data signals but prevents any writes or control flow changes

3. **REG_EX_MEM** (`exp3/REG_EX_MEM.v`)
   - Added `flush` input port
   - When flush is asserted, clears control signals
   - Prevents the flushed instruction from affecting memory or registers

4. **PPCPU** (`exp3/PPCPU.v`)
   - Instantiates `DetUnit_control` module
   - Connects `control_hazard_flush` signal to all three pipeline registers
   - The flush signal is generated when `MEMout_PCSrc = 1`

## How It Works

1. **Branch/Jump Detection**: In the MEM stage, when a branch condition is true or a jump instruction executes, `MEMout_PCSrc` is set to 1

2. **Flush Signal Generation**: `DetUnit_control` detects `PCSrc = 1` and generates the `flush` signal

3. **Pipeline Flush**: The flush signal:
   - Clears the IF/ID register (instruction becomes NOP)
   - Clears control signals in ID/EX register (prevents execution)
   - Clears control signals in EX/MEM register (prevents memory/register writes)

4. **PC Update**: Simultaneously, the correct branch/jump target is loaded into the PC, so the next instruction fetched is from the correct address

## Timing
- Control hazard is detected in the MEM stage (4th stage)
- By the time the branch/jump is resolved, 3 instructions have entered the pipeline:
  - One in ID stage
  - One in EX stage  
  - One in MEM stage
- All three are flushed by clearing their control signals

## Test Program
The InstROM includes a test program that exercises:
- BEQ instruction that doesn't branch (tests correct non-flush)
- BEQ instruction that branches (tests flush of 3 instructions)
- Jump instruction (tests jump flush)

Expected behavior:
- Instructions following a taken branch/jump should not affect register file or memory
- Registers $7, $8, $10, $11 should remain 0 (instructions flushed)
- Registers $1-$6, $9, $12 should have their expected values
