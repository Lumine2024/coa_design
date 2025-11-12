`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: DetUnit
// Brief : Forwarding control for ALU operands in the execute stage to
//         resolve data hazards using MEM/WB pipeline results.
//------------------------------------------------------------------------------
module DetUnit (
    input  [4:0] E_Rs,     // Source register Rs in the execute stage
    input  [4:0] E_Rt,     // Source register Rt in the execute stage
    input        E_ALUSrc, // ALU operand B selects immediate when asserted
    input  [4:0] M_Rw,     // Destination register in the memory stage
    input  [4:0] W_Rw,     // Destination register in the write-back stage
    input        M_RegWr,  // Register write enable in the memory stage
    input        W_RegWr,  // Register write enable in the write-back stage
    output [1:0] ALUSrcA,  // Forwarding select for ALU operand A
    output [1:0] ALUSrcB   // Forwarding select for ALU operand B
);

    // Forwarding conditions from memory stage to operand A and B
    wire C1A = M_RegWr && (M_Rw == E_Rs);
    wire C1B = M_RegWr && (M_Rw == E_Rt);

    // Forwarding conditions from write-back stage to operand A and B
    wire C2A = W_RegWr && (W_Rw == E_Rs);
    wire C2B = W_RegWr && (W_Rw == E_Rt);

    // Select forwarding path for ALU operand A
    assign ALUSrcA = C1A ? 2'b01 : C2A ? 2'b10 : 2'b00;

    // Select forwarding path for ALU operand B
    assign ALUSrcB = E_ALUSrc ? 2'b11 : C1B ? 2'b01 : C2B ? 2'b10 : 2'b00;

endmodule
