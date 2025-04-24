module Instruction_Memory 
	#(parameter LENGTH = 60)
(
	input [31:0] addr,
	output [31:0] inst
);
	reg [31:0] memory [255:0];
	initial 
	begin
		$readmemh("./mem/imem.hex", memory ,0 ,LENGTH);  
	end
	assign inst = memory[addr] ;
endmodule