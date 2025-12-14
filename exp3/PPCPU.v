`timescale 1ns / 1ps

//=============================================================================
// Module: PPCPU
// Description: 5-stage pipelined CPU top module
// Pipeline stages: IF -> ID -> EX -> MEM -> WR
//=============================================================================
module PPCPU (
    input Clk,
    input Clrn,
    output [31:0] out_IF_PC,  // Program counter from IF stage  
    output [31:0] out_IF_Inst,  // Instruction from IF stage
    output [31:0] out_ID_Inst,  // Instruction from ID stage
    output [31:0] out_EX_ALUout,  // ALU result from EX stage
    output [31:0] out_MEM_ALUout,  // ALU result from MEM stage
    output [31:0] out_WR_ALUout  // ALU result from WR stage
);

  //-------------------------------------------------------------------------
  // IF Stage Output Signals
  //-------------------------------------------------------------------------
  wire [31:0] IFout_PC;  // Program counter from IF stage
  wire [31:0] IFout_PC4;  // PC + 4 from IF stage
  wire [31:0] IFout_Inst;  // Instruction from IF stage

  //-------------------------------------------------------------------------
  // IF/ID Pipeline Register Output Signals
  //-------------------------------------------------------------------------
  wire [31:0] ID_PC4;  // PC + 4 passed to ID stage
  wire [31:0] ID_PC;  // PC passed to ID stage
  wire [31:0] ID_Inst;  // Instruction passed to ID stage

  //-------------------------------------------------------------------------
  // ID Stage Output Signals
  //-------------------------------------------------------------------------
  wire [31:0] IDout_PC4;  // PC + 4 from ID stage
  wire [31:0] IDout_Jtarg;  // Jump target address from ID stage
  wire [31:0] IDout_busA;  // Register file bus A output
  wire [31:0] IDout_busB;  // Register file bus B output
  wire [ 4:0] IDout_Rs;  // Register rs field
  wire [ 4:0] IDout_Rt;  // Register rt field
  wire [ 4:0] IDout_Rd;  // Register rd field
  wire [ 5:0] IDout_func;  // Function code field
  wire [15:0] IDout_immd;  // Immediate value field
  wire        IDout_RegWr;  // Register write enable control signal
  wire        IDout_ALUSrc;  // ALU source select control signal
  wire        IDout_RegDst;  // Register destination select control signal
  wire        IDout_MemtoReg;  // Memory to register control signal
  wire        IDout_MemWr;  // Memory write enable control signal
  wire        IDout_Branch;  // Branch control signal
  wire        IDout_Jump;  // Jump control signal
  wire        IDout_ExtOp;  // Extension operation control signal
  wire        IDout_R_type;  // R-type instruction control signal
  wire [ 2:0] IDout_ALUop;  // ALU operation control signal

  //-------------------------------------------------------------------------
  // ID/EX Pipeline Register Output Signals
  //-------------------------------------------------------------------------
  wire [31:0] EX_PC4;  // PC + 4 passed to EX stage
  wire [31:0] EX_Jtarg;  // Jump target passed to EX stage
  wire [31:0] EX_busA;  // Register bus A passed to EX stage
  wire [31:0] EX_busB;  // Register bus B passed to EX stage
  wire [ 4:0] EX_Rs;  // Register rs passed to EX stage
  wire [ 4:0] EX_Rt;  // Register rt passed to EX stage
  wire [ 4:0] EX_Rd;  // Register rd passed to EX stage
  wire [ 5:0] EX_func;  // Function code passed to EX stage
  wire [15:0] EX_immd;  // Immediate value passed to EX stage
  wire        EX_RegWr;  // Register write enable passed to EX stage
  wire        EX_ALUSrc;  // ALU source select passed to EX stage
  wire        EX_RegDst;  // Register destination select passed to EX stage
  wire        EX_MemtoReg;  // Memory to register passed to EX stage
  wire        EX_MemWr;  // Memory write enable passed to EX stage
  wire        EX_Branch;  // Branch control passed to EX stage
  wire        EX_Jump;  // Jump control passed to EX stage
  wire        EX_ExtOp;  // Extension operation passed to EX stage
  wire        EX_R_type;  // R-type control passed to EX stage
  wire [ 2:0] EX_ALUop;  // ALU operation passed to EX stage

  //-------------------------------------------------------------------------
  // EX Stage Output Signals
  //-------------------------------------------------------------------------
  wire [31:0] EXout_Btarg;  // Branch target address from EX stage
  wire [31:0] EXout_Jtarg;  // Jump target address from EX stage
  wire [31:0] EXout_busB;  // Register bus B from EX stage
  wire [31:0] EXout_ALUout;  // ALU result from EX stage
  wire [ 4:0] EXout_Rw;  // Register write address from EX stage
  wire        EXout_Zero;  // ALU zero flag from EX stage
  wire        EXout_Overflow;  // ALU overflow flag from EX stage
  wire        EXout_RegWr;  // Register write enable from EX stage
  wire        EXout_MemtoReg;  // Memory to register from EX stage
  wire        EXout_MemWr;  // Memory write enable from EX stage
  wire        EXout_Branch;  // Branch control from EX stage
  wire        EXout_Jump;  // Jump control from EX stage

  //-------------------------------------------------------------------------
  // EX/MEM Pipeline Register Output Signals
  //-------------------------------------------------------------------------
  wire [31:0] MEM_Btarg;  // Branch target passed to MEM stage
  wire [31:0] MEM_Jtarg;  // Jump target passed to MEM stage
  wire [31:0] MEM_busB;  // Register bus B passed to MEM stage
  wire [31:0] MEM_ALUout;  // ALU result passed to MEM stage
  wire [ 4:0] MEM_Rw;  // Register write address passed to MEM stage
  wire [ 4:0] MEM_Rt;  // Source register Rt passed to MEM stage (for sw forwarding)
  wire        MEM_Overflow;  // ALU overflow flag passed to MEM stage
  wire        MEM_Zero;  // ALU zero flag passed to MEM stage   
  wire        MEM_RegWr;  // Register write enable passed to MEM stage
  wire        MEM_MemtoReg;  // Memory to register passed to MEM stage
  wire        MEM_MemWr;  // Memory write enable passed to MEM stage
  wire        MEM_Branch;  // Branch control passed to MEM stage
  wire        MEM_Jump;  // Jump control passed to MEM stage

  //-------------------------------------------------------------------------
  // MEM Stage Output Signals
  //-------------------------------------------------------------------------
  wire [31:0] MEMout_Dout;  // Data memory output from MEM stage
  wire [31:0] MEMout_ALUout;  // ALU result from MEM stage
  wire [31:0] MEMout_Btarg_or_Jtarg;  // Branch or jump target from MEM stage
  wire [ 4:0] MEMout_Rw;  // Register write address from MEM stage
  wire        MEMout_Overflow;  // ALU overflow flag from MEM stage
  wire        MEMout_MemtoReg;  // Memory to register from MEM stage
  wire        MEMout_RegWr;  // Register write enable from MEM stage
  wire        MEMout_PCSrc;  // PC source select for IF stage

  //-------------------------------------------------------------------------
  // MEM/WR Pipeline Register Output Signals
  //-------------------------------------------------------------------------
  wire [31:0] WR_Dout;  // Data memory output passed to WR stage
  wire [31:0] WR_ALUout;  // ALU result passed to WR stage
  wire [ 4:0] WR_Rw;  // Register write address passed to WR stage
  wire        WR_Overflow;  // ALU overflow flag passed to WR stage
  wire        WR_MemtoReg;  // Memory to register passed to WR stage
  wire        WR_RegWr;  // Register write enable passed to WR stage

  //-------------------------------------------------------------------------
  // WR Stage Output Signals (feedback to ID stage)
  //-------------------------------------------------------------------------
  wire [31:0] WRout_RegDin;  // Register write data to ID stage
  wire [ 4:0] WRout_Rw;  // Register write address to ID stage
  wire        WRout_RegWE;  // Register write enable to ID stage

  //-------------------------------------------------------------------------
  // Hazard Detection Signals
  //-------------------------------------------------------------------------
  wire load_use_stall;  // Load-use hazard detection signal

  //-------------------------------------------------------------------------
  // Load-use hazard detection unit
  //-------------------------------------------------------------------------
  DetUnit_load load_hazard_detector (
      .E_MemtoReg(EX_MemtoReg),
      .Rs(ID_Inst[25:21]),
      .Rt(ID_Inst[20:16]),
      .E_Rt(EX_Rt),
      .load_use(load_use_stall)
  );

  //-------------------------------------------------------------------------
  // Module Instantiations
  //-------------------------------------------------------------------------

  // IF Stage: Instruction Fetch
  STAGE_IF IF_Stage (
      .Clk(Clk),
      .Clrn(Clrn),
      .stall(load_use_stall),
      .MEM_PCSrc(MEMout_PCSrc),
      .MEM_Btarg_or_Jtarg(MEMout_Btarg_or_Jtarg),
      .IFout_PC(IFout_PC),
      .IFout_PC4(IFout_PC4),
      .IFout_Inst(IFout_Inst)
  );

  // IF/ID Pipeline Register
  REG_IF_ID IF_ID_Reg (
      .Clk(Clk),
      .Clrn(Clrn),
      .stall(load_use_stall),
      .MEM_PCSrc(MEMout_PCSrc),
      .IF_PC4(IFout_PC4),
      .IF_PC(IFout_PC),
      .IF_Inst(IFout_Inst),
      .ID_PC4(ID_PC4),
      .ID_PC(ID_PC),
      .ID_Inst(ID_Inst)
  );

  // ID Stage: Instruction Decode
  STAGE_ID ID_Stage (
      .Clk(Clk),
      .IDin_PC4(ID_PC4),
      .IDin_PC(ID_PC),
      .IDin_Inst(ID_Inst),
      .WR_RegWE(WRout_RegWE),
      .WR_Rw(WRout_Rw),
      .WR_RegDin(WRout_RegDin),
      .IDout_PC4(IDout_PC4),
      .IDout_Jtarg(IDout_Jtarg),
      .IDout_busA(IDout_busA),
      .IDout_busB(IDout_busB),
      .IDout_Rs(IDout_Rs),
      .IDout_Rt(IDout_Rt),
      .IDout_Rd(IDout_Rd),
      .IDout_func(IDout_func),
      .IDout_immd(IDout_immd),
      .IDout_RegWr(IDout_RegWr),
      .IDout_ALUSrc(IDout_ALUSrc),
      .IDout_RegDst(IDout_RegDst),
      .IDout_MemtoReg(IDout_MemtoReg),
      .IDout_MemWr(IDout_MemWr),
      .IDout_Branch(IDout_Branch),
      .IDout_Jump(IDout_Jump),
      .IDout_ExtOp(IDout_ExtOp),
      .IDout_R_type(IDout_R_type),
      .IDout_ALUop(IDout_ALUop)
  );

  // ID/EX Pipeline Register
  REG_ID_EX ID_EX_Reg (
      .Clk(Clk),
      .Clrn(Clrn),
      .bubble(load_use_stall),
      .MEM_PCSrc(MEMout_PCSrc),
      .ID_PC4(IDout_PC4),
      .ID_Jtarg(IDout_Jtarg),
      .ID_busA(IDout_busA),
      .ID_busB(IDout_busB),
      .ID_Rs(IDout_Rs),
      .ID_Rt(IDout_Rt),
      .ID_Rd(IDout_Rd),
      .ID_func(IDout_func),
      .ID_immd(IDout_immd),
      .ID_RegWr(IDout_RegWr),
      .ID_ALUSrc(IDout_ALUSrc),
      .ID_RegDst(IDout_RegDst),
      .ID_MemtoReg(IDout_MemtoReg),
      .ID_MemWr(IDout_MemWr),
      .ID_Branch(IDout_Branch),
      .ID_Jump(IDout_Jump),
      .ID_ExtOp(IDout_ExtOp),
      .ID_ALUop(IDout_ALUop),
      .ID_R_type(IDout_R_type),
      .EX_PC4(EX_PC4),
      .EX_Jtarg(EX_Jtarg),
      .EX_Rs(EX_Rs),
      .EX_Rt(EX_Rt),
      .EX_Rd(EX_Rd),
      .EX_func(EX_func),
      .EX_immd(EX_immd),
      .EX_busA(EX_busA),
      .EX_busB(EX_busB),
      .EX_RegWr(EX_RegWr),
      .EX_ALUSrc(EX_ALUSrc),
      .EX_RegDst(EX_RegDst),
      .EX_MemtoReg(EX_MemtoReg),
      .EX_MemWr(EX_MemWr),
      .EX_Branch(EX_Branch),
      .EX_Jump(EX_Jump),
      .EX_ExtOp(EX_ExtOp),
      .EX_ALUop(EX_ALUop),
      .EX_R_type(EX_R_type)
  );

  // EX Stage: Execute
  STAGE_EX EX_Stage (
      .Clk(Clk),
      .EXin_PC4(EX_PC4),
      .EXin_Jtarg(EX_Jtarg),
      .EXin_busA(EX_busA),
      .EXin_busB(EX_busB),
      .EXin_Rs(EX_Rs),
      .EXin_Rt(EX_Rt),
      .EXin_Rd(EX_Rd),
      .EXin_func(EX_func),
      .EXin_immd(EX_immd),
      .EXin_RegWr(EX_RegWr),
      .EXin_ALUSrc(EX_ALUSrc),
      .EXin_RegDst(EX_RegDst),
      .EXin_MemtoReg(EX_MemtoReg),
      .EXin_MemWr(EX_MemWr),
      .EXin_Branch(EX_Branch),
      .EXin_Jump(EX_Jump),
      .EXin_ExtOp(EX_ExtOp),
      .EXin_R_type(EX_R_type),
      .EXin_ALUop(EX_ALUop),
      .MEM_ALUout(MEM_ALUout),
      .MEM_Rw(MEM_Rw),
      .MEM_RegWr(MEM_RegWr),
      .WR_RegDin(WRout_RegDin),
      .WR_Rw(WRout_Rw),
      .WR_RegWr(WRout_RegWE),
      .EXout_Btarg(EXout_Btarg),
      .EXout_Jtarg(EXout_Jtarg),
      .EXout_busB(EXout_busB),
      .EXout_ALUout(EXout_ALUout),
      .EXout_Rw(EXout_Rw),
      .EXout_Zero(EXout_Zero),
      .EXout_Overflow(EXout_Overflow),
      .EXout_RegWr(EXout_RegWr),
      .EXout_MemtoReg(EXout_MemtoReg),
      .EXout_MemWr(EXout_MemWr),
      .EXout_Branch(EXout_Branch),
      .EXout_Jump(EXout_Jump)
  );

  // EX/MEM Pipeline Register
  REG_EX_MEM EX_MEM_Reg (
      .Clk(Clk),
      .Clrn(Clrn),
      .MEM_PCSrc(MEMout_PCSrc),
      .EX_Btarg(EXout_Btarg),
      .EX_Jtarg(EXout_Jtarg),
      .EX_busB(EXout_busB),
      .EX_ALUout(EXout_ALUout),
      .EX_Rw(EXout_Rw),
      .EX_Rt(EX_Rt),  // Pass Rt for sw forwarding detection
      .EX_Zero(EXout_Zero),
      .EX_Overflow(EXout_Overflow),
      .EX_RegWr(EXout_RegWr),
      .EX_MemtoReg(EXout_MemtoReg),
      .EX_MemWr(EXout_MemWr),
      .EX_Branch(EXout_Branch),
      .EX_Jump(EXout_Jump),
      .MEM_Btarg(MEM_Btarg),
      .MEM_Jtarg(MEM_Jtarg),
      .MEM_busB(MEM_busB),
      .MEM_ALUout(MEM_ALUout),
      .MEM_Rw(MEM_Rw),
      .MEM_Rt(MEM_Rt),  // Receive Rt for sw forwarding detection
      .MEM_Zero(MEM_Zero),
      .MEM_Overflow(MEM_Overflow),
      .MEM_RegWr(MEM_RegWr),
      .MEM_MemtoReg(MEM_MemtoReg),
      .MEM_MemWr(MEM_MemWr),
      .MEM_Branch(MEM_Branch),
      .MEM_Jump(MEM_Jump)
  );

  // MEM Stage: Memory Access
  STAGE_MEM MEM_Stage (
      .Clk(Clk),
      .MEMin_Btarg(MEM_Btarg),
      .MEMin_Jtarg(MEM_Jtarg),
      .MEMin_busB(MEM_busB),
      .MEMin_ALUout(MEM_ALUout),
      .MEMin_Rw(MEM_Rw),
      .MEMin_Rt(MEM_Rt),  // Pass Rt for sw forwarding detection
      .MEMin_Zero(MEM_Zero),
      .MEMin_Overflow(MEM_Overflow),
      .MEMin_RegWr(MEM_RegWr),
      .MEMin_MemtoReg(MEM_MemtoReg),
      .MEMin_MemWr(MEM_MemWr),
      .MEMin_Branch(MEM_Branch),
      .MEMin_Jump(MEM_Jump),
      // Forwarding inputs from WR stage
      .WR_RegDin(WRout_RegDin),
      .WR_Rw(WRout_Rw),
      .WR_RegWr(WRout_RegWE),
      .MEMout_Dout(MEMout_Dout),
      .MEMout_ALUout(MEMout_ALUout),
      .MEMout_Btarg_or_Jtarg(MEMout_Btarg_or_Jtarg),
      .MEMout_Rw(MEMout_Rw),
      .MEMout_Overflow(MEMout_Overflow),
      .MEMout_MemtoReg(MEMout_MemtoReg),
      .MEMout_RegWr(MEMout_RegWr),
      .MEMout_PCSrc(MEMout_PCSrc)
  );

  // MEM/WR Pipeline Register
  REG_MEM_WR MEM_WR_Reg (
      .Clk(Clk),
      .Clrn(Clrn),
      .MEM_Dout(MEMout_Dout),
      .MEM_ALUout(MEMout_ALUout),
      .MEM_Rw(MEMout_Rw),
      .MEM_Overflow(MEMout_Overflow),
      .MEM_MemtoReg(MEMout_MemtoReg),
      .MEM_RegWr(MEMout_RegWr),
      .WR_Dout(WR_Dout),
      .WR_ALUout(WR_ALUout),
      .WR_Rw(WR_Rw),
      .WR_Overflow(WR_Overflow),
      .WR_MemtoReg(WR_MemtoReg),
      .WR_RegWr(WR_RegWr)
  );

  // WR Stage: Write Back
  STAGE_WR WR_Stage (
      .WRin_Dout(WR_Dout),
      .WRin_ALUout(WR_ALUout),
      .WRin_Rw(WR_Rw),
      .WRin_Overflow(WR_Overflow),
      .WRin_MemtoReg(WR_MemtoReg),
      .WRin_RegWr(WR_RegWr),
      .WRout_RegDin(WRout_RegDin),
      .WRout_Rw(WRout_Rw),
      .WRout_RegWE(WRout_RegWE)
  );

  // Output assignments
  assign out_IF_PC = IFout_PC;
  assign out_IF_Inst = IFout_Inst;
  assign out_ID_Inst = ID_Inst;
  assign out_EX_ALUout = EXout_ALUout;
  assign out_MEM_ALUout = MEMout_ALUout;
  assign out_WR_ALUout = WR_ALUout;

endmodule
