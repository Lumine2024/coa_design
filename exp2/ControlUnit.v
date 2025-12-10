`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: ControlUnit
// Brief : Top-level control unit combining opcode and function decoding.
//------------------------------------------------------------------------------
module ControlUnit (
  input  [5:0] OP,    // OP-instruction opcode
  input  [5:0] func,  // func-R_type instruction function
  output       RegWr, // RegWr-register write enable
  output       ALUSrc, // ALUSrc-select ALU second operand
  output       RegDst, // RegDst-select destination register
  output       MemtoReg, // MemtoReg-select memory to register
  output       MemWr, // MemWr-memory write enable
  output       Branch, // Branch-branch instruction enable
  output       nBranch, // nBranch-branch on not equal
  output       Jump,  // Jump-jump instruction enable
  output       ExtOp, // ExtOp-select extension operation
  output [2:0] ALUctr // ALUctr-ALU control
);

  wire [2:0] ALUop;   // ALUop-OP ALU operation
  wire [2:0] ALUop_R; // ALUop_R-func ALU operation
  wire R_type;        // R_type-is R_type instruction

  ControlUnit_main U1 ( // control unit main
    .OP(OP),
    .RegWr(RegWr),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .MemtoReg(MemtoReg),
    .MemWr(MemWr),
    .Branch(Branch),
    .nBranch(nBranch),
    .Jump(Jump),
    .ExtOp(ExtOp),
    .ALUop(ALUop),
    .R_type(R_type)
  );
  ControlUnit_ALU U2 ( // control unit ALU
    .func(func),
    .ALUctr(ALUop_R)
  );
  MUX3X2 U3 ( // select ALU operation
    .X1(ALUop_R),
    .X0(ALUop),
    .S(R_type),
    .Y(ALUctr)
  );

endmodule
