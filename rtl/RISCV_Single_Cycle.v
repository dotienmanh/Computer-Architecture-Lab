module RISCV_Single_Cycle(clk, rst_n);

input clk;
input rst_n;

wire [31:0] PC_in_top, PC_out_top, Instruction_out_top, PC_Plus4_top;
wire [31:0] Addr_instr_mem;
wire [31:0] DataA_top, DataB_top, DataD_top, ALU_out_top, Imm_top, Mux_ALU_DataA_top, Mux_ALU_DataB_top, DataR_top;
wire [3:0] ALUSel_top;
wire PCSel_top, RegWEn_top, MemRW_top, Asel_top, Bsel_top, BrUn_top, BrEq_top, BrLt_top;
wire [1:0] WBSel_top;
wire [2:0] ImmSel_top;

assign PC_in_top = PCSel_top ? ALU_out_top : PC_Plus4_top;

assign PC_Plus4_top = PC_out_top + 32'h00000004;

assign Mux_ALU_DataA_top = Asel_top ? PC_Plus4_top : DataA_top;

assign Mux_ALU_DataB_top = Bsel_top ? Imm_top : DataB_top;

assign DataD_top = (WBSel_top == 2'b00) ? DataR_top :
                   (WBSel_top == 2'b01) ? ALU_out_top :
                   PC_Plus4_top;

assign Addr_instr_mem = {2{'b0}, PC_out_top[31:2]};

control_unit Control_logic_inst(
    .opcode_eff (Instruction_out_top[6:0]),
    .funct7_fif (Instruction_out_top[30]),
    .funct3     (Instruction_out_top[14:12]),
    .BrEq   (BrEq_top),
    .BrLT   (BrLt_top),
    .PCSel  (PCSel_top),
    .ImmSel (ImmSel_top),
    .RegWEn (RegWEn_top),
    .BrUn   (BrUn_top),
    .ASel   (Asel_top),
    .BSel   (Bsel_top),
    .ALUSel (ALUSel_top),
    .MemRW  (MemRW_top),
    .WBSel  (WBSel_top)
);

Program_Counter PC_inst(
    .clk    (clk),
    .rst_n  (rst_n),
    .PC_in  (PC_in_top),
    .PC_out (PC_out_top)
);

Instruction_Memory IMEM_inst(
    .addr (Addr_instr_mem), 
    .inst (Instruction_out_top)
);

Immediate_Generator Imm_Gen_inst(
    .Inst   (Instruction_out_top),
    .ImmSel (ImmSel_top),
    .Imm    (Imm_top)
);

RegisterFile Reg_inst (   
    .clk       (clk),
    .reset     (rst_n),
    .addrA     (Instruction_out_top[19:15]),
    .addrB     (Instruction_out_top[24:20]),
    .addrD     (Instruction_out_top[11:7]),
    .dataD     (DataD_top),
    .reg_write (RegWEn_top),
    .dataA     (DataA_top),
    .dataB     (DataB_top)
);

Branch_Comp Branch_Comp_inst(
    .operand_0 (DataA_top),
    .operand_1 (DataB_top),
    .BrUn  (BrUn_top),
    .BrEq  (BrEq_top),
    .BrLT  (BrLt_top)
);

ALU ALU_mod_inst (   
    .operand_0 (Mux_ALU_DataA_top),
    .operand_1 (Mux_ALU_DataB_top),
    .ALU_Sel   (ALUSel_top),
    .result    (ALU_out_top)
);

Data_Memory Dmem_inst (   
    .clk    (clk),
    .MemRW  (MemRW_top),
    .addr   (ALU_out_top),
    .DataW  (DataB_top),
    .DataR  (DataR_top)
);

endmodule