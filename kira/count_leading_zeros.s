    .data

input_addr:      .word  0x80
output_addr:     .word  0x84
word_bits:       .word  32

    .text

_start:
    read_value
    count_leading_zeros
    write_value
    halt

\ ( -- value )
read_value:
    @p input_addr a! @
    ;

\ ( value -- count )
count_leading_zeros:
    dup
    if count_leading_zeros_zero
    0 swap

count_leading_zeros_loop:
    dup
    -if count_leading_zeros_shift
    drop
    ;

count_leading_zeros_shift:
    2*
    swap
    1 +
    swap
    count_leading_zeros_loop ;

count_leading_zeros_zero:
    drop
    @p word_bits
    ;

\ ( value -- )
write_value:
    @p output_addr a! !
    ;

\ ( x y -- y x )
swap:
    over >r >r drop r> r>
    ;
