`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: DetUnit_MEM
// Brief : Forwarding detection unit for MEM stage store operations
//         Detects when a store instruction needs data that's being written back
//         in the WB stage, enabling forwarding from WB to MEM stage.
//------------------------------------------------------------------------------
module DetUnit_MEM (
    input  [4:0] M_Rt,     // Source register Rt in the MEM stage (for sw instruction)
    input  [4:0] W_Rw,     // Destination register in the write-back stage
    input        W_RegWr,  // Register write enable in the write-back stage
    input        M_MemWr,  // Memory write enable in the MEM stage (sw instruction)
    output       forward_busB // Forwarding enable signal for busB
);

    // Forward from WB to MEM when:
    // 1. MEM stage has a store instruction (M_MemWr = 1)
    // 2. WB stage is writing to a register (W_RegWr = 1)
    // 3. The register being written in WB matches the data source in MEM (W_Rw == M_Rt)
    // 4. Not writing to register $0 (which is always 0)
    assign forward_busB = M_MemWr && W_RegWr && (W_Rw == M_Rt) && (W_Rw != 5'b0);

endmodule
