`timescale 1ns / 1ps

//=============================================================================
// Module: STAGE_EX
// Description: Execute stage of the pipelined CPU
//              Performs ALU operations, calculates branch target, selects register destination
//=============================================================================
module STAGE_EX (
    input              Clk,                    // Clock signal
    input      [31:0]  EXin_PC4,               // PC + 4 from ID/EX register
    input      [31:0]  EXin_Jtarg,             // Jump target from ID/EX register
    input      [31:0]  EXin_busA,              // Register bus A from ID/EX register
    input      [31:0]  EXin_busB,              // Register bus B from ID/EX register
    input      [4:0]   EXin_Rt,                // Register rt from ID/EX register
    input      [4:0]   EXin_Rd,                // Register rd from ID/EX register
    input      [5:0]   EXin_func,               // Function code from ID/EX register
    input      [15:0]  EXin_immd,               // Immediate value from ID/EX register
    input              EXin_RegWr,              // Register write enable from ID/EX register
    input              EXin_ALUSrc,            // ALU source select from ID/EX register
    input              EXin_RegDst,            // Register destination select from ID/EX register
    input              EXin_MemtoReg,          // Memory to register from ID/EX register
    input              EXin_MemWr,             // Memory write enable from ID/EX register
    input              EXin_Branch,            // Branch control from ID/EX register
    input              EXin_Jump,              // Jump control from ID/EX register
    input              EXin_ExtOp,             // Extension operation from ID/EX register
    input              EXin_R_type,            // R-type control from ID/EX register
    input      [2:0]   EXin_ALUop,              // ALU operation from ID/EX register
    output     [31:0]  EXout_Btarg,             // Branch target address
    output     [31:0]  EXout_Jtarg,             // Jump target address
    output     [31:0]  EXout_busB,              // Register bus B (for memory write)
    output     [31:0]  EXout_ALUout,           // ALU result
    output     [4:0]   EXout_Rw,                // Register write address
    output             EXout_Zero,              // ALU zero flag
    output             EXout_Overflow,          // ALU overflow flag
    output             EXout_RegWr,             // Register write enable
    output             EXout_MemtoReg,          // Memory to register
    output             EXout_MemWr,             // Memory write enable
    output             EXout_Branch,            // Branch control
    output             EXout_Jump               // Jump control
);



    // Pass through control signals
    assign EXout_Jtarg    = EXin_Jtarg;
    assign EXout_busB     = EXin_busB;
    assign EXout_RegWr    = EXin_RegWr;
    assign EXout_MemtoReg = EXin_MemtoReg;
    assign EXout_MemWr    = EXin_MemWr;
    assign EXout_Branch   = EXin_Branch;
    assign EXout_Jump     = EXin_Jump;

endmodule
