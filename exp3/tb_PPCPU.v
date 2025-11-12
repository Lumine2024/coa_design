`timescale 1ns / 1ps

// Testbench for PPCPU (Pipelined CPU)
// Uses synchronous active-low clear to initialize pipeline state
module tb_PPCPU;

    reg Clk;
    reg Clrn;
    wire [31:0] out_IF_PC;
    wire [31:0] out_IF_Inst;
    wire [31:0] out_ID_Inst;
    wire [31:0] out_EX_ALUout;
    wire [31:0] out_MEM_ALUout;
    wire [31:0] out_WR_ALUout;

    PPCPU uut (
        .Clk(Clk),
        .Clrn(Clrn),
        .out_IF_PC(out_IF_PC),
        .out_IF_Inst(out_IF_Inst),
        .out_ID_Inst(out_ID_Inst),
        .out_EX_ALUout(out_EX_ALUout),
        .out_MEM_ALUout(out_MEM_ALUout),
        .out_WR_ALUout(out_WR_ALUout)
    );

    // Clock generation
    initial begin
        Clk = 1;
    end

    // Clear sequence
    // Drive clear low at start, then release after a few clock cycles
    initial begin
        Clrn = 1'b0;           // Assert clear (active low)
        #100;                  // Wait 100ns (10 clock periods)
        Clrn = 1'b1;           // Release clear
        #3000;                   // Run simulation for additional time
        $finish;
    end

    always #50 Clk = ~Clk;

endmodule