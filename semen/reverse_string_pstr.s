    .data

buf:          .byte '________________________________'
input_addr:   .word 0x80
output_addr:  .word 0x84

    .text
    .org  0x100

_start:
    @p input_addr b!
    0 a!

read:
    @b
    dup 10 xor
    if done
    @+ drop
    a 32 xor
    if overflow
    read ;

done:
    drop
    a
    0 a!
    dup
    @ 0xFFFFFF00 and xor !+
    @p output_addr b!
    dup
    if finish
    -1 +
    >r

write:
    dup !b
    @ 0xFFFFFF00 and xor !+
    next write

finish:
    halt

overflow:
    @p output_addr b!
    0xCCCCCCCC !b
    finish ;
