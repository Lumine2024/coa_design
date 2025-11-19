`timescale 1ns / 1ps

// -----------------------------------------------
// Module: MUX5X2
// Brief: Outputs one of two five-bit inputs
// -----------------------------------------------
module MUX5X2 (
    input [4: 0] X1, X0,
    input S,
    output wire [4: 0] Y
);
    assign Y = S ? X1 : X0;
endmodule