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

    InstROM[0]   = 32'b00110100000000010000000000000101;             // ori $1, $0, 5
    InstROM[1]   = 32'b00110100000000100000000000000011;             // ori $2, $0, 3
    InstROM[2]   = 32'b00000000001000100001100000100000;             // add $3, $1, $2
    InstROM[3]   = 32'b00000000001000110010000000100010;             // sub $4, $1, $3
    InstROM[4]   = 32'b00000000010001000010100000101010;             // slt $5, $2, $4
  end
  
endmodule

