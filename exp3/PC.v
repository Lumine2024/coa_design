`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: PC
// Brief : Program counter with synchronous active-low clear on negedge clock.
//         Supports stalling to hold PC value when needed.
//------------------------------------------------------------------------------
module PC (
  input         Clk,   // Clock signal
  input         Clrn,  // Synchronous clear (active low)
  input         stall, // Stall signal (holds PC value)
  input  [31:0] PCin,  // PC input
  output [31:0] PCout  // PC output
);

  reg [31:0] PC;

  // Synchronous clear on negative clock edge
  always @(negedge Clk) begin
    if (!Clrn) PC <= 32'h00000000;
    else if (!stall) PC <= PCin;
    // When stall is asserted, hold the current PC value
  end

  assign PCout = PC;

endmodule
