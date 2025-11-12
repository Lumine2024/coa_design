`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: DataRAM
// Brief : 32-word data memory with synchronous write and asynchronous read.
//------------------------------------------------------------------------------
module DataRAM (
  input        CLK,      // CLK-Clock
  input        WE,       // WE-Write enable
  input  [31:0] DataIn,  // DataIn-Data input
  input  [31:0] Address, // Address-Address input
  output [31:0] DataOut  // DataOut-Data output
);

  reg [31:0] RAM[31:0]; // RAM-Data memory

  always @(negedge CLK) begin
    if (WE) RAM[Address[4:0]] <= DataIn; // Write data to memory
  end

  assign DataOut = RAM[Address[4:0]]; // Read data from memory

  integer i; // Data memory initial
  initial begin
    for (i = 0; i < 32; i = i + 1) RAM[i] = 32'h80000000 + i;
  end

endmodule
