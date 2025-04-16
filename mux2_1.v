module mux2_1 #(
	parameter WIDTH = 8
)(
	input [WIDTH-1:0] x,
	input [WIDTH-1:0] y,
	input sel,
	output [WIDTH-1:0] out
);

assign out = sel ? x : y;

endmodule
