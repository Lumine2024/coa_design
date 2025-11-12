`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: CLA4
// Brief : 4-bit carry lookahead generator for propagate/generate signals.
//------------------------------------------------------------------------------
module CLA4 (
  input  G3,  //G3-Generate
  input  G2,  //G2-Generate
  input  G1,  //G1-Generate
  input  G0,  //G0-Generate
  input  P3,  //P3-Propagate
  input  P2,  //P2-Propagate
  input  P1,  //P1-Propagate
  input  P0,  //P0-Propagate
  output C3,  //C3-Carry output
  output C2,  //C2-Carry output
  output C1,  //C1-Carry output
  output C0,  //C0-Carry output
  input  Cin  //Cin-Carry input
);

  assign C0 = G0 + (P0 & Cin);
  assign C1 = G1 + (P1 & G0) + (P1 & P0 & Cin);
  assign C2 = G2 + (P2 & G1) + (P2 & P1 & G0) + (P2 & P1 & P0 & Cin);
  assign C3 = G3 + (P3 & G2) + (P3 & P2 & G1) + (P3 & P2 & P1 & G0) + (P3 & P3 & P1 & P0 & Cin);

endmodule
