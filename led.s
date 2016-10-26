
.equ RAMEND , 0x8ff
.equ SPL , 0x3d
.equ SPH , 0x3e
.equ PORTB , 0x05
.equ DDRB , 0x04
.equ PORTD , 0x0b
.equ DDRD , 0x0a
.equ TIMER_CONTROL , 0x25
.equ TIMER_COUNTER , 0x26
.equ TIMER_MASK , 0x6e

.org 0x0000
    rjmp main

.org 0x0040
    rjmp timer0_overflow_handler

smallCycle:
    inc r21
    ldi r16 , 0x0f
    cpse r21 , r16
    ret
    clr r21
    rol r20
    mov r16 , r19
    and r16 , r20
    tst r16
    breq skip_smallCycle
    mov r18 , r20
skip_smallCycle:
    ret
largeCycle:
    ldi r16 , 0xff
    cpse r17 , r16
    ret
    inc r19
    ret
timer0_overflow_handler:
    push r16
    inc r17
    call largeCycle
    call smallCycle
    pop r16
    reti
main:
    ldi r16 , lo8( RAMEND )
    out SPL , r16
    ldi r16 , hi8( RAMEND )
    out SPH , r16
    ldi r16 , 0xff
    out DDRB , r16
    out DDRD , r16

    ldi r16 , 0x02
    out TIMER_CONTROL , r16
    ldi r16 , 0x01
    sts TIMER_MASK , r16
    sei

    ldi r16 , 0x00
    ldi r17 , 0x00
    ldi r18 , 0x01
    ldi r19 , 0x00
    ldi r20 , 0x01
    ldi r21 , 0x00
    out TIMER_COUNTER , r16
loop:
    rcall blink
    rjmp loop

blink:
    ldi r16 , 0x0
    out PORTB , r16
    out PORTD , r16
    sbrc r18 , 0
    sbi PORTD , 6
    sbrc r18 , 1
    sbi PORTD , 7
    sbrc r18 , 2
    sbi PORTB , 0
    sbrc r18 , 3
    sbi PORTB , 1
    sbrc r18 , 4
    sbi PORTB , 2
    sbrc r18 , 5
    sbi PORTB , 3
    sbrc r18 , 6
    sbi PORTB , 4
    sbrc r18 , 7
    sbi PORTB , 5
    ret
