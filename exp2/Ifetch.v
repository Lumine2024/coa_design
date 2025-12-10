`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: Ifetch
// Brief : Instruction fetch stage computing next PC and fetching instruction.
//------------------------------------------------------------------------------
module Ifetch (
  input        Clk,    // Clk-Clock
  input        Clrn,   // Clrn-Active-low synchronous clear
  input        Jump,   // Jump-Jump signal
  input        Branch, // Branch-Branch signal
  input        nBranch, // nBranch-Branch on not equal signal
  input        Z,      // Z-Zero signal
  output [31:0] Inst,  // Inst-Instruction
  output [31:0] PC     // PC-Program Counter
);

  wire [31:0] PCin;     // PCin-PC input
  wire [31:0] PCout;    // PCout-PC output
  wire [31:0] PC4;      // PC4-PC+4
  wire [15:0] immd = Inst[15:0];
  wire [31:0] SEXTout;  // SEXTout-Sign Extended
  wire [31:0] Addr_Beq; // Addr_Beq-Branch address
  wire [31:0] Addr_Jump; // Addr_Jump-Jump address
  wire [31:0] Addr_NJump; // Addr_NJump-Next instruction address

  PC U1 (
    .Clk(Clk),
    .Clrn(Clrn),
    .PCin(PCin),
    .PCout(PCout)
  );
  Adder32 U2 (
    .A(PCout),
    .B(32'h4),
    .F(PC4),
    .Cin(1'b0),
    .Cout(),
    .OF(),
    .SF(),
    .ZF(),
    .CF()
  );
  SEXT U3 (
    .datain(immd),
    .dataout(SEXTout)
  );
  Adder32 U4 (
    .A(PC4),
    .B(SEXTout << 2),
    .F(Addr_Beq),
    .Cin(1'b0),
    .Cout(),
    .OF(),
    .SF(),
    .ZF(),
    .CF()
  );
  MUX32X2 U5 (
    .X1(Addr_Beq),
    .X0(PC4),
    .S(Branch & (Z ^ nBranch)),
    .Y(Addr_NJump)
  );
  MUX32X2 U6 (
    .X1(Addr_Jump),
    .X0(Addr_NJump),
    .S(Jump),
    .Y(PCin)
  );
  InstROM U7 (
    .Addr(PCout),
    .Inst(Inst)
  );

  assign Addr_Jump = {PCout[31:28], Inst[25:0], 2'b00};
  assign PC = PCout;

endmodule
