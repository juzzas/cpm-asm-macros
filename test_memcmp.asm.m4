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

test3:
        ; compare ASCII msg1a with msg1b (mismatch)
        MEMCMPA(msg1a, msg1b, 5)

test4:
        ; compare ASCII msg1a with itself (match)
        MEMCMPA(msg1a, msg1a, 5)

test5:
        ; compare ASCII msg1a with string (match)
        MEMCMPA(msg1a, "Hello")

test6:
        ; compare ASCII msg1a with string (mismatch)
        MEMCMPA(msg1a, "Helll")


        EXIT

msg1a:
        DEFM "Hello"

msg1b:
        DEFM "Hellw"

DEFC end = $

