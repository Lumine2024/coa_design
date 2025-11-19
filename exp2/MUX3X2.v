`timescale 1ns / 1ps

// -----------------------------------------------
// Module: MUX3X2
// Brief: Outputs one of two three-bit inputs
// -----------------------------------------------
module MUX3X2 (
    input [2:0] X1, X0,
    input S,
    output wire [2:0] Y
);
    assign Y = S ? X1 : X0;
endmodule