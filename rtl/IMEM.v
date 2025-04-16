//-----------------------------------------------------------------
//                      RISC-V Core Single Cycle Processor
//                                CA Lab
//-----------------------------------------------------------------

//(Optional) `include ...
//Instruction_Memory

module Instruction_Memory( clk ,rst_n, read_address, instruction_out);
input clk ,rst_n;
input [31:0] read_address;
output reg [31:0] instruction_out;
integer k;
reg [31:0] I_Mem [63:0] ;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        for(k= 0; k<64; k= k+1) begin
            I_Mem[k] <= 32'b00;
        end
    end
    else 
        instruction_out <= I_Mem[read_address];

end

endmodule