`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: ALUCTR
// Brief : ALU control decoder producing operation selects and flag controls.
//------------------------------------------------------------------------------
module ALUCTR (
  input  [2:0] ALUctr, //ALUctr-ALU control
  output       SUBctr, //SUBctr-SUB control
  output [1:0] OPctr,  //OPctr-OP control
  output       OVctr,  //OVctr-OV control
  output       SIGctr  //SIGctr-SIG control
);

  // Redesigned ALU control mapping:
  // ALUctr → Operation → OPctr
  // 000 → AND → 00
  // 001 → OR → 01
  // 010 → ADD → 10
  // 110 → SUB → 10
  // 111 → SLT → 11

  assign SUBctr  = ALUctr[2];
  assign OPctr[1] = ALUctr[1];
  assign OPctr[0] = ALUctr[0];
  assign OVctr   = !ALUctr[1] & ALUctr[0];
  assign SIGctr  = ALUctr[0];

endmodule
