riscv64-unknown-elf-as program.S -o program.o
riscv64-unknown-elf-objcopy -O binary program.o program.bin
xxd -p -c 4 program.bin > imem.hex
