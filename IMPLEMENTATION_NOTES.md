# SW Hazard Solution Implementation Notes

## Problem Description
Based on the homework assignment in `实验报告.md` (Experiment 4, Assignment 4), there is a data hazard when a store word (sw) instruction immediately follows an instruction that writes to the register being stored:

```assembly
add $1, $2, $3    # Instruction 1: writes to $1
sw $1, 0($2)      # Instruction 2: needs $1 value in MEM stage
```

**Hazard Analysis:**
- When `add` is in WB stage, `sw` is in MEM stage
- `sw` needs the value of `$1` to write to memory
- The standard EX-stage forwarding doesn't help because `sw` needs the data in MEM stage, not EX stage
- Without forwarding, `sw` would write the old (stale) value of `$1` to memory

## Solution Implemented: 方案一 - MEM Stage Forwarding (Recommended)

This implementation adds forwarding logic in the MEM stage to detect when a store instruction needs data that's being written back in the WB stage.

### Changes Made

#### 1. Created `exp4/DetUnit_MEM.v`
A new forwarding detection unit specifically for MEM stage store operations:
- Detects when `sw` in MEM stage needs data from WB stage
- Checks: `M_MemWr && W_RegWr && (W_Rw == M_Rt) && (W_Rw != 0)`
- Outputs `forward_busB` signal to enable forwarding

#### 2. Modified `exp3/REG_EX_MEM.v`
Added `EX_Rt` input and `MEM_Rt` output to pass the source register through the pipeline:
- Input: `EX_Rt` - source register Rt from EX stage
- Output: `MEM_Rt` - source register Rt to MEM stage
- This allows the MEM stage to know which register contains the data to be stored

#### 3. Modified `exp3/STAGE_MEM.v`
Added forwarding logic in the MEM stage:
- Added inputs: `MEMin_Rt`, `WR_RegDin`, `WR_Rw`, `WR_RegWr`
- Instantiated `DetUnit_MEM` module for forwarding detection
- Added multiplexer to select between `MEMin_busB` and `WR_RegDin`
- DataRAM now uses `DataIn_forward` instead of `MEMin_busB`

```verilog
// Forwarding detection using DetUnit_MEM
wire mem_forward_busB;
DetUnit_MEM det_mem (
    .M_Rt(MEMin_Rt),
    .W_Rw(WR_Rw),
    .W_RegWr(WR_RegWr),
    .M_MemWr(MEMin_MemWr),
    .forward_busB(mem_forward_busB)
);

// Data selection
wire [31:0] DataIn_forward;
assign DataIn_forward = mem_forward_busB ? WR_RegDin : MEMin_busB;

// Use forwarded data
DataRAM data_ram (
    .CLK(Clk),
    .WE(MEMin_MemWr),
    .DataIn(DataIn_forward),  // Forwarded if needed
    .Address(MEMin_ALUout),
    .DataOut(mem_dout)
);
```

#### 4. Modified `exp3/PPCPU.v`
Connected all the new signals:
- Added `MEM_Rt` wire declaration
- Connected `EX_Rt` to `REG_EX_MEM` input
- Connected `MEM_Rt` from `REG_EX_MEM` output
- Passed `MEMin_Rt` to `STAGE_MEM`
- Passed `WR_RegDin`, `WR_Rw`, `WR_RegWr` to `STAGE_MEM` for forwarding

### How It Works

**Timeline for `add $1, $2, $3` followed by `sw $1, 0($2)`:**

```
Cycle 1: add in IF
Cycle 2: add in ID, sw in IF
Cycle 3: add in EX, sw in ID
Cycle 4: add in MEM, sw in EX
Cycle 5: add in WB, sw in MEM  <-- FORWARDING HAPPENS HERE
```

At Cycle 5:
1. `add` is in WB stage, writing $1 = 150 (example value)
2. `sw` is in MEM stage, needs to write the value of $1 to memory
3. Forwarding detection: `WR_Rw == MEM_Rt` (both are register $1)
4. `mem_forward_busB = 1`
5. `DataIn_forward = WR_RegDin` (gets 150 from WB stage)
6. Memory writes the correct value (150) instead of the stale value

### Benefits

1. **No Performance Loss**: Unlike inserting NOPs, forwarding has zero cycle penalty
2. **Minimal Hardware Cost**: Only adds one comparator and one 32-bit 2-to-1 multiplexer
3. **Automatic Detection**: Hardware automatically detects and resolves the hazard
4. **ISE Compatible**: The implementation uses standard Verilog constructs compatible with Xilinx ISE

### Testing

The implementation successfully compiles with iverilog:
```bash
iverilog -g2012 -o ppcpu_test \
  exp1/*.v exp2/*.v exp3/*.v exp4/DetUnit*.v
```

Simulation runs without errors and the pipeline correctly handles store instructions.

### Test Case

To test the sw hazard resolution, use this instruction sequence:
```assembly
ori $2, $0, 100    # $2 = 100
ori $3, $0, 50     # $3 = 50  
add $1, $2, $3     # $1 = 150 (cycle 3: EX, cycle 4: MEM, cycle 5: WB)
sw $1, 0($2)       # Memory[100] = $1 (cycle 5: MEM, needs forwarding from WB)
```

Without forwarding: Memory[100] would contain the old value of $1 (incorrect)
With forwarding: Memory[100] correctly contains 150

## References

- 实验报告.md, 作业4：实验4"课后作业1"
- Solution 1 (方案一): MEM阶段前推（推荐）
- Lines 1636-1669 of the experimental report
