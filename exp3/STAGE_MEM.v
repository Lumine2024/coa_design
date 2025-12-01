`timescale 1ns / 1ps

//=============================================================================
// Module: STAGE_MEM
// Description: Memory Access stage of the pipelined CPU
//              Accesses data memory, calculates PC source, passes signals to WR stage
//=============================================================================
module STAGE_MEM (
    input              Clk,                    // Clock signal
    input      [31:0]  MEMin_Btarg,            // Branch target from EX/MEM register
    input      [31:0]  MEMin_Jtarg,            // Jump target from EX/MEM register
    input      [31:0]  MEMin_busB,             // Register bus B from EX/MEM register
    input      [31:0]  MEMin_ALUout,           // ALU result from EX/MEM register
    input      [4:0]   MEMin_Rw,               // Register write address from EX/MEM register
    input              MEMin_Zero,              // ALU zero flag from EX/MEM register
    input              MEMin_Overflow,         // ALU overflow flag from EX/MEM register
    input              MEMin_RegWr,            // Register write enable from EX/MEM register
    input              MEMin_MemtoReg,         // Memory to register from EX/MEM register
    input              MEMin_MemWr,            // Memory write enable from EX/MEM register
    input              MEMin_Branch,           // Branch control from EX/MEM register
    input              MEMin_Jump,              // Jump control from EX/MEM register
    output     [31:0]  MEMout_Dout,            // Data memory output
    output     [31:0]  MEMout_ALUout,          // ALU result passed to WR stage
    output     [31:0]  MEMout_Btarg_or_Jtarg,  // Branch or jump target for IF stage
    output     [4:0]   MEMout_Rw,              // Register write address passed to WR stage
    output             MEMout_Overflow,        // ALU overflow flag passed to WR stage
    output             MEMout_MemtoReg,        // Memory to register passed to WR stage
    output             MEMout_RegWr,           // Register write enable passed to WR stage
    output             MEMout_PCSrc            // PC source select for IF stage
);

    // Data memory instance (synchronous write on negedge, asynchronous read)
    wire [31:0] mem_dout;
    DataRAM data_ram (
        .CLK(Clk),
        .WE(MEMin_MemWr),
        .DataIn(MEMin_busB),
        .Address(MEMin_ALUout),
        .DataOut(mem_dout)
    );

    // Pass through signals and compute PC source
    assign MEMout_Dout       = mem_dout;
    assign MEMout_ALUout     = MEMin_ALUout;
    assign MEMout_Btarg_or_Jtarg = MEMin_Jump ? MEMin_Jtarg : MEMin_Btarg;
    assign MEMout_Rw         = MEMin_Rw;
    assign MEMout_Overflow   = MEMin_Overflow;
    assign MEMout_MemtoReg   = MEMin_MemtoReg;
    assign MEMout_RegWr      = MEMin_RegWr;
    assign MEMout_PCSrc      = MEMin_Jump | (MEMin_Branch & MEMin_Zero);

endmodule
