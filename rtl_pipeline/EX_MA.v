module EX_MA(
  input clk,
  input rst_n,
  input [31:0] PC_E,
  input [31:0] ALU_Result_E, 
  input [31:0] RD2_E,
  input [31:0] Instr_E,
  output [31:0] PC_M,
  output [31:0] ALU_Result_M,
  output [31:0] RD2_M,
  output [31:0] Instr_M
);

always @( posedge clk, negedge rst_n ) begin 
  if (~rst_n) begin
    PC_M         <= 0;
    ALU_Result_M <= 0;
    RD2_M        <= 0; 
    Instr_M      <= 0;
  end

  else begin
    PC_M         <= PC_E;
    ALU_Result_M <= ALU_Result_E;
    RD2_M        <= RD2_E; 
    Instr_M      <= Instr_E;        
  end
end

endmodule