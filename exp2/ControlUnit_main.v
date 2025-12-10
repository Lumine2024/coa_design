`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: ControlUnit_main
// Brief : Main control decoder producing core control signals from opcode.
//------------------------------------------------------------------------------
module ControlUnit_main (
  input  [5:0] OP,     // OP-instruction opcode
  output       RegWr,  // RegWr-register write enable
  output       ALUSrc, // ALUSrc-select ALU second operand
  output       RegDst, // RegDst-select destination register
  output       MemtoReg, // MemtoReg-select memory to register
  output       MemWr,  // MemWr-memory write enable
  output       Branch, // Branch-branch instruction enable
  output       nBranch, // nBranch-branch on not equal
  output       Jump,   // Jump-jump instruction enable
  output       ExtOp,  // ExtOp-select extension operation
  output [2:0] ALUop,  // ALUop-ALU operation for OP
  output       R_type  // R_type-is R_type instruction
);

  wire ori   = !OP[5] & !OP[4] & OP[3] & OP[2] & !OP[1] & OP[0];   // ori-OP=6'b001101
  wire addiu = !OP[5] & !OP[4] & OP[3] & !OP[2] & !OP[1] & OP[0];  // addiu-OP=6'b001001
  wire lw    = OP[5] & !OP[4] & !OP[3] & !OP[2] & OP[1] & OP[0];   // lw-OP=6'b100011
  wire sw    = OP[5] & !OP[4] & OP[3] & !OP[2] & OP[1] & OP[0];    // sw-OP=6'b101011
  wire beq   = !OP[5] & !OP[4] & !OP[3] & OP[2] & !OP[1] & !OP[0]; // beq-OP=6'b000100
  wire bne   = !OP[5] & !OP[4] & !OP[3] & OP[2] & !OP[1] & OP[0];  // bne-OP=6'b000101
  wire jump  = !OP[5] & !OP[4] & !OP[3] & !OP[2] & OP[1] & !OP[0]; // jump-OP=6'b000010

  assign RegWr    = R_type | ori | addiu | lw;
  assign ALUSrc   = ori | addiu | lw | sw;
  assign RegDst   = R_type;
  assign MemtoReg = lw;
  assign MemWr    = sw;
  assign Branch   = beq | bne;
  assign nBranch  = bne;
  assign Jump     = jump;
  assign ExtOp    = addiu | lw | sw;
  assign ALUop[0] = R_type;
  assign ALUop[1] = ori;
  assign ALUop[2] = beq | bne;
  assign R_type   = !OP[5] & !OP[4] & !OP[3] & !OP[2] & !OP[1] & !OP[0];

endmodule
