`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: ControlUnit_ALU
// Brief : Derives ALU control signals from R-type function field.
//------------------------------------------------------------------------------
module ControlUnit_ALU (
  input  [5:0] func,   //func-R_type instruction function
  output [2:0] ALUctr  //ALUctr-ALU control
);

  // Redesigned to properly support AND, OR, ADD, SUB, SLT
  // AND: 100100 → ALUctr = 000
  // OR:  100101 → ALUctr = 001
  // ADD: 100000 → ALUctr = 010
  // SUB: 100010 → ALUctr = 110
  // SLT: 101010 → ALUctr = 111
  
  assign ALUctr[2] = func[1];
  assign ALUctr[1] = (!func[1] & !func[2]) | (func[1] & !func[0]);
  assign ALUctr[0] = func[0] | func[3];

endmodule
