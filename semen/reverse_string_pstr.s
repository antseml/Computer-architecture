    .data

buf:             .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
buffer_size:     .word  32
newline:         .word  10
preserve_high_bytes: .word  0xFFFFFF00
overflow_value:  .word  0xCCCCCCCC
alignment:       .byte  '________________________________________________________________________________'

    .text

_start:
    read_line
    dup
    -if _start_write
    drop
    @p overflow_value
    write_value
    _start_finish ;

_start_write:
    write_reversed_pstr

_start_finish:
    halt

read_line:
    @p input_addr b!
    0 a!

read_line_loop:
    @b
    dup @p newline xor
    if read_line_done
    a 1 + dup a!
    @p buffer_size xor
    if read_line_overflow
    read_line_loop ;

read_line_done:
    drop
    a
    ;

read_line_overflow:
    @p buffer_size -1 + >r

read_line_discard:
    drop
    next read_line_discard
    -1
    ;

write_reversed_pstr:
    lit buf a!
    dup
    store_byte
    dup
    if write_reversed_pstr_empty
    -1 +
    >r

write_reversed_pstr_loop:
    dup write_value
    store_byte
    next write_reversed_pstr_loop
    ;

write_reversed_pstr_empty:
    drop
    ;

store_byte:
    @ @p preserve_high_bytes and xor !+
    ;

write_value:
    @p output_addr b!
    !b
    ;
