module Program_Counter(
    clk,
    rst_n,
    PC_in,
    PC_out
);



always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        PC_out <= 32'h00000000;
    end
    else begin 
        PC_out <= PC_in;
    end
end

endmodule