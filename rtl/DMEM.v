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

reg [31:0] Memory [255:0];
// integer f;
wire [2:0] ram_addr=addr[2:0];

// initial
//  begin
//   $readmemb("./test.data", Memory);
  
//   // Open file for logging memory content
//   f = $fopen("./test.o", "w");
  
//   // Log memory contents (first time)
//   $fdisplay(f, "time = %d\n", $time);
//   $fdisplay(f, "\tmemory[0] = %b", Memory[0]);
//   $fdisplay(f, "\tmemory[1] = %b", Memory[1]);
//   $fdisplay(f, "\tmemory[2] = %b", Memory[2]);
//   $fdisplay(f, "\tmemory[3] = %b", Memory[3]);
//   $fdisplay(f, "\tmemory[4] = %b", Memory[4]);
//   $fdisplay(f, "\tmemory[5] = %b", Memory[5]);
//   $fdisplay(f, "\tmemory[6] = %b", Memory[6]);
//   $fdisplay(f, "\tmemory[7] = %b", Memory[7]);

//   #320; // Wait for 320 time units before closing the file
//   $fclose(f);
 
//  end
 
 always @(posedge clk) begin
  if (!MemRW)   //When MemRW =0 , we want to write data
   Memory[ram_addr] <= DataW;
 end
 assign DataR = (MemRW ==1'b1) ? Memory[ram_addr]: 32'd0; 

endmodule