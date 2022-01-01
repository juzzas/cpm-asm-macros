include(cpmmacro.asm.m4)

DEFC BOOT = 0


SECTION code_user

start:
        ENTER
        VERSION("20220101")
        EXIT


DEFC end = $

