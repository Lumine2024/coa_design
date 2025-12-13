# Control Hazard Handling Implementation

## Overview
This implementation adds control hazard detection and handling for the pipelined CPU. Control hazards occur when branch or jump instructions change the program counter, requiring the pipeline to be flushed to prevent wrong instructions from executing.

## Implementation Approach
The control hazard handling is integrated directly into the pipeline registers using the `MEM_PCSrc` signal from the MEM stage, following the approach described in 实验五 (Experiment 5).

## How It Works

### 1. Branch/Jump Detection (MEM Stage)
In the MEM stage (STAGE_MEM.v), the `MEMout_PCSrc` signal is generated when a branch or jump is taken:
```verilog
assign MEMout_PCSrc = MEMin_Jump | (MEMin_Branch & MEMin_Zero);
```
- `MEMin_Jump = 1`: Unconditional jump (j instruction)
- `MEMin_Branch & MEMin_Zero = 1`: Conditional branch taken (beq when equal)

### 2. Pipeline Flush Mechanism

When `MEM_PCSrc = 1`, three pipeline registers are flushed:

#### REG_IF_ID (IF/ID Register)
```verilog
if (!Clrn || MEM_PCSrc) begin
    // Insert NOP - clear all signals
    ID_PC4  <= 32'h0;
    ID_PC   <= 32'h0;
    ID_Inst <= 32'h0;
end
```
- Clears the instruction fetched after the branch
- Prevents it from being decoded

#### REG_ID_EX (ID/EX Register)
```verilog
if (!Clrn || MEM_PCSrc || bubble) begin
    // Clear control signals, preventing writes
    EX_RegWr   <= 1'b0;
    EX_MemWr   <= 1'b0;
    EX_MemtoReg <= 1'b0;
    EX_Branch  <= 1'b0;
    EX_Jump    <= 1'b0;
    // Data signals preserved for load-use handling
end
```
- Clears control signals from the instruction in ID stage
- Prevents it from writing registers or memory

#### REG_EX_MEM (EX/MEM Register)
```verilog
if (!Clrn || MEM_PCSrc) begin
    // Clear control signals
    MEM_RegWr   <= 1'b0;
    MEM_MemWr   <= 1'b0;
    MEM_MemtoReg <= 1'b0;
    MEM_Branch  <= 1'b0;
    MEM_Jump    <= 1'b0;
    // Data signals preserved
end
```
- Clears control signals from the instruction in EX stage
- Prevents it from affecting processor state

### 3. PC Update
Simultaneously with the flush, the IF stage updates the PC:
```verilog
MUX32X2 mux_pcin (
    .X1(MEM_Btarg_or_Jtarg),  // Branch/Jump target
    .X0(IFout_PC4),            // PC + 4
    .S(MEM_PCSrc),             // Select target when branch/jump taken
    .Y(next_pc)
);
```

## Modified Modules

### 1. REG_IF_ID.v
- Added `MEM_PCSrc` input port
- Modified reset condition: `if (!Clrn || MEM_PCSrc)`
- Inserts NOP when branch/jump is taken

### 2. REG_ID_EX.v  
- Added `MEM_PCSrc` input port
- Modified reset condition: `if (!Clrn || MEM_PCSrc || bubble)`
- Clears control signals but preserves data for proper bubble handling

### 3. REG_EX_MEM.v
- Added `MEM_PCSrc` input port
- Modified reset condition: `if (!Clrn || MEM_PCSrc)`
- Clears control signals when flush occurs

### 4. PPCPU.v
- Connects `MEMout_PCSrc` to all three pipeline registers
- No separate control hazard detection unit needed

## Timing Analysis

When a branch is taken in cycle N:
- **Cycle N**: Branch instruction in MEM stage, PCSrc asserted
- **Cycle N+1**: 
  - IF/ID cleared (instruction at PC+4 flushed)
  - ID/EX cleared (instruction at PC+8 flushed)
  - EX/MEM cleared (instruction at PC+12 flushed)
  - PC loads branch target
- **Cycle N+2**: Correct instruction from target address enters IF stage

**Performance Cost**: 3 clock cycles lost per taken branch/jump

## Test Program
The InstROM includes a comprehensive test program:
```assembly
ori $1, $0, 1      # $1 = 1
ori $2, $0, 2      # $2 = 2
ori $3, $0, 3      # $3 = 3
beq $1, $2, 2      # No branch ($1 ≠ $2)
ori $4, $0, 4      # Executed
ori $5, $0, 5      # Executed
ori $6, $0, 1      # $6 = 1
beq $1, $6, 2      # Branch taken ($1 == $6)
ori $7, $0, 7      # FLUSHED
ori $8, $0, 8      # FLUSHED
ori $9, $0, 9      # Executed (branch target)
j 14               # Jump
ori $10, $0, 10    # FLUSHED
ori $11, $0, 11    # FLUSHED
ori $12, $0, 12    # Executed (jump target)
```

Expected results:
- Registers $7, $8, $10, $11 remain 0 (flushed)
- Registers $1-$6, $9, $12 have expected values
- Total instructions executed: 11 (4 flushed)

## Advantages of This Approach
1. **Simplicity**: No separate control hazard detection unit needed
2. **Directness**: PCSrc signal directly controls pipeline register clearing
3. **Consistency**: Matches the approach described in course materials (实验五)
4. **Efficiency**: Minimal hardware overhead

## Comparison with DetUnit_control
An alternative approach using a separate `DetUnit_control` module would:
- Add an extra module to generate `flush` signal from `PCSrc`
- Require additional wiring in the top module
- Provide no functional advantage

The direct approach (used here) is simpler and equally effective.
