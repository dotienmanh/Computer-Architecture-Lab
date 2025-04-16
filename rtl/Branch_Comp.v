module Branch_Comp(
    input [31:0] operand_0,
    input [31:0] operand_1,
    input BrUn,
    output reg BrEq,
    output reg BrLT
);

always @(*) begin
    if (BrUn) begin
        BrEq = (operand_0 == operand_1);
        BrLT = ($unsigned(operand_0) < $unsigned(operand_1));
    end else begin
        BrEq = (operand_0 == operand_1);
        BrLT = ($signed(operand_0) < $signed(operand_1));
    end
end
endmodule