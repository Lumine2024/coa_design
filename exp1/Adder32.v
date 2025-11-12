`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: Adder32
// Brief : 32-bit adder with condition flag outputs based on 16-bit stages.
//------------------------------------------------------------------------------
module Adder32 (
  input  [31:0] A,     //A-32-bit input
  input  [31:0] B,     //B-32-bit input
  output [31:0] F,     //F-32-bit output
  input         Cin,   //Cin-Carry input
  output        Cout,  //Cout-Carry output
  output        OF,    //OF-Overflow
  output        SF,    //SF-Sign
  output        ZF,    //ZF-Zero
  output        CF     //CF-Carry/Borrow
);

  wire Gx1, Gx0, Px1, Px0;
  wire C15, C31, C30;

  Adder16 LW (
    .A(A[15:0]),
    .B(B[15:0]),
    .Cin(Cin),
    .F(F[15:0]),
    .Px(Px0),
    .Gx(Gx0),
    .C14()
  );
  Adder16 HW (
    .A(A[31:16]),
    .B(B[31:16]),
    .Cin(C15),
    .F(F[31:16]),
    .Px(Px1),
    .Gx(Gx1),
    .C14(C30)
  );

  assign C15  = Gx0 + (Px0 & Cin);
  assign C31  = Gx1 + (Px1 & Gx0) + (Px1 & Px0 & Cin);
  assign Cout = C31;
  assign OF   = C31 ^ C30;
  assign SF   = F[31];
  assign ZF   = ~|F;
  assign CF   = Cout ^ Cin;

endmodule
