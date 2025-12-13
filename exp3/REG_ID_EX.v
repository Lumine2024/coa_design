`timescale 1ns / 1ps

// ID/EX Pipeline Register
// Passes control signals and data from ID stage to EX stage
module REG_ID_EX (
    input Clk,                                    // Clock signal
    input Clrn,                                   // Synchronous clear (active low)
    input bubble,                                 // Bubble insertion signal (inserts NOP)
    input MEM_PCSrc,                              // Branch/Jump taken signal from MEM stage
    input [31:0] ID_PC4,                         // PC + 4 from ID stage
    input [31:0] ID_Jtarg,                       // Jump target from ID stage
    input [31:0] ID_busA,                        // Register A data from ID stage
    input [31:0] ID_busB,                        // Register B data from ID stage
    input [4:0] ID_Rs,                           // Rs register number from ID stage
    input [4:0] ID_Rt,                           // Rt register number from ID stage
    input [4:0] ID_Rd,                           // Rd register number from ID stage
    input [5:0] ID_func,                         // Function code from ID stage
    input [15:0] ID_immd,                        // Immediate value from ID stage
    input ID_RegWr,                              // Register write enable from ID stage
    input ID_ALUSrc,                             // ALU source select from ID stage
    input ID_RegDst,                             // Register destination select from ID stage
    input ID_MemtoReg,                           // Memory to register select from ID stage
    input ID_MemWr,                              // Memory write enable from ID stage
    input ID_Branch,                             // Branch control from ID stage
    input ID_Jump,                               // Jump control from ID stage
    input ID_ExtOp,                              // Extension operation from ID stage
    input [2:0] ID_ALUop,                        // ALU operation code from ID stage
    input ID_R_type,                             // R-type instruction indicator from ID stage
    output reg [31:0] EX_PC4,                    // PC + 4 to EX stage
    output reg [31:0] EX_Jtarg,                  // Jump target to EX stage
    output reg [31:0] EX_busA,                   // Register A data to EX stage
    output reg [31:0] EX_busB,                   // Register B data to EX stage
    output reg [4:0] EX_Rs,                      // Rs register number to EX stage
    output reg [4:0] EX_Rt,                      // Rt register number to EX stage
    output reg [4:0] EX_Rd,                      // Rd register number to EX stage
    output reg [5:0] EX_func,                    // Function code to EX stage
    output reg [15:0] EX_immd,                   // Immediate value to EX stage
    output reg EX_RegWr,                         // Register write enable to EX stage
    output reg EX_ALUSrc,                        // ALU source select to EX stage
    output reg EX_RegDst,                        // Register destination select to EX stage
    output reg EX_MemtoReg,                      // Memory to register select to EX stage
    output reg EX_MemWr,                         // Memory write enable to EX stage
    output reg EX_Branch,                        // Branch control to EX stage
    output reg EX_Jump,                          // Jump control to EX stage
    output reg EX_ExtOp,                         // Extension operation to EX stage
    output reg [2:0] EX_ALUop,                   // ALU operation code to EX stage
    output reg EX_R_type                         // R-type instruction indicator to EX stage
);

    // Asynchronous reset and synchronous update on negative edge of clock
    always @(negedge Clk) begin
        if (!Clrn || MEM_PCSrc) begin
            // Reset or flush: clear all signals completely
            EX_PC4     <= 32'h0;
            EX_Jtarg   <= 32'h0;
            EX_busA    <= 32'h0;
            EX_busB    <= 32'h0;
            EX_Rs      <= 5'h0;
            EX_Rt      <= 5'h0;
            EX_Rd      <= 5'h0;
            EX_func    <= 6'h0;
            EX_immd    <= 16'h0;
            EX_ALUop   <= 3'h0;
            EX_RegWr   <= 1'b0;
            EX_ALUSrc  <= 1'b0;
            EX_RegDst  <= 1'b0;
            EX_MemtoReg <= 1'b0;
            EX_MemWr   <= 1'b0;
            EX_Branch  <= 1'b0;
            EX_Jump    <= 1'b0;
            EX_ExtOp   <= 1'b0;
            EX_R_type  <= 1'b0;
        end
        else if (bubble) begin
            // Load-use stall: insert NOP but preserve data for forwarding
            EX_PC4     <= ID_PC4;
            EX_Jtarg   <= ID_Jtarg;
            EX_busA    <= ID_busA;
            EX_busB    <= ID_busB;
            EX_Rs      <= ID_Rs;
            EX_Rt      <= ID_Rt;
            EX_Rd      <= ID_Rd;
            EX_func    <= ID_func;
            EX_immd    <= ID_immd;
            EX_ALUop   <= ID_ALUop;
            EX_RegWr   <= 1'b0;  // Disable writes
            EX_ALUSrc  <= ID_ALUSrc;
            EX_RegDst  <= ID_RegDst;
            EX_MemtoReg <= 1'b0;
            EX_MemWr   <= 1'b0;
            EX_Branch  <= 1'b0;
            EX_Jump    <= 1'b0;
            EX_ExtOp   <= ID_ExtOp;
            EX_R_type  <= ID_R_type;
        end
        else begin
            // Normal operation: pass through all signals
            EX_PC4     <= ID_PC4;
            EX_Jtarg   <= ID_Jtarg;
            EX_busA    <= ID_busA;
            EX_busB    <= ID_busB;
            EX_Rs      <= ID_Rs;
            EX_Rt      <= ID_Rt;
            EX_Rd      <= ID_Rd;
            EX_func    <= ID_func;
            EX_immd    <= ID_immd;
            EX_ALUop   <= ID_ALUop;
            EX_RegWr   <= ID_RegWr;
            EX_ALUSrc  <= ID_ALUSrc;
            EX_RegDst  <= ID_RegDst;
            EX_MemtoReg <= ID_MemtoReg;
            EX_MemWr   <= ID_MemWr;
            EX_Branch  <= ID_Branch;
            EX_Jump    <= ID_Jump;
            EX_ExtOp   <= ID_ExtOp;
            EX_R_type  <= ID_R_type;
        end
    end

endmodule