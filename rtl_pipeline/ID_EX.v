module ID_EX (
  input clk,
  input rst_n,
  input [31:0] PC_D, 
  input [31:0] RD1_D,
  input [31:0] RD2_D,
  input [31:0] Imm_D,
  input [31:0] Instr_D,
  output [31:0] RD1_E,
  output [31:0] RD2_E,
  output [31:0] PC_E, 
  output [31:0] Imm_E,
  output [31:0] Instr_E
);

always @( posedge clk, negedge rst_n ) begin
  if (~rst_n) begin
    RD1_E <= 0;
    RD2_E <= 0;
    PC_E  <= 0;
    Imm_E <= 0;
    Instr_E <= 0;
  end
  else begin
    RD1_E <= RD1_D;
    RD2_E <= RD2_D;
    PC_E  <= PC_D;
    Imm_E <= Imm_D;
    Instr_E <= Instr_D;
  end
end

endmodule