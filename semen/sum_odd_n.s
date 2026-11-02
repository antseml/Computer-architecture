    .data

input_addr:  .word 0x80
output_addr: .word 0x84
n:           .word 0
k:           .word 0
const_1:     .word 1
const_2:     .word 2

    .text

_start:
    load_addr    input_addr
    load_acc
    store        n
    bgtz         compute
    load_imm     -1
    store_ind    output_addr
    halt

compute:
    load         n
    add          const_1
    div          const_2
    store        k
    mul          k
    bvs          overflow
    store_ind    output_addr
    halt

overflow:
    load_imm     0xCCCC_CCCC
    store_ind    output_addr
    halt
