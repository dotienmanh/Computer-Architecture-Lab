import argparse
import os

def write_mem_hex(filepath, data_list):
    with open(filepath, 'w') as f:
        for val in data_list:
            f.write(f"{val:08x}\n")

def gen_addi(rd, rs1, imm):
    instr = (imm & 0xFFF) << 20 | (rs1 & 0x1F) << 15 | 0x0 << 12 | (rd & 0x1F) << 7 | 0x13
    asm = f"addi x{rd}, x{rs1}, {imm}"
    return instr, asm

def gen_add(rd, rs1, rs2):
    instr = (0x00 << 25) | (rs2 << 20) | (rs1 << 15) | (0x0 << 12) | (rd << 7) | 0x33
    asm = f"add x{rd}, x{rs1}, x{rs2}"
    return instr, asm

def gen_sw(rs2, imm, rs1):
    imm11_5 = (imm >> 5) & 0x7F
    imm4_0 = imm & 0x1F
    instr = (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (0x2 << 12) | (imm4_0 << 7) | 0x23
    asm = f"sw x{rs2}, {imm}(x{rs1})"
    return instr, asm

def main():
    parser = argparse.ArgumentParser(description="Generate IMEM, DMEM, golden output, and assembly listing")
    parser.add_argument("--imem", type=str, default="./mem/imem.hex", help="Path to output instruction memory hex file")
    parser.add_argument("--dmem", type=str, default="./mem/dmem_init.hex", help="Path to output data memory hex file")
    parser.add_argument("--golden", type=str, default="./mem/golden_output.txt", help="Path to golden output text file")
    parser.add_argument("--asm", type=str, default="./mem/program.S", help="Path to output assembly file")
    args = parser.parse_args()

    instr_mem = []
    asm_lines = []

    for i in range(30):
        instr, asm = gen_addi(rd=1, rs1=0, imm=10 + i)
        instr_mem.append(instr)
        asm_lines.append(asm)

        instr, asm = gen_addi(rd=2, rs1=0, imm=20 + i)
        instr_mem.append(instr)
        asm_lines.append(asm)

        instr, asm = gen_add(rd=3, rs1=1, rs2=2)
        instr_mem.append(instr)
        asm_lines.append(asm)

        instr, asm = gen_sw(rs2=3, imm=(4*i), rs1=0)
        instr_mem.append(instr)
        asm_lines.append(asm)

    while len(instr_mem) < 100:
        instr_mem.append(0x00000013)
        asm_lines.append("nop")

    data_mem = list(range(256))

    golden_output = {f"Dmem[{4*i}]": 30 + i for i in range(30)}

    os.makedirs(os.path.dirname(args.imem), exist_ok=True)

    write_mem_hex(args.imem, instr_mem)
    write_mem_hex(args.dmem, data_mem)

    with open(args.golden, "w") as f:
        for key, val in golden_output.items():
            f.write(f"{key} = {val}\n")

    with open(args.asm, "w") as f:
        f.write("    .text\n    .globl _start\n_start:\n")
        for line in asm_lines:
            f.write(f"    {line}\n")

if __name__ == "__main__":
    main()
