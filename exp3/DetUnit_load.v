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

    // Detect load-use hazard: load in EX stage feeds ID stage
    // Don't detect hazard if destination is $0 or if neither source reads it
    assign load_use = E_MemtoReg && (E_Rt != 5'd0) && 
                      ((E_Rt == Rs && Rs != 5'd0) || (E_Rt == Rt && Rt != 5'd0));

endmodule
