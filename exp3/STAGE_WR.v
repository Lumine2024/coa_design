`timescale 1ns / 1ps

//=============================================================================
// Module: STAGE_WR
// Description: Write Back stage of the pipelined CPU
//              Selects register write data (memory or ALU result) and passes to ID stage
//=============================================================================
module STAGE_WR (
    input      [31:0]  WRin_Dout,              // Data memory output from MEM/WR register
    input      [31:0]  WRin_ALUout,            // ALU result from MEM/WR register
    input      [4:0]   WRin_Rw,                // Register write address from MEM/WR register
    input              WRin_Overflow,          // ALU overflow flag from MEM/WR register
    input              WRin_MemtoReg,          // Memory to register from MEM/WR register
    input              WRin_RegWr,            // Register write enable from MEM/WR register
    output     [31:0]  WRout_RegDin,           // Register write data to ID stage
    output     [4:0]   WRout_Rw,               // Register write address to ID stage
    output             WRout_RegWE             // Register write enable to ID stage
);



    // Pass through signals
    assign WRout_Rw = WRin_Rw;

endmodule
