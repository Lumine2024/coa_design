`timescale 1ns / 1ps

// IF/ID Pipeline Register
// Passes PC+4, PC, and instruction from IF stage to ID stage
module REG_IF_ID (
    input Clk,                        // Clock signal
    input Clrn,                       // Synchronous clear (active low)
    input stall,                      // Stall signal (holds register values)
    input MEM_PCSrc,                  // Branch/Jump taken signal from MEM stage
    input [31:0] IF_PC4,              // PC + 4 from IF stage
    input [31:0] IF_PC,               // PC from IF stage
    input [31:0] IF_Inst,             // Instruction from IF stage
    output reg [31:0] ID_PC4,         // PC + 4 to ID stage
    output reg [31:0] ID_PC,          // PC to ID stage
    output reg [31:0] ID_Inst         // Instruction to ID stage
);

    // Asynchronous reset and synchronous update on negative edge of clock
    always @(negedge Clk) begin
        if (!Clrn || MEM_PCSrc) begin
            // Reset or flush due to control hazard (branch/jump taken)
            ID_PC4  <= 32'h0;
            ID_PC   <= 32'h0;
            ID_Inst <= 32'h0;
        end
        else if (!stall) begin
            ID_PC4  <= IF_PC4;
            ID_PC   <= IF_PC;
            ID_Inst <= IF_Inst;
        end
        // When stall is asserted, hold the current values (no update)
    end

endmodule