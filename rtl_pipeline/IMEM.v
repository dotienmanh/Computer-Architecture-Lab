module Instruction_Memory 
	#(parameter LENGTH = 60)
(
	input [31:0] addr,
	output [31:0] inst
);
	reg [31:0] memory [255:0];

	assign inst = memory[addr] ;
endmodule