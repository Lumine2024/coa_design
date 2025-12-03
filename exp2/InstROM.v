`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: InstROM
// Brief : Instruction memory initialized with sample program words.
//------------------------------------------------------------------------------
module InstROM (
  input  [31:0] Addr,  // Addr-Instruction address
  output [31:0] Inst   // Inst-Instruction
);

  reg [31:0] InstROM[255:0]; // InstROM-Instruction memory

  assign Inst = InstROM[Addr[9:2]];
  integer i;
  initial begin
    for (i = 0; i < 256; i = i + 1) InstROM[i] = 32'h00000000;

    InstROM[0] = 32'b00000000010000110000100000100000;
    InstROM[1] = 32'b00000000001000110010000000100010;
    InstROM[2] = 32'b00000000001010010100000000100011;
    InstROM[3] = 32'b00110100001001101000000000001010;
    InstROM[4] = 32'b00000000001001010001100000101010;
  end
  
endmodule

