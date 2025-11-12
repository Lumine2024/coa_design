`timescale 1ns / 1ps

// -----------------------------------------------
// Module: MUX1X2
// Brief: Outputs one of two one-bit inputs
// -----------------------------------------------
module MUX1X2 (
    input X1, X0,
    input S,
    output wire Y
);
    assign Y = S ? X1 : X0;
endmodule