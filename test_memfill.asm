include "cpmmacro.inc.asm"

DEFC BOOT = 0


SECTION code_user

start:
        ENTER
        VERSION("20220101")

        ; fill mem1 with 16 bytes of 0xa5
        ld de,mem1
        MEMSET_DE(0xa5, 16)

        ; fill mem2 with 24 bytes of 0x5a
        MEMSET(mem2, 0x5a, 24)

        EXIT

mem1:
        DEFS 32

mem2:
        DEFS 32

DEFC end = $

