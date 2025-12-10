`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: RegFiles
// Brief : 32x32 general-purpose register file with two read ports and one write port.
//------------------------------------------------------------------------------
module RegFiles (
  input        CLK,    // CLK-Clock
  input  [31:0] busW,  // busW-Write data
  input        WE,     // WE-Write enable
  input  [4:0]  Rw,    // Rw-Write address
  input  [4:0]  Ra,    // Ra-Read address
  input  [4:0]  Rb,    // Rb-Read address
  output [31:0] busA,  // busA-Read data
  output [31:0] busB   // busB-Read data
);

  reg [31:0] RegFiles[31:0]; // Register file

  always @(negedge CLK) begin
    if (WE && Rw != 5'b00000) RegFiles[Rw] <= busW; // Write data to register
  end

  assign busA = RegFiles[Ra];
  assign busB = RegFiles[Rb];

  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) RegFiles[i] = 0;
  end

endmodule
