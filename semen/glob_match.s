    .data

pattern_buf:  .byte  '________________________________'
text_buf:     .byte  '________________________________'
input_addr:   .word  0x80
output_addr:  .word  0x84
stack_top:    .word  0xF00
alignment:    .byte  '____________________________________________________________'

    .text

_start:
    movea.l  stack_top, A7
    movea.l  (A7), A7
    movea.l  input_addr, A0
    movea.l  (A0), A0
    movea.l  output_addr, A1
    movea.l  (A1), A1
    movea.l  pattern_buf, A2
    movea.l  text_buf, A5

    move.l   32, D1
    movea.l  A2, A3
    jsr      read_line
    cmp.l    0, D0
    bne      overflow

    movea.l  A5, A3
    jsr      read_line
    cmp.l    0, D0
    bne      overflow

    clr.l    D3
    clr.l    D4
    jsr      match
    move.l   D0, (A1)
    jmp      finish

overflow:
    move.l   0xCCCCCCCC, (A1)

finish:
    halt

read_line:
    move.l   D1, D2
    sub.l    1, D2
    clr.l    D4

read_line_loop:
    move.l   (A0), D3
    cmp.l    10, D3
    beq      read_line_done
    cmp.l    0, D2
    beq      read_line_overflow
    move.b   D3, 0(A3,D4)
    add.l    1, D4
    sub.l    1, D2
    jmp      read_line_loop

read_line_done:
    clr.b    0(A3,D4)
    clr.l    D0
    rts

read_line_overflow:
    move.l   -1, D0
    rts

match:
    clr.l    D1
    move.b   0(A2,D3), D1
    cmp.b    0, D1
    beq      match_pattern_end
    cmp.b    42, D1
    beq      match_star
    clr.l    D2
    move.b   0(A5,D4), D2
    cmp.b    0, D2
    beq      match_fail
    cmp.b    63, D1
    beq      match_next
    cmp.b    D2, D1
    bne      match_fail

match_next:
    add.l    1, D3
    add.l    1, D4
    jmp      match

match_star:
    move.l   D3, -(A7)
    move.l   D4, -(A7)
    add.l    1, D3
    jsr      match
    move.l   (A7)+, D4
    move.l   (A7)+, D3
    cmp.l    0, D0
    bne      match_return
    clr.l    D2
    move.b   0(A5,D4), D2
    cmp.b    0, D2
    beq      match_fail
    add.l    1, D4
    jmp      match

match_pattern_end:
    clr.l    D2
    move.b   0(A5,D4), D2
    cmp.b    0, D2
    bne      match_fail
    move.l   1, D0

match_return:
    rts

match_fail:
    clr.l    D0
    rts
