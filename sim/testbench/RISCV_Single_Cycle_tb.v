`timescale 1ns/1ps

module tb_RISCV_Single_Cycle;
    logic clk;
    logic rst_n;

    RISCV_Single_Cycle dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Reset and simulation control
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_RISCV_Single_Cycle);

        clk = 0;
        rst_n = 0;

        #20;
        rst_n = 1;

        // Wait long enough for all instructions to complete
        #1000;

        // Check results
        $display("\n--- Verifying Data Memory ---");
        integer fd, code, value;
        string line, label;
        int err_count = 0;

        fd = $fopen("golden_output.txt", "r");
        if (fd == 0) begin
            $display("❌ Cannot open golden_output.txt");
            $finish;
        end

        while (!$feof(fd)) begin
            line = "";
            code = $fgets(line, fd);
            if (code == 0) break;

            // Format: Dmem[12] = 42
            string addr_str, val_str;
            int addr, expected, actual;

            $sscanf(line, "Dmem[%d] = %d", addr, expected);
            actual = dut.Dmem_inst.Memory[addr >> 2];

            if (actual !== expected) begin
                $display("❌ Mismatch at Dmem[%0d]: expected %0d, got %0d", addr, expected, actual);
                err_count++;
            end else begin
                $display("✅ Dmem[%0d] = %0d OK", addr, actual);
            end
        end

        $fclose(fd);

        if (err_count == 0)
            $display("🎉 All tests passed!");
        else
            $display("❗ Found %0d mismatches", err_count);

        $finish;
    end
endmodule
