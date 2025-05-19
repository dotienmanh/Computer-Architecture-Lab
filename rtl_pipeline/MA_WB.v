module MA_WB (
  input clk, 
  input rst_n,
  input [31:0] ALU_Result_M,
  input [31:0] PC_Plus4_M,
  input [31:0] Read_Data_M,
  input [31:0] Instr_M,
  output reg [31:0] ALU_Result_W,
  output reg [31:0] PC_Plus4_W,
  output reg [31:0] Read_Data_W,
  output reg [31:0] Instr_W
);

always @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    ALU_Result_W <= 0;
    PC_Plus4_W <= 0;
    Read_Data_W <= 0; 
    Instr_W <= 0;
  end
  else begin
    ALU_Result_W <= ALU_Result_M;
    PC_Plus4_W <= PC_Plus4_M;
    Read_Data_W <= Read_Data_M; 
    Instr_W <= Instr_M;
  end
end

endmodule