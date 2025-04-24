    .text
    .globl _start
_start:
    # Initialize registers
    addi x1, x0, 10         # x1 = 10
    addi x2, x0, 20         # x2 = 20

    # Perform addition
    add x3, x1, x2          # x3 = x1 + x2 = 30

    # Store result to memory[0]
    sw x3, 0(x0)            # mem[0] = x3

    # Load back into x4
    lw x4, 0(x0)            # x4 = mem[0]

    # Subtract and check result (x4 - x3 == 0)
    sub x5, x4, x3          # x5 = x4 - x3

    # Branch if equal (should be taken)
    beq x5, x0, done        # if x5 == 0 → jump to done

    # If branch fails, this shouldn't execute
    addi x6, x0, 99         # x6 = 99 (should be skipped)

done:
    addi x7, x0, 77         # x7 = 77 (marker for success)
