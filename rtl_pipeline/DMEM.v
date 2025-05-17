module Data_Memory(
 input clk,
 // address input, shared by read and write port
 input [31:0]   addr,
 
 // write port
 input [31:0]   DataW,
 input     MemRW,
 // read port
 output [31:0]   DataR
);

reg [31:0] memory [255:0];
// integer f;
wire [7:0] ram_addr;



 
 always @(posedge clk) begin
  if (MemRW)   //When MemRW =1 , we want to write data
   memory[ram_addr] <= DataW;
 end
 assign DataR = (MemRW ==1'b0) ? memory[ram_addr]: 32'd0; 
 assign ram_addr = addr[9:2];

endmodule