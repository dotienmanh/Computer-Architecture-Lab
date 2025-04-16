//-----------------------------------------------------------------
//                      RISC-V Core Single Cycle Processor
//                                CA Lab
//-----------------------------------------------------------------
// Data_Memory

module Data_Memory(clk, rst_n, MemRW, read_address, Write_data, MemData_out);
    input clk, rst_n, MemRW;
    input [31:0] read_address, Write_data;
    output [31:0] MemData_out;
    integer k;
    reg [31:0] D_Mem [63:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (k = 0; k < 64; k = k + 1) begin
                D_Mem[k] = 32'b00;
            end
        end
        else if (!MemRW) begin
            D_Mem[read_address] = Write_data;
        end
    end

    assign MemData_out = (MemRW) ? D_Mem[read_address] : 32'b0;

endmodule