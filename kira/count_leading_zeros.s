    .data

input_addr:   .word  0x80
output_addr:  .word  0x84

    .text

_start:
    @p input_addr a! @
    dup
    if zero
    0 swap

loop:
    dup
    -if shift
    drop
    finish ;

shift:
    2*
    swap
    1 +
    swap
    loop ;

zero:
    drop
    32
    finish ;

finish:
    @p output_addr a! !
    halt

swap:
    over >r >r drop r> r>
    ;
