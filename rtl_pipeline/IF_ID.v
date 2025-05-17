module IF_ID (
  input clk,
  input rst_n,
  input [31:0] Instr_F,
  input [31:0] PC_F,
  output reg [31:0] Instr_D,
  output reg [31:0] PC_D
);

always @( posedge clk, negedge rst_n) begin
  if (~rst_n) begin
    Instr_D <= 0;
    PC_D <= 0;
  end
  else begin	 
    Instr_D <= Instr_F;
    PC_D <= PC_F;
  end
end

endmodule