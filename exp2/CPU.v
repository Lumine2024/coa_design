`timescale 1ns / 1ps

// -----------------------------------------------
// Module: CPU
// Brief: 请输入文本
// -----------------------------------------------
module CPU (
    input Clk, Clrn,
    output wire [31: 0] PC, Inst, R
);
    wire RegWr, ALUSrc, RegDst, MemToReg, MemWr, Branch, nBranch, Jump, ExtOp, ALU_Z;
    Ifetch ifetch (
        .Clk(Clk),
        .Clrn(Clrn),
        .Jump(Jump),
        .Branch(Branch),
        .nBranch(nBranch),
        .Z(ALU_Z),
        .Inst(Inst),
        .PC(PC)
    );

    wire [5: 0] op;
    wire [4: 0] rd, rs, rt, shamt;
    wire [5: 0] func;
    wire [15: 0] imm;
    wire [2: 0] ALUctr;
    assign op = Inst[31: 26];
    assign rs = Inst[25: 21];
    assign rt = Inst[20: 16];
    assign rd = Inst[15: 11];
    assign shamt = Inst[10: 6];
    assign func = Inst[5: 0];
    assign imm = Inst[15: 0];
    ControlUnit cunit (
        .OP(op),
        .func(func),
        .RegWr(RegWr),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .MemtoReg(MemToReg),
        .MemWr(MemWr),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jump(Jump),
        .ExtOp(ExtOp),
        .ALUctr(ALUctr)
    );

    wire [31: 0] alu_A, alu_B;
    wire alu_O;
    ALU alu (
        .A(alu_A),
        .B(alu_B),
        .ALUctr(ALUctr),
        .Result(R),
        .Overflow(alu_O),
        .Z(ALU_Z)
    );

    wire [31: 0] busA, busB, busW;
    assign alu_A = busA;
    wire [31: 0] imm32;
    Ext ext (
        .imm16(imm),
        .ExtOp(ExtOp),
        .Extout(imm32)
    );

    MUX32X2 mux_alusrc (
        .X1(imm32),
        .X0(busB),
        .S(ALUSrc),
        .Y(alu_B)
    );

    wire [31: 0] dout;
    DataRAM dara_ram (
        .CLK(Clk),
        .WE(MemWr),
        .DataIn(busB),
        .Address(R),
        .DataOut(dout)
    );

    MUX32X2 mux_busW (
        .X1(dout),
        .X0(R),
        .S(MemToReg),
        .Y(busW)
    );

    wire regwe;
    assign regwe = ~alu_O & RegWr;

    wire [4: 0] regdst_;
    MUX5X2 mux_regdst (
        .X1(rd), 
        .X0(rt),
        .S(RegDst),
        .Y(regdst_)
    );

    RegFiles regf (
        .CLK(Clk),
        .busW(busW),
        .WE(regwe),
        .Rw(regdst_),
        .Ra(rs),
        .Rb(rt),
        .busA(busA),
        .busB(busB)
    );
endmodule

// ERROR:NgdBuild:605 - logical root block 'Tester_ALU' with type 'Tester_ALU' is
// unexpanded. Symbol 'Tester_ALU' is not supported in target 'artix7'.