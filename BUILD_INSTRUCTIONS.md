# Build Instructions for Pipeline CPU with SW Hazard Solution

## Overview
This project implements a 5-stage pipelined MIPS CPU with data hazard forwarding, including the MEM stage forwarding solution for store word (sw) hazards.

## Building with Icarus Verilog (iverilog)

### Prerequisites
```bash
sudo apt-get install iverilog
```

### Build Command
```bash
iverilog -g2012 -o ppcpu \
  exp1/Adder32.v exp1/MUX32X4.v exp1/ALU.v exp1/Adder4.v exp1/Adder16.v \
  exp1/FA.v exp1/ALUCTR.v exp1/MUX1X2.v exp1/MUX32X2.v exp1/BEXT.v exp1/CLA4.v \
  exp2/DataRAM.v exp2/Ext.v exp2/PC.v exp2/RegFiles.v exp2/InstROM.v \
  exp2/ControlUnit.v exp2/ControlUnit_main.v exp2/ControlUnit_ALU.v \
  exp2/MUX3X2.v exp2/MUX5X2.v \
  exp3/*.v \
  exp4/DetUnit.v exp4/DetUnit_load.v exp4/DetUnit_MEM.v
```

### Run Simulation
```bash
vvp ppcpu
```

## Building with Xilinx ISE

### Project Setup
1. Create a new ISE project
2. Add all source files:
   - All files from `exp1/` (except Tester_ALU.v)
   - Required files from `exp2/`: DataRAM.v, Ext.v, PC.v, RegFiles.v, InstROM.v, ControlUnit*.v, MUX*.v
   - All files from `exp3/`
   - Detection units from `exp4/`: DetUnit.v, DetUnit_load.v, DetUnit_MEM.v
3. Set `PPCPU` as the top module
4. Set `tb_PPCPU` as the testbench (for simulation)

### Synthesis
- Target device: (specify your FPGA device)
- Top module: `PPCPU`
- All .v files will be automatically included by ISE

### Simulation
- Use ISim or ModelSim
- Testbench: `exp3/tb_PPCPU.v`
- Simulation time: at least 3000ns

## Module Dependencies

```
PPCPU (top)
├── STAGE_IF
│   ├── PC
│   └── InstROM
├── REG_IF_ID
├── STAGE_ID
│   ├── RegFiles
│   └── ControlUnit
│       ├── ControlUnit_main
│       └── ControlUnit_ALU
├── REG_ID_EX
├── STAGE_EX
│   ├── ALU (from exp1)
│   ├── Ext
│   └── DetUnit (for EX-stage forwarding)
├── REG_EX_MEM
├── STAGE_MEM
│   ├── DataRAM
│   └── DetUnit_MEM (for MEM-stage sw forwarding) ← NEW
├── REG_MEM_WR
├── STAGE_WR
└── DetUnit_load (for load-use hazard detection)
```

## Verification

After building, the simulation should:
1. Run for 3000ns without errors
2. Show PC incrementing correctly
3. Execute all instructions in InstROM
4. Handle data hazards correctly (including sw hazards)

## Notes

- The sw hazard solution (DetUnit_MEM) is implemented as per Solution 1 in 实验报告.md
- All forwarding happens in hardware with zero cycle penalty
- The implementation is compatible with both iverilog and Xilinx ISE
