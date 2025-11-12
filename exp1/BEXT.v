`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: BEXT
// Brief : Replicates a single bit to a 32-bit wide vector.
//------------------------------------------------------------------------------
module BEXT (
  input         datain,    //datain-data input
  output [31:0] dataout    //dataout-data output
);

  assign dataout = {32{datain}};

endmodule
