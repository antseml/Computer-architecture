    .data

buf:          .byte  '________________________________'
input_addr:   .word  0x80
output_addr:  .word  0x84
stack_top:    .word  0xF00

    .text
    .org  0x88

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
    lui      s2, %hi(buf)
    addi     s2, s2, %lo(buf)

    addi     a0, zero, 32
    jal      ra, read_pstr
    bnez     a0, overflow

    jal      ra, print_pstr
    j        finish

overflow:
    lui      t0, %hi(0xCCCCCCCC)
    addi     t0, t0, %lo(0xCCCCCCCC)
    sw       t0, 0(s1)

finish:
    halt

read_pstr:
    addi     sp, sp, -12
    sw       ra, 8(sp)
    sw       s3, 4(sp)
    sw       s4, 0(sp)
    addi     s4, a0, -1
    addi     s3, zero, 0

read_pstr_loop:
    lw       t0, 0(s0)
    addi     t1, zero, 10
    beq      t0, t1, read_pstr_done
    beq      s3, s4, read_pstr_overflow
    mv       a0, t0
    jal      ra, to_upper
    add      t1, s2, s3
    sb       a0, 1(t1)
    addi     s3, s3, 1
    j        read_pstr_loop

read_pstr_done:
    sb       s3, 0(s2)
    addi     a0, zero, 0
    j        read_pstr_exit

read_pstr_overflow:
    addi     a0, zero, -1

read_pstr_exit:
    lw       s4, 0(sp)
    lw       s3, 4(sp)
    lw       ra, 8(sp)
    addi     sp, sp, 12
    jalr     zero, ra, 0

to_upper:
    addi     t0, zero, 97
    blt      a0, t0, to_upper_end
    addi     t0, zero, 122
    blt      t0, a0, to_upper_end
    addi     a0, a0, -32

to_upper_end:
    jalr     zero, ra, 0

print_pstr:
    addi     sp, sp, -4
    sw       ra, 0(sp)
    lb       a1, 0(s2)
    addi     a0, s2, 1
    jal      ra, print_chars
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jalr     zero, ra, 0

print_chars:
    beqz     a1, print_chars_end
    addi     sp, sp, -4
    sw       ra, 0(sp)
    lb       t0, 0(a0)
    sb       t0, 0(s1)
    addi     a0, a0, 1
    addi     a1, a1, -1
    jal      ra, print_chars
    lw       ra, 0(sp)
    addi     sp, sp, 4

print_chars_end:
    jalr     zero, ra, 0
