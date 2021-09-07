dnl Macro library for CP/M system routines
dnl September 2021

dnl Macros n this library

DEFC EOF = 0x1a
DEFC ESC = 0x1b
DEFC CR = 13
DEFC LF = 10
DEFC TAB = 9
DEFC BLANK = 32  ; space characater
DEFC PERIOD = 46 ; decimal point
DEFC COMMA = 44

dnl Generate a "unique" label by concatenating the source line number with a suffix
define(LABEL, ``L'__line__`_$1'')

dnl Inline macro to embed version number
dnl Usage: VERSION(RELEASE)
dnl    RELEASE is a string

define(VERSION, `
        jp LABEL(skip)
        DEFM "Ver ", $1
LABEL(skip):
')

dnl  Copy memory
dnl  Usage: MEMCPY(TO, FROM, BYTES)

define(MEMCPY, `
    ifelse(`$3', `', `
        push bc
        push de
        push hl
        ld de, $1
        ld hl, LABEL(text)
        ld bc, LABEL(text_end)-LABEL(text)
        ldir
        pop hl
        pop de
        pop bc
        jp LABEL(skip)
LABEL(text):
        DEFB $2
        DEFC LABEL(text_end) = $
LABEL(skip):
    ', `
        push bc
        push de
        push hl
        ld de, $1
        ld hl, $2
        ld bc, $3
        ldir
        pop hl
        pop de
        pop bc
    ')
')




dnl  Copy memory to DE
dnl  Usage: MEMCPY_DE(FROM, BYTES)

define(MEMCPY_DE, `
    ifelse(`$2', `', `
        push bc
        push hl
        ld hl, LABEL(text)
        ld bc, LABEL(text_end)-LABEL(text)
        ldir
        pop hl
        pop bc
        jp LABEL(skip)
LABEL(text):
        DEFB $1
        DEFC LABEL(text_end) = $
LABEL(skip):
    ', `
        push bc
        push hl
        ld hl, $1
        ld bc, $2
        ldir
        pop hl
        pop bc
    ')
')




