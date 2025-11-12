`timescale 1ns / 1ps

// -----------------------------------------------
// Module: MUX32X2
// Brief: Outputs one of two 32-bits inputs
// -----------------------------------------------
module MUX32X2 (
    input [31: 0] X1, X0,
    input S,
    output wire [31: 0] Y
);
    assign Y = S ? X1 : X0;
endmodule