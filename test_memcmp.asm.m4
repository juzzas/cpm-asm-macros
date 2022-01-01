include(cpmmacro.asm.m4)

DEFC BOOT = 0


SECTION code_user

start:
        ENTER
        VERSION("20220101")

test1:
        ; compare msg1a with msg1b
        MEMCMP(msg1a, msg1b, 5)

test2:
        ; compare msg1a with itself
        MEMCMP(msg1a, msg1a, 5)

        EXIT

msg1a:
        DEFM "Hello"

msg1b:
        DEFM "Hellw"

DEFC end = $

