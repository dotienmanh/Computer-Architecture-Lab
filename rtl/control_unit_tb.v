module control_unit_tb;

    // Declare the inputs
    reg [6:0]   opcode;
    reg [6:0]   funct7;
    reg [2:0]   funct3;
    reg         BrEq;
    reg         BrLT;

    // Declare the outputs
    wire        PCSel;
    wire [2:0]  ImmSel;
    wire        RegWEn;
	wire        BrUn;
	wire        ASel;
    wire        BSel;
    wire [3:0]  ALUSel;
    wire        MemRW;
    wire [1:0]  WBSel;
    
    // Instantiate UUT
    control_unit #(
        .OP_EFF_WIDTH(5),
        .FUNCT3_WIDTH(3),
        .ALUCTRL_WIDTH(4)
    ) uut (
        .opcode_eff(opcode[6:2]),
        .funct7_fif(funct7[5]),
        .funct3(funct3),
        .BrEq(BrEq),
        .BrLT(BrLT),

        .PCSel(PCSel),
        .ImmSel(ImmSel),
        .RegWEn(RegWEn),
	    .BrUn(BrUn),
	    .ASel(ASel),
        .BSel(BSel),
        .ALUSel(ALUSel),
        .MemRW(MemRW),
        .WBSel(WBSel)
    );

    // Golden ALUSel for ALU
    reg [3:0] golden_ALUSel [0:7];
    initial begin
        golden_ALUSel[0] = 4'd0;
        golden_ALUSel[1] = 4'd5;
        golden_ALUSel[2] = 4'd8;
        golden_ALUSel[3] = 4'd9;
        golden_ALUSel[4] = 4'd4;
        golden_ALUSel[5] = 4'd6;
        golden_ALUSel[6] = 4'd3;
        golden_ALUSel[7] = 4'd2;
    end

    // Generate direct test vectors
    integer i;
    initial begin
        // Open VCD file for waveform generation
        $dumpfile("control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);
        BrEq = 0; BrLT = 0;

        // Test 1: R-Type instruction (opcode = 7'b0110011)
        opcode = 7'b0110011; funct7 = 7'b0000000;
        for (i = 0; i < 8; i = i + 1) begin
            funct3 = i;
            #5;
            // Expected control signals: PCSel =  BrUn = ASel = BSel = MemRW = 0; RegWEn = 1; WBSel = 01; ImmSel = 000
            // ALUSel = Operation
            if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00000101000) || (ALUSel != golden_ALUSel[i])) begin
                $display("[Error] [%t] [[%t]] R-Type: opcode = %b, funct3 = %b, funct7 = %b\n", $time, $time, opcode, funct3, funct7);
            end
            #5;
        end
        funct7 = 7'b0100000;
        // SUB
        funct3 = 3'b000; #5;
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00000101000) || (ALUSel != 1)) begin
            $display("[Error] [%t] R-Type: opcode = %b, funct3 = %b, funct7 = %b\n", $time, opcode, funct3, funct7);
        end
        #5;
        // SHR_ARITHMETIC
        funct3 = 3'b101; #5;
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00000101000) || (ALUSel != 7)) begin
            $display("[Error] [%t] R-Type: opcode = %b, funct3 = %b, funct7 = %b\n", $time, opcode, funct3, funct7);
        end
        #5;

        // Test 2: I-Type arithmetic instruction (opcode = 7'b0010011) -> same with R-Type, so only test addi
        opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000; #5;
        // Expected control signals: PCSel =  BrUn = ASel = 0; BSel = 1; MemRW = 0; RegWEn = 1; WBSel = 01; ImmSel = 000
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00010101000) || (ALUSel != 0)) begin
            $display("[Error] [%t] I-Type Arith: opcode = %b, funct3 = %b, funct7 = %b\n", $time, opcode, funct3, funct7);
        end
        #5;

        // Test 3: I-Type load instruction (opcode = 7'b0010011) -> same with R-Type, so only test addi
        opcode = 7'b0000011; funct3 = 3'b010; #5;
        // Expected control signals: PCSel = BrUn = ASel = 0; BSel = 1; MemRW = 0; RegWEn = 1; WBSel = 00; ImmSel = 000
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00010100000) || (ALUSel != 0)) begin
            $display("[Error] [%t] I-Type Load: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;

        // Test 4: S-Type instruction (opcode = 7'b0100011)
        opcode = 7'b0100011; funct3 = 3'b010; #5;
        // Expected control signals: PCSel = BrUn = ASel = 0; BSel = MemRW = 1; RegWEn = 0; WBSel = 00; ImmSel = 001
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00011000001) || (ALUSel != 0)) begin
            $display("[Error] [%t] S-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;

        // Test 5: B-Type instruction (opcode = 7'b1100011)
        opcode = 7'b1100011;
        // beq
        funct3 = 3'b000;
        BrEq = 0; BrLT = 0; #5;
        // Expected control signals: PCSel = BrUn = 0; ASel = BSel = 1; MemRW = RegWEn = 0; WBSel = 00; ImmSel = 010
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        BrEq = 0; BrLT = 1; #5;
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        BrEq = 1; BrLT = 0; #5;
        // Expected control signals: PCSel = 1; BrUn = 0; ASel = BSel = 1; MemRW = RegWEn = 0; WBSel = 00; ImmSel = 010
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b10110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        // blt
        funct3 = 3'b100;
        BrEq = 0; BrLT = 0; #5;
        // Expected control signals: PCSel = BrUn = 0; ASel = BSel = 1; MemRW = RegWEn = 0; WBSel = 00; ImmSel = 010
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        BrEq = 0; BrLT = 1; #5;
        // Expected control signals: PCSel = 1; BrUn = 0; ASel = BSel = 1; MemRW = RegWEn = 0; WBSel = 00; ImmSel = 010
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b10110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        BrEq = 1; BrLT = 0; #5;
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        // bltu
        funct3 = 3'b110;
        BrEq = 0; BrLT = 0; #5;
        // Expected control signals: PCSel = 0; BrUn = 1; ASel = BSel = 1; MemRW = RegWEn = 0; WBSel = 00; ImmSel = 010
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b01110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        BrEq = 0; BrLT = 1; #5;
        // Expected control signals: PCSel = BrUn = 1; ASel = BSel = 1; MemRW = RegWEn = 0; WBSel = 00; ImmSel = 010
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b11110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        BrEq = 1; BrLT = 0; #5;
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b01110000010) || (ALUSel != 0)) begin
            $display("[Error] [%t] B-Type: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;

        // Test 6: jal (opcode = 7'b1101111)
        opcode = 7'b1101111; funct3 = 3'b000; BrEq = 0; BrLT = 0; #5;
        // Expected control signals: PCSel = 1; BrUn = 0; ASel = BSel = 1; MemRW = 0; RegWEn = 1; WBSel = 10; ImmSel = 011
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b10110110011) || (ALUSel != 0)) begin
            $display("[Error] [%t] jal: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;

        // Test 7: jalr (opcode = 7'b1100111)
        opcode = 7'b1100111; #5;
        // Expected control signals: PCSel = 1; BrUn = 0; ASel = 0; BSel = 1; MemRW = 0; RegWEn = 1; WBSel = 10; ImmSel = 000
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b10010110000) || (ALUSel != 0)) begin
            $display("[Error] [%t] jalr: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;

        // Test 8: auipc (opcode = 7'b0010111)
        opcode = 7'b0010111; #5;
        // Expected control signals: PCSel = BrUn = 0; ASel = BSel = 1; MemRW = 0; RegWEn = 1; WBSel = 01; ImmSel = 100
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00110101100) || (ALUSel != 0)) begin
            $display("[Error] [%t] auipc: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;

        // Test 9: lui (opcode = 7'b0110111)
        opcode = 7'b0110111; #5;
        // Expected control signals: PCSel = BrUn = ASel = BSel = MemRW = 0; RegWEn = 1; WBSel = 11; ImmSel = 100
        if (({PCSel, BrUn, ASel, BSel, MemRW, RegWEn, WBSel, ImmSel} != 11'b00000111100) || (ALUSel != 0)) begin
            $display("[Error] [%t] lui: opcode = %b, funct3 = %b\n", $time, opcode, funct3);
        end
        #5;
        $finish;
    end
endmodule
