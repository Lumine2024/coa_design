`timescale 1ns / 1ps

//=============================================================================
// Module: STAGE_ID
// Description: Instruction Decode stage of the pipelined CPU
//              Decodes instructions, reads register file, generates control signals
//=============================================================================
module STAGE_ID (
    input              Clk,                    // Clock signal
    input      [31:0]  IDin_PC4,               // PC + 4 from IF/ID register
    input      [31:0]  IDin_PC,                // PC from IF/ID register
    input      [31:0]  IDin_Inst,              // Instruction from IF/ID register
    input              WR_RegWE,               // Register write enable from WR stage
    input      [4:0]   WR_Rw,                  // Register write address from WR stage
    input      [31:0]  WR_RegDin,              // Register write data from WR stage
    output     [31:0]  IDout_PC4,              // PC + 4 passed to next stage
    output     [31:0]  IDout_Jtarg,            // Jump target address
    output     [31:0]  IDout_busA,             // Register file bus A output
    output     [31:0]  IDout_busB,             // Register file bus B output
    output     [4:0]   IDout_Rt,               // Register rt field
    output     [4:0]   IDout_Rd,               // Register rd field
    output     [5:0]   IDout_func,             // Function code field
    output     [15:0]  IDout_immd,             // Immediate value field
    output             IDout_RegWr,            // Register write enable control
    output             IDout_ALUSrc,           // ALU source select control
    output             IDout_RegDst,           // Register destination select control
    output             IDout_MemtoReg,         // Memory to register control
    output             IDout_MemWr,            // Memory write enable control
    output             IDout_Branch,           // Branch control signal
    output             IDout_Jump,             // Jump control signal
    output             IDout_ExtOp,            // Extension operation control
    output             IDout_R_type,           // R-type instruction control
    output     [2:0]   IDout_ALUop             // ALU operation control
);

    // Instruction field extraction
    wire [4:0]  ID_Rt     = IDin_Inst[20:16];
    wire [4:0]  ID_Rd     = IDin_Inst[15:11];
    wire [15:0] ID_imm16  = IDin_Inst[15:0];
    wire [5:0]  ID_func   = IDin_Inst[5:0];
    wire [5: 0] id_op = IDin_Inst[31: 26];
    wire [5: 0] id_rs = IDin_Inst[25: 21];

    ControlUnit cu (
        .OP(id_op),
        .func(ID_func),
        .RegWr(IDout_RegWr),
        .ALUsrc(IDout_ALUSrc),
        .RegDst(IDout_RegDst),
        .MemToReg(IDout_MemtoReg),
        .MemWr(IDout_MemWr),
        .Branch(IDout_Branch),
        .Jump(IDout_Jump),
        .ExtOp(IDout_ExtOp),
        .ALUctr(IDout_ALUop)
    );
    assign IDout_R_type = id_op == 6'b000000;

    RegFiles regfiles (
        .CLK(Clk),
        .busW(WR_RegDin),
        .WE(WR_RegWE),
        .Rw(WR_Rw),
        .Ra(id_rs),
        .Rb(ID_Rt),
        .busA(IDout_busA),
        .busB(IDout_busB)
    );

    // Pass through signals
    assign IDout_PC4   = IDin_PC4;
    assign IDout_Rt    = ID_Rt;
    assign IDout_Rd    = ID_Rd;
    assign IDout_func  = ID_func;
    assign IDout_immd  = ID_imm16;
    assign IDout_Jtarg = { IDin_PC4[31:28], IDin_Inst[25:0], 2'b00 };

endmodule
