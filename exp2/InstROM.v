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

  parameter [5:0] OP_R_type = 6'b000000;
  parameter [5:0] OP_ori = 6'b001101;
  parameter [5:0] OP_addiu = 6'b001001;
  parameter [5:0] OP_lw = 6'b100011;
  parameter [5:0] OP_sw = 6'b101011;
  parameter [5:0] OP_beq = 6'b000100;
  parameter [5:0] OP_jump = 6'b000010;
  parameter [4:0] shamt = 5'b00000;
  parameter [5:0] FUNC_add = 6'b100000;
  parameter [5:0] FUNC_sub = 6'b100010;
  parameter [5:0] FUNC_subu = 6'b100011;
  parameter [5:0] FUNC_slt = 6'b101010;
  parameter [5:0] FUNC_sltu = 6'b101011;

  integer i;
  initial begin
    for (i = 0; i < 256; i = i + 1) InstROM[i] = 32'h00000000;

    InstROM[8'h01] = {OP_lw, 5'b00000, 5'b11111, 16'h0000};
    InstROM[8'h02] = {OP_R_type, 5'b00000, 5'b11111, 5'b11110, shamt, FUNC_sub};
    InstROM[8'h03] = {OP_R_type, 5'b10000, 5'b11111, 5'b11101, shamt, FUNC_add};
    InstROM[8'h04] = {OP_R_type, 5'b00000, 5'b11101, 5'b11100, shamt, FUNC_sub};
    InstROM[8'h05] = {OP_R_type, 5'b10000, 5'b11100, 5'b11011, shamt, FUNC_add};
    InstROM[8'h06] = {OP_R_type, 5'b11111, 5'b00001, 5'b11010, shamt, FUNC_subu};
    InstROM[8'h07] = {OP_R_type, 5'b00001, 5'b11111, 5'b11001, shamt, FUNC_slt};
    InstROM[8'h08] = {OP_R_type, 5'b00001, 5'b11111, 5'b11000, shamt, FUNC_sltu};
    InstROM[8'h09] = {OP_addiu, 5'b00000, 5'b10111, 16'hab00};
    InstROM[8'h0a] = {OP_addiu, 5'b00000, 5'b10110, 16'h00cd};
    InstROM[8'h0b] = {OP_ori, 5'b10110, 5'b10101, 16'hab00};
    InstROM[8'h0c] = {OP_sw, 5'b00000, 5'b10101, 16'h001f};
    InstROM[8'h0d] = {OP_beq, 5'b10101, 5'b10100, 16'h0003};
    InstROM[8'h0e] = {OP_lw, 5'b00000, 5'b10100, 16'h001f};
    InstROM[8'h0f] = {OP_beq, 5'b10101, 5'b10100, 16'h0003};
    InstROM[8'h13] = {OP_jump, 26'h000000f};
  end

endmodule
