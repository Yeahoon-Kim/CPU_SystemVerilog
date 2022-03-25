// Code your design here
`include "alu.sv"
`include "regfile.sv"
`include "imem.sv"
`include "dmem.sv"
`include "controller.sv"

module mips(
  input logic iClk,
  input logic iReset
);

  logic [31:0] ALU_ALUResult;
  logic [31:0] REG_SrcA;
  logic [31:0] REG_SrcB;
  logic [31:0] REG_WriteData;
  logic [31:0] IMEM_Inst;
  logic [31:0] DMEM_ReadData;
  logic [31:0] ReadData;
  logic [31:0] pc;
  logic [31:0] SrcB;
  logic [4:0] WriteReg;
  
  logic CTL_RegWrite;
  logic CTL_MemWrite;
  logic CTL_RegDst;
  logic CTL_ALUSrc;
  logic CTL_MeMToReg;
  logic [2:0] CTL_ALUControl;
  
  alu ALU(
    .iA		(REG_SrcA),
    .iB		(SrcB),
    .iF		(CTL_ALUControl),
    .oY		(ALU_ALUResult),
    .oZero	()
  );
  
  regfile REG(
    .iClk	(iClk),
    .iReset	(iReset),
    .iRaddr1(IMEM_Inst[25:21]),
    .iRaddr2(IMEM_Inst[20:16]),
    .iWaddr	(WriteReg),
    .iWe	(CTL_RegWrite),
    .iWdata	(ReadData),
    .oRdata1(REG_SrcA),
    .oRdata2(REG_SrcB)
  );
  
  imem IMEM(
    .iAddr	(pc),
    .oRdata	(IMEM_Inst)
  );
  
  dmem DMEM(
    .iClk	(iClk),
    .iWe	(CTL_MemWrite),
    .iAddr	(ALU_ALUResult),
    .iWdata	(REG_WriteData),
    .oRdata	(DMEM_ReadData)
  );
  
  controller CTL(
    .iOp		(IMEM_Inst[31:26]),
    .iFunct     (IMEM_Inst[5:0]),
    .oRegWrite	(CTL_RegWrite),
    .oMemWrite	(CTL_MemWrite),
    .oRegDst    (CTL_RegDst),
    .oALUSrc    (CTL_ALUSrc),
    .oMemToReg  (CTL_MeMToReg),
    .oALUControl(CTL_ALUControl)
  );

  mux5 MUX_REGDST(
    .iA (IMEM_Inst[20:16]),
    .iB (IMEM_Inst[15:11]),
    .iF (CTL_RegDst),
    .oY (WriteReg)
  );

  mux32 MUX_ALUSRC(
    .iA (REG_SrcB),
    .iB ({{16{IMEM_Inst[15]}}, IMEM_Inst[15:0]}),
    .iF (CTL_ALUSrc),
    .oY (SrcB)
  );

  mux32 MUX_MEMTOREG(
    .iA (ALU_ALUResult),
    .iB (DMEM_ReadData),
    .iF (CTL_MeMToReg),
    .oY (ReadData)
  );
  
  always_ff@(posedge iClk, posedge iReset)
    if(iReset)
      pc <= 0;
    else 
      pc <= pc + 4;
  
endmodule