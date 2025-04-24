riscv64-unknown-elf-as ./../mem/program.S -o ./../mem/program.o
riscv64-unknown-elf-objcopy -O binary ./../mem/program.o ./../mem/program.bin
xxd -p -c 4 ./../mem/program.bin > ./../mem/imem.hex
