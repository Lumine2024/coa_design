`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: DetUnit_load
// Brief : Detects load-use hazards by stalling when EX stage load feeds ID stage.
//------------------------------------------------------------------------------
module DetUnit_load (
    input       E_MemtoReg, // Execute-stage instruction is a load (MemtoReg asserted)
    input [4:0] Rs,         // Source register Rs in the decode stage
    input [4:0] Rt,         // Source register Rt in the decode stage
    input [4:0] E_Rt,       // Destination register of the execute-stage load
    output      load_use    // Load-use hazard flag
);

    assign load_use = E_MemtoReg && ((E_Rt == Rs) || (E_Rt == Rt));

endmodule
