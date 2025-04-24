`timescale 1ns/1ps

module RISCV_Single_Cycle_tb;
    logic clk;
    logic rst_n;

    RISCV_Single_Cycle dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, RISCV_Single_Cycle_tb);

        clk = 0;
        rst_n = 0;

        #20;
        rst_n = 1;

        #100; // simulate long enough to finish execution

        $display("✅ Simulation finished.");
        $finish;
    end
endmodule