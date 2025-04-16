module Program_Counter(
    clk,
    rst_n,
    PC_in,
    PC_out
);

input clk;
input rst_n;
input [31:0] PC_in;
output reg [31:0] PC_out;

always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        PC_out <= 32'h00000000;
    end
    else begin 
        PC_out <= PC_in;
    end
end

endmodule