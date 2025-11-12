`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: Ext
// Brief : Sign or zero extends a 16-bit immediate to 32 bits.
//------------------------------------------------------------------------------
module Ext (
  input  [15:0] imm16,  //imm16-16-bit input
  input         ExtOp,  //ExtOp-1:Sign extension, 0:Zero extension
  output [31:0] Extout  //Extout-Sign extended 32-bit output
);

  assign Extout = ExtOp ? {{16{imm16[15]}}, imm16} : {16'h0000, imm16};

endmodule
