include(cpmmacro.asm.m4)

DEFC BOOT = 0


SECTION code_user

start:
        VERSION("20210906")

test1:
        MEMCPY(newtext, text, textend-text)

test2:
        MEMCPY(newtext2, "Hello world")

test3:
        LD DE, newtext3
        MEMCPY(, text, textend-text)

test4:
        LD DE, newtext4
        MEMCPY(, `"Hello world", 10, 13')

test5:
        LD DE, newtext5
        MEMCPY(, "Hello world")

exit:
        jp BOOT


text:
        DEFM "A test of macro "

DEFC textend = $

newtext:
        DEFS 32

newtext2:
        DEFS 32

newtext3:
        DEFS 32

newtext4:
        DEFS 32

newtext5:
        DEFS 32

DEFC end = $

