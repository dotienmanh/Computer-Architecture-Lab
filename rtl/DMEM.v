//-----------------------------------------------------------------
//                      RISC-V Core Single Cycle Processor
//                                CA Lab
//-----------------------------------------------------------------
// Data_Memory

module Data_Memory(clk, rst_n, MemRW, addr, DataW, DataR);
    input clk, rst_n, MemRW;
    input [31:0] addr, DataW;
    output [31:0] DataR;

    integer k;
    reg [31:0] D_Mem [63:0];

    always @(posedge clk) begin
	D_Mem[17] <= 56;
	D_Mem[15] <= 65;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (k = 0; k < 64; k = k + 1) begin
                D_Mem[k] <= 32'b00;
            end
        end
        else if (!MemRW) begin //MemRW =0 => store the DataW 
            D_Mem[addr] <= DataW;
        end
    end

    assign DataW = ( MemRW ) ? D_Mem[addr] : 32'b0; //MemRW =1 => use DMEM , MEMRW=0 not using DMEM

endmodule