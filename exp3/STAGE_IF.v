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

    // pcin must be 32-bit (was single-bit)
    wire [31:0] pcin;
    MUX1X2 mux_pcin (
        .X1(MEM_Btarg_or_Jtarg),
        .X0(IFout_PC4),
        .S(MEM_PCSrc),
        .Y(pcin)
    );
    PC pc (
        .Clk(Clk),
        .Clrn(Clrn),
        .PCin(pcin),
        .PCout(IFout_PC)
    );
    assign IFout_PC4 = IFout_PC + 4;

    // 使用字地址索引 InstROM，保持与 exp2 Ifetch/InstROM 的意图一致
    InstROM instrom (
        .Addr(IFout_PC),
        .Inst(IFout_Inst)
    );

endmodule
