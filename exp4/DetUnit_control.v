`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module: DetUnit_control
// Brief : Detects control hazards when branches or jumps are taken, requiring
//         pipeline flush of IF, ID, and EX stages.
//------------------------------------------------------------------------------
module DetUnit_control (
    input       PCSrc,      // PC source select from MEM stage (1 = branch/jump taken)
    output      flush       // Flush signal for pipeline stages IF/ID, ID/EX, EX/MEM
);

    // When PCSrc is asserted (branch or jump taken), flush the pipeline
    assign flush = PCSrc;

endmodule
