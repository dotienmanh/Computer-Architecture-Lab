module ALU_decoder#(
    parameter FUNCT3_WIDTH  = 3,
    parameter ALUCTRL_WIDTH = 4,

    parameter ADD               = 4'b0000,
    parameter SUB               = 4'b0001,
    parameter AND               = 4'b0010,
    parameter OR                = 4'b0011,
    parameter XOR               = 4'b0100,
    parameter SHL_LOGICAL       = 4'b0101,
    parameter SHR_LOGICAL       = 4'b0110,
    parameter SHR_ARITHMETIC    = 4'b0111,
    parameter LESS_SIGNED       = 4'b1000,
    parameter LESS_UNSIGNED     = 4'b1001
)
(
    input                           arithmetic, // = 1 When using Arithmetic Ops
    input       [FUNCT3_WIDTH-1:0]  funct3,
    input                           funct7_fif, // func7[5] to use SUB, SHR_ARITHMETIC
    input                           i_type,     // indicate that I type is used
    
    output reg [ALUCTRL_WIDTH-1:0]  ALUSel
);

always@(arithmetic, funct3, funct7_fif, i_type) begin
    if (arithmetic) begin
        case (funct3)
            3'b000: begin
                if ((funct7_fif)&&(!i_type)) ALUSel = SUB;
                else ALUSel = ADD;
            end
            3'b001: ALUSel = SHL_LOGICAL;
            3'b010: ALUSel = LESS_SIGNED;
            3'b011: ALUSel = LESS_UNSIGNED;
            3'b100: ALUSel = XOR;
            3'b101: begin
                if (funct7_fif) ALUSel = SHR_ARITHMETIC;
                else ALUSel = SHR_LOGICAL;
            end
            3'b110: ALUSel = OR;
            3'b111: ALUSel = AND;
            default: ALUSel = ADD;
        endcase
    end
    else begin
        // Use ADD
        ALUSel = ADD;
    end
end
endmodule