include(cpmmacro.asm.m4)

DEFC BOOT = 0


SECTION code_user

start:
        VERSION("20210906")

        MEMCPY(newtext, text, textend-text)
        MEMCPY(newtext2, "Hello world")

        LD DE, newtext3
        MEMCPY_DE(text, textend-text)

        LD DE, newtext4
        MEMCPY_DE(`"Hello world", 10, 13')

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

DEFC end = $

