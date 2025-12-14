`timescale 1ns / 1ps

// EX/MEM Pipeline Register
// Passes ALU results and control signals from EX stage to MEM stage
module REG_EX_MEM (
    input Clk,                          // Clock signal
    input Clrn,                         // Synchronous clear (active low)
    input MEM_PCSrc,                    // Branch/Jump taken signal from MEM stage
    input [31:0] EX_Btarg,              // Branch target from EX stage
    input [31:0] EX_Jtarg,              // Jump target from EX stage
    input [31:0] EX_busB,               // Register B data from EX stage
    input [31:0] EX_ALUout,             // ALU output from EX stage
    input [4:0] EX_Rw,                  // Write register number from EX stage
    input [4:0] EX_Rt,                  // Source register Rt from EX stage (for sw forwarding)
    input EX_Zero,                      // Zero flag from EX stage
    input EX_Overflow,                  // Overflow flag from EX stage
    input EX_RegWr,                     // Register write enable from EX stage
    input EX_MemtoReg,                  // Memory to register select from EX stage
    input EX_MemWr,                     // Memory write enable from EX stage
    input EX_Branch,                    // Branch control from EX stage
    input EX_Jump,                      // Jump control from EX stage
    output reg [31:0] MEM_Btarg,        // Branch target to MEM stage
    output reg [31:0] MEM_Jtarg,        // Jump target to MEM stage
    output reg [31:0] MEM_busB,         // Register B data to MEM stage
    output reg [31:0] MEM_ALUout,       // ALU output to MEM stage
    output reg [4:0] MEM_Rw,            // Write register number to MEM stage
    output reg [4:0] MEM_Rt,            // Source register Rt to MEM stage (for sw forwarding)
    output reg MEM_Zero,                // Zero flag to MEM stage
    output reg MEM_Overflow,            // Overflow flag to MEM stage
    output reg MEM_RegWr,               // Register write enable to MEM stage
    output reg MEM_MemtoReg,            // Memory to register select to MEM stage
    output reg MEM_MemWr,               // Memory write enable to MEM stage
    output reg MEM_Branch,              // Branch control to MEM stage
    output reg MEM_Jump                 // Jump control to MEM stage
);

    // Asynchronous reset and synchronous update on negative edge of clock
    always @(negedge Clk) begin
        if (!Clrn || MEM_PCSrc) begin
            // Reset or flush due to control hazard - clear all signals
            MEM_Btarg   <= 32'h0;
            MEM_Jtarg   <= 32'h0;
            MEM_busB    <= 32'h0;
            MEM_ALUout  <= 32'h0;
            MEM_Rw      <= 5'h0;
            MEM_Rt      <= 5'h0;
            MEM_Zero    <= 1'b0;
            MEM_Overflow <= 1'b0;
            MEM_RegWr   <= 1'b0;
            MEM_MemtoReg <= 1'b0;
            MEM_MemWr   <= 1'b0;
            MEM_Branch  <= 1'b0;
            MEM_Jump    <= 1'b0;
        end
        else begin
            MEM_Btarg   <= EX_Btarg;
            MEM_Jtarg   <= EX_Jtarg;
            MEM_busB    <= EX_busB;
            MEM_ALUout  <= EX_ALUout;
            MEM_Rw      <= EX_Rw;
            MEM_Rt      <= EX_Rt;
            MEM_Zero    <= EX_Zero;
            MEM_Overflow <= EX_Overflow;
            MEM_RegWr   <= EX_RegWr;
            MEM_MemtoReg <= EX_MemtoReg;
            MEM_MemWr   <= EX_MemWr;
            MEM_Branch  <= EX_Branch;
            MEM_Jump    <= EX_Jump;
        end
    end

endmodule