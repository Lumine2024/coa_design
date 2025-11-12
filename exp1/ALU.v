`timescale 1ns / 1ps

// -----------------------------------------------
// Module: ALU
// Brief: 请输入文本
// -----------------------------------------------
module ALU (
    input [31: 0] A, B,
    input [2: 0] ALUctr,
    output wire [31: 0] Result,
    output wire Overflow, Z
);
    // for ALUctr module
    wire SUBctr, OVctr, SIGctr;
    wire [1: 0] OPctr;
    ALUCTR aluctr (
        .ALUctr(ALUctr),
        .SUBctr(SUBctr),
        .OVctr(OVctr),
        .SIGctr(SIGctr),
        .OPctr(OPctr)
    );

    wire [31: 0] ext_SUBctr;
    BEXT bext1 (
        .datain(SUBctr),
        .dataout(ext_SUBctr)
    );
    wire [31: 0] realB;
    assign realB = B ^ ext_SUBctr;

    // for Adder module
    wire [31: 0] F;
    wire OF, SF, CF;
    wire __ignore_for_adder__;
    Adder32 adder (
        .A(A),
        .B(realB),
        .F(F),
        .Cin(SUBctr),
        .Cout(__ignore_for_adder__),
        .ZF(Z),
        .OF(OF),
        .SF(SF),
        .CF(CF)
    );

    assign Overflow = OVctr & OF;

    wire [31: 0] orresult;
    assign orresult = A | B;

    wire SFxorOF;
    assign SFxorOF = SF ^ OF;
    wire x1;
    MUX1X2 mux1 (
        .X1(SFxorOF),
        .X0(CF),
        .S(SIGctr),
        .Y(x1)
    );
    wire [31: 0] 32h0, 32h1;
    assign 32h0 = 32'h0;
    assign 32h1 = 32'h1;
    wire [31: 0] out2;
    MUX32X2 mux2 (
        .X1(32h1),
        .X0(32h0),
        .S(x1),
        .Y(out2)
    );

    wire __ignore_for_mux3__;
    MUX32X4 mux3 (
        .X3(__ignore_for_mux3__),
        .X2(out2),
        .X1(orresult),
        .X0(F),
        .S(OPctr),
        .Y(Result)
    );

endmodule