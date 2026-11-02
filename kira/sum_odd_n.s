    .data

input_addr:  .word 0x80
output_addr: .word 0x84
one:         .word 1
count:       .word 0

    .text

_start:
    load_addr    input_addr
    load_acc
    bgtz         calc
    load_imm     -1
    jmp          done

calc:
    add          one
    shiftr       one
    store        count
    mul          count
    bvs          overflow

done:
    store_ind    output_addr
    halt

overflow:
    load_imm     0xCCCC_CCCC
    jmp          done
