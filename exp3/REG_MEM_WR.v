`timescale 1ns / 1ps

// MEM/WR Pipeline Register
// Passes memory data and control signals from MEM stage to WR stage
module REG_MEM_WR (
    input Clk,                          // Clock signal
    input Clrn,                         // Synchronous clear (active low)
    input [31:0] MEM_Dout,              // Data output from memory (MEM stage)
    input [31:0] MEM_ALUout,            // ALU output from MEM stage
    input [4:0] MEM_Rw,                 // Write register number from MEM stage
    input MEM_Overflow,                 // Overflow flag from MEM stage
    input MEM_MemtoReg,                 // Memory to register select from MEM stage
    input MEM_RegWr,                    // Register write enable from MEM stage
    output reg [31:0] WR_Dout,          // Data output to WR stage
    output reg [31:0] WR_ALUout,        // ALU output to WR stage
    output reg [4:0] WR_Rw,             // Write register number to WR stage
    output reg WR_Overflow,             // Overflow flag to WR stage
    output reg WR_MemtoReg,             // Memory to register select to WR stage
    output reg WR_RegWr                 // Register write enable to WR stage
);

    // Asynchronous reset and synchronous update on negative edge of clock
    always @(negedge Clk) begin
        if (!Clrn) begin
            WR_Dout     <= 32'h0;
            WR_ALUout   <= 32'h0;
            WR_Rw       <= 5'h0;
            WR_Overflow <= 1'b0;
            WR_MemtoReg <= 1'b0;
            WR_RegWr    <= 1'b0;
        end
        else begin
            WR_Dout     <= MEM_Dout;
            WR_ALUout   <= MEM_ALUout;
            WR_Rw       <= MEM_Rw;
            WR_Overflow <= MEM_Overflow;
            WR_MemtoReg <= MEM_MemtoReg;
            WR_RegWr    <= MEM_RegWr;
        end
    end

endmodule