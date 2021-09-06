; TESTVER to test macro VERSION

DEFC BOOT = 0

include(cpmmacro.asm.m4)

SECTION code_user

start:
    VERSION("20210906")
    jp BOOT

DEFC end = $

