include(cpmmacro.asm.m4)

DEFC BOOT = 0


SECTION code_user

start:
    VERSION("20210906")
    MEMCPY(newtext, text, textend-text)
    jp BOOT


text:
    DEFM "A test of macro "

DEFC textend = $

newtext:
    DEFS 32

DEFC end = $

