`timescale 1ns / 1ps

// -----------------------------------------------
// Module: MUX32X4
// Brief: Outputs one of four 32-bits inputs
// -----------------------------------------------
module MUX32X4 (
    input [31: 0] X3, X2, X1, X0,
    input [1: 0] S,
    output wire [31: 0] Y
);
    assign Y = S == 2'b11 ? X3 :
               S == 2'b10 ? X2 :
               S == 2'b01 ? X1 :
                            X0;
endmodule