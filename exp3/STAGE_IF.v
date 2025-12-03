`timescale 1ns / 1ps

//=============================================================================
// Module: STAGE_IF
// Description: Instruction Fetch stage of the pipelined CPU
//              Fetches instructions from instruction memory and calculates PC+4
//=============================================================================
module STAGE_IF (
    input              Clk,                    // Clock signal
    input              Clrn,                   // Synchronous clear (active low)
    input              MEM_PCSrc,              // PC source select from MEM stage
    input      [31:0]  MEM_Btarg_or_Jtarg,     // Branch or jump target address
    output reg [31:0]  IFout_PC,               // Current program counter (reg -> 可复位)
    output reg [31:0]  IFout_PC4,              // PC + 4 (reg -> 可复位)
    output reg [31:0]  IFout_Inst              // Fetched instruction (reg -> 可复位)
);

    // pcin must be 32-bit (was single-bit)
    wire [31:0] pcin;
    MUX32X2 mux_pcin (
        .X1(MEM_Btarg_or_Jtarg),
        .X0(IFout_PC4),
        .S(MEM_PCSrc),
        .Y(pcin)
    );
    // 保持原有 PC 模块连接，不改接口
    wire [31:0] pc_wire;
    PC pc (
        .Clk(Clk),
        .Clrn(Clrn),
        .PCin(pcin),
        .PCout(pc_wire)
    );

    // InstROM 输出先到中间信号，由时序块在时钟上更新到 IFout_Inst
    wire [31:0] inst_data;
    // 使用寄存的 IFout_PC 的字地址作为 InstROM 索引，复位期间地址为 0
    InstROM instrom (
        .Addr(IFout_PC[6:2]),
        .Inst(inst_data)
    );

    // 在复位时初始化输出为确定值，时钟上升沿更新为真实值
    always @(posedge Clk or negedge Clrn) begin
        if (!Clrn) begin
            IFout_PC  <= 32'd0;
            IFout_PC4 <= 32'd4;    // PC + 4 在复位后也给出确定值（可视需求调整为 0）
            IFout_Inst<= 32'd0;    // 复位时用 0 作为 NOP/默认指令
        end else begin
            // 从 PC 模块读取新的 PC，并从 InstROM 读取对应指令
            IFout_PC  <= pc_wire;
            IFout_PC4 <= pc_wire + 32'd4;
            IFout_Inst<= inst_data;
        end
    end

endmodule
