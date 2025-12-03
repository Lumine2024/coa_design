`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: PC
// Brief : Program counter with synchronous active-low clear on negedge clock.
//------------------------------------------------------------------------------
module PC (
  input         Clk,   // Clock signal
  input         Clrn,  // Synchronous clear (active low)
  input  [31:0] PCin,  // PC input
  output [31:0] PCout  // PC output
);

  reg [31:0] PC;

  // Synchronous clear on negative clock edge
  always @(negedge Clk) begin
    if (!Clrn) PC <= 32'h00000000;
    else PC <= PCin;
  end

  assign PCout = PC;

endmodule
