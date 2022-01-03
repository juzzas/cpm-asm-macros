include(cpmmacro.asm.m4)

DEFC BOOT = 0


SECTION code_user

start:
        ENTER
        VERSION("20220101")

test1:
        ld b, 0x61  ; 'a'
        TOUPPER(b)

test2:
        ld a, 0x7a  ; 'z'
        TOUPPER()

test3:
        ld b, 0x41  ; 'A'
        TOUPPER(b)

test4:
        ld a, 0x5a  ; 'z'
        TOUPPER()

test5:
        ld a, 0x35  ; '5'
        TOUPPER()

test6:
        READCH

test7:
        ld a, '#'
        PUTCH

        EXIT
        SYSF_JT

msg1a:
        DEFM "Hello"

msg1b:
        DEFM "Hellw"

DEFC end = $

