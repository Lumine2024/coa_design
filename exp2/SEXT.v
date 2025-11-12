`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: SEXT
// Brief : Sign extends a 16-bit value to 32 bits.
//------------------------------------------------------------------------------
module SEXT (
  input  [15:0] datain,   //datain-data input
  output [31:0] dataout   //dataout-data output
);

  assign dataout = {{16{datain[15]}}, datain};

endmodule
