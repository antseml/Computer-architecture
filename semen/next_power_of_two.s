    .data

input_addr:   .word  0x80
output_addr:  .word  0x84
stack_top:    .word  0xF00

    .text
    .org     0x100

_start:
    lui      t0, %hi(stack_top)
    addi     t0, t0, %lo(stack_top)
    lw       sp, 0(t0)
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
    lw       s0, 0(t0)
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
    lw       s1, 0(t0)

    lw       a0, 0(s0)
    jal      ra, solve
    sw       a0, 0(s1)
    halt

solve:
    addi     sp, sp, -4
    sw       ra, 0(sp)
    blt      a0, zero, solve_negative
    addi     t0, zero, 1
    bge      t0, a0, solve_one
    addi     a1, zero, 1
    jal      ra, next_pow2
    j        solve_exit

solve_negative:
    addi     a0, zero, -1
    j        solve_exit

solve_one:
    addi     a0, zero, 1

solve_exit:
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jalr     zero, ra, 0

next_pow2:
    addi     sp, sp, -4
    sw       ra, 0(sp)
    bge      a1, a0, next_pow2_found
    slli     a1, a1, 1
    blt      a1, zero, next_pow2_overflow
    jal      ra, next_pow2
    j        next_pow2_exit

next_pow2_found:
    mv       a0, a1
    j        next_pow2_exit

next_pow2_overflow:
    lui      a0, %hi(0xCCCCCCCC)
    addi     a0, a0, %lo(0xCCCCCCCC)

next_pow2_exit:
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jalr     zero, ra, 0
