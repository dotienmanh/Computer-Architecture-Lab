module Immediate_Generator (
    Inst,
    ImmSel,
    Imm
);

parameter I = 3'b000;
parameter S = 3'b001;
parameter B = 3'b010;
parameter U = 3'b011;
parameter J = 3'b100;

input [31:0] Inst;
input [2:0] ImmSel;
output reg [31:0] Imm;

always @(*) begin
    case (ImmSel)
        I: begin
            Imm={{21{Inst[31]}}, Inst[30:20]};
        end
        S: begin
            Imm={{21{Inst[31]}}, Inst[30:25], Inst[11:7]};
        end
        U: begin
            Imm={Inst[31], Inst[30:12], {12{1'b0}}};
        end
        B: begin
            Imm={{20{Inst[31]}}, Inst[7], Inst[30:25], Inst[11:8], 1'b0};
        end
        J: begin
            Imm={{12{Inst[31]}}, Inst[19:12], Inst[20], Inst[30:21], 1'b0};
        end
        default: 
            Imm= 32'h00000000;
    endcase
end

endmodule