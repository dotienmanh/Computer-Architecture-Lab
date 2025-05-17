module ALU(
    input [3:0] ALU_Sel,
    input [31:0] operand_0,
    input [31:0] operand_1,
    output reg [31:0] result
);

    localparam ADD              = 4'b0000; 
    localparam SUB              = 4'b0001; 
    localparam AND              = 4'b0010;
    localparam OR               = 4'b0011;
    localparam XOR              = 4'b0100;
    localparam SHL_LOGICAL      = 4'b0101;
    localparam SHR_LOGICAL      = 4'b0110;
    localparam SHR_ARITHMETIC   = 4'b0111;
    localparam LESS_THAN        = 4'b1000;

always @(*) begin
    case (ALU_Sel)
        ADD: result = operand_0 + operand_1;
        SUB: result = operand_0 - operand_1;
        
        AND: result = operand_0 & operand_1;
        OR:  result = operand_0 | operand_1;
        XOR: result = operand_0 ^ operand_1;

        SHL_LOGICAL: result = operand_0 << operand_1[4:0];
        SHR_LOGICAL: result = operand_0 >> operand_1[4:0];
        SHR_ARITHMETIC: result = $signed(operand_0) >>> operand_1[4:0];

        LESS_THAN: result = ($signed(operand_0) < $signed(operand_1)) ? 32'b1 : 32'b0;
        
        default: result = 32'b0;
    endcase
end


endmodule