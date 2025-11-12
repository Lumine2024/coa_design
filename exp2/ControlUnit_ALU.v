`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: ControlUnit_ALU
// Brief : Derives ALU control signals from R-type function field.
//------------------------------------------------------------------------------
module ControlUnit_ALU (
  input  [5:0] func,   //func-R_type instruction function
  output [2:0] ALUctr  //ALUctr-ALU control
);

  assign ALUctr[2] = !func[2] & func[1];
  assign ALUctr[1] = func[3] & !func[2] & func[1];
  assign ALUctr[0] = !func[3] & !func[2] & !func[0] | !func[2] & func[1] & !func[0];

endmodule
