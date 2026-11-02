    .data

buf:          .byte  '________________________________________________________________'
input_addr:   .word  0x80
output_addr:  .word  0x84
stack_top:    .word  0xF00

    .text
    .org     0x100

_start:
    movea.l  stack_top, A7
    movea.l  (A7), A7
    movea.l  input_addr, A0
    movea.l  (A0), A0
    movea.l  output_addr, A1
    movea.l  (A1), A1
    movea.l  buf, A2

    move.l   64, D1
    jsr      read_line
    cmp.l    0, D0
    bne      overflow

    jsr      reverse_words
    halt

overflow:
    move.l   0xCCCCCCCC, (A1)
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
    move.b   D3, 0(A2,D4)
    add.l    1, D4
    sub.l    1, D2
    jmp      read_line_loop

read_line_done:
    clr.b    0(A2,D4)
    clr.l    D0
    rts

read_line_overflow:
    move.l   -1, D0
    rts

reverse_words:
    move.l   D4, D5
    move.l   1, D7

reverse_words_loop:
    jsr      skip_spaces
    cmp.l    0, D5
    beq      reverse_words_end
    move.l   D5, D6
    jsr      find_word_start
    cmp.l    0, D7
    bne      reverse_words_first
    move.l   32, (A1)

reverse_words_first:
    clr.l    D7
    jsr      print_word
    jmp      reverse_words_loop

reverse_words_end:
    rts

skip_spaces:
    cmp.l    0, D5
    beq      skip_spaces_end
    jsr      load_prev_char
    cmp.b    32, D3
    bne      skip_spaces_end
    sub.l    1, D5
    jmp      skip_spaces

skip_spaces_end:
    rts

find_word_start:
    cmp.l    0, D5
    beq      find_word_start_end
    jsr      load_prev_char
    cmp.b    32, D3
    beq      find_word_start_end
    sub.l    1, D5
    jmp      find_word_start

find_word_start_end:
    rts

load_prev_char:
    clr.l    D3
    move.b   -1(A2,D5), D3
    rts

print_word:
    move.l   D5, -(A7)

print_word_loop:
    cmp.l    D6, D5
    beq      print_word_end
    clr.l    D3
    move.b   0(A2,D5), D3
    move.l   D3, (A1)
    add.l    1, D5
    jmp      print_word_loop

print_word_end:
    move.l   (A7)+, D5
    rts
