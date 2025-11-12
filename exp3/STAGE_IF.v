`timescale 1ns / 1ps

//=============================================================================
// Module: STAGE_IF
// Description: Instruction Fetch stage of the pipelined CPU
//              Fetches instructions from instruction memory and calculates PC+4
//=============================================================================
module STAGE_IF (
    input              Clk,                    // Clock signal
    input              Clrn,                   // Synchronous clear (active low)
    input              MEM_PCSrc,              // PC source select from MEM stage
    input      [31:0]  MEM_Btarg_or_Jtarg,     // Branch or jump target address
    output     [31:0]  IFout_PC,               // Current program counter
    output     [31:0]  IFout_PC4,              // PC + 4
    output     [31:0]  IFout_Inst              // Fetched instruction
);



endmodule
