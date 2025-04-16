module RegisterFile(
  input clk,
  input reset,    // Active-low reset signal
  input [4:0] addrA,
  input [4:0] addrB,
  input [4:0] addrD,
  input [31:0] dataD,
  input reg_write,
  output reg [31:0] dataA,
  output reg [31:0] dataB
);
    reg [31:0] registers [31:0]; // Register file: 32 general-purpose registers, each 32 bits wide

    integer i;

    always @(posedge clk or negedge reset) begin
        if (reset == 1'b0) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (reg_write == 1'b1) begin
            if (addrD == 5'b0) begin
                // Do not write to register 0
            end else begin
                registers[addrD] <= dataD;
            end
        end
    end

    always @(*) begin
        if (reset == 1'b0) begin
            dataA = 32'b0;
            dataB = 32'b0;
        end else begin
            dataA = registers[addrA];
            dataB = registers[addrB];
        end
    end
endmodule