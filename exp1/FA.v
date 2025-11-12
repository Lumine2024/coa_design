`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: FA
// Brief : Single-bit full adder with generate and propagate outputs.
//------------------------------------------------------------------------------
module FA (
  input  X,  //X-Input addend
  input  Y,  //Y-Input addend
  input  C,  //C-Carry input
  output F,  //F-Sum output
  output G,  //G-Carry generate
  output P   //P-Carry propagate
);

  assign F = X ^ Y ^ C;
  assign G = X & Y;
  assign P = X + Y;

endmodule
