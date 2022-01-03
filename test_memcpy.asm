INCLUDE "cpmmacro.inc.asm"

DEFC BOOT = 0


SECTION code_user

start:
        ENTER
        VERSION "20210906"

test1:
        MEMCPY newtext, text, 12  ;textend-text

test2:
        STRCPY newtext2, "Hello world"

test3:
        LD DE, newtext3
        MEMCPY_DE text, textend-text

test4:
        LD DE, newtext4
        STRCPY_DE "Hello world"

test5:
        LD DE, newtext5
        STRCPY_DE "Hello world"

exit:
        EXIT


text:
        DEFM "A test of macro"

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

