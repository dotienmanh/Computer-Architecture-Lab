module RISCV_Pipeline(
  input clk,
  input rst_n
);

// Controller
wire RegWEn_top;
wire [2:0] ImmSel_top;
wire BrUn_top, BrEq_top, BrLt_top;
wire ASel_top, BSel_top;
wire [3:0] ALUSel_top;
wire PCSel_top;
wire MemRW_top;
wire [1:0] WBSel_top;

Control_unit CU(
  .clk     (clk),
  .rst_n   (rst_n),
  .Instr_D (Instr_D),
  .ImmSel  (ImmSel_top),
  .Instr_E (Instr_E),
  .BrUn    (BrUn_top),
  .BrEq    (BrEq_top),
  .BrLT    (BrLt_top),
  .BSel    (BSel_top),
  .ASel    (ASel_top),
  .ALUSel  (ALUSel_top),
  .MemRW   (MemRW_top),
  .Instr_M (Instr_M),
  .PCSel   (PCSel_top),
  .WBSel   (WBSel_top)
);

// Instruction Fetch
wire [31:0] PC_F, PC_Next_F, PC_Plus4_F, Instr_F;

assign PC_Next_F = PCSel_top ? ALU_Result_M : PC_Plus4_F;
assign PC_Plus4_F = PC_F + 32'd4;

Program_Counter PC_inst(
    .clk    (clk),
    .rst_n  (rst_n),
    .PC_in  (PC_Next_F),
    .PC_out (PC_F)
);

Instruction_Memory IMEM_inst(
    .addr (PC_F),
    .inst (Instr_F)
);

// Instruction Fetch - Instruction Decode PIPELINE
wire [31:0] Instr_D, PC_D;

IF_ID pipreg0(
  .clk     (clk),
  .rst_n   (rst_n),
  .Instr_F (Instr_F),
  .PC_F    (PC_F),
  .Instr_D (Instr_D),
  .PC_D    (PC_D)
);

// Instruction Decode
wire [31:0] RD1_D, RD2_D, Imm_D;

RegisterFile Reg(
  .clk       (clk),
  .reset     (rst_n),
  .addrA     (Instr_D[19:15]),
  .addrB     (Instr_D[24:20]),
  .addrD     (Instr_W[11:7]),
  .dataD     (Wdata_W),
  .reg_write (RegWEn_top),
  .dataA     (RD1_D),
  .dataB     (RD2_D)
);

Immediate_Generator Imm_Gen(
  .Inst   (Instr_D),
  .ImmSel (ImmSel_top),
  .Imm    (Imm_D)
);

// Instruction Decode - Execute Pipeline
wire [31:0] RD1_E, RD2_E, PC_E, Imm_E, Instr_E;

ID_EX pipreg1(
  .clk     (clk),
  .rst_n   (rst_n),
  .PC_D,   (PC_D),
  .RD1_D,  (RD1_D),
  .RD2_D,  (RD2_D),
  .Imm_D,  (Imm_D),
  .Instr_D (Instr_D),
  .RD1_E,  (RD1_E),
  .RD2_E,  (RD2_E),
  .PC_E,   (PC_E),
  .Imm_E   (Imm_E),
  .Instr_E (Instr_E)
);

// Execute
wire [31:0] ALU_Result_E;

Branch_Comp Branch_Comp_inst(
  .operand_0 (RD1_E),
  .operand_1 (RD2_E),
  .BrUn      (BrUn_top),
  .BrEq      (BrEq_top),
  .BrLT      (BrLt_top)
);

assign Mux_ALU_DataA_top = ASel_top ? PC_E : RD1_E;
assign Mux_ALU_DataB_top = BSel_top ? Imm_E : RD2_E;

ALU ALU_inst (
  .ALU_Sel  (ALUSel_top),
  .operand_0(Mux_ALU_DataA_top),
  .operand_1(Mux_ALU_DataB_top),
  .result   (ALU_Result_E)
);

// Execute - Memory_access Pipeline
wire [31:0] PC_M, ALU_Result_M, RD2_M, Instr_M;

EX_MA pipreg2(
  .clk          (clk),
  .rst_n        (rst_n),
  .PC_E         (PC_E),
  .ALU_Result_E (ALU_Result_E), 
  .RD2_E        (RD2_E),
  .Instr_E      (Instr_E),
  .PC_M         (PC_M),
  .ALU_Result_M (ALU_Result_M),
  .RD2_M        (RD2_M),
  .Instr_M      (Instr_M)
);

// Memory Access
wire [31:0] Read_Data_M, PC_Plus4_M;

assign PC_Plus4_M = PC_M + 32'd4;

Data_Memory DMEM_inst (   
  .clk    (clk),
  .addr   (ALU_Result_M),
  .DataW  (RD2_M),
  .MemRW  (MemRW_top),
  .DataR  (Read_Data_M)
);

// Memory Access - Write back Pipeline
wire [31:0] ALU_Result_W, Read_Data_W, PC_Plus4_W;

MA_WB pipreg3(
  .clk          (clk), 
  .rst_n        (rst_n),
  .ALU_Result_M (ALU_Result_M),
  .PC_Plus4_M   (PC_Plus4_M),
  .Read_Data_M  (Read_Data_M),
  .Instr_M      (Instr_M),
  .ALU_Result_W (ALU_Result_W),
  .PC_Plus4_W   (PC_Plus4_W),
  .Read_Data_W  (Read_Data_W),
  .Instr_W      (Instr_W)
);

// Write back
wire [31:0] Wdata_W;

assign Wdata_W =  (WBSel_top[1]) ? PC_Plus4_W :   // WBSel_top == 2
                  (WBSel_top[0]) ? ALU_Result_W : // WBSel_top == 1
                  Read_Data_W;                // WBSel_top == 0

endmodule