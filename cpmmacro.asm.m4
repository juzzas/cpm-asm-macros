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
        push bc
        push de
        push hl
        ifelse(`$1', `', , `ld de, $1')
        ifelse(`$2', `', , `ld hl, $2')
        ifelse(`$3', `', `ld bc, LABEL(text_end)-LABEL(text)', `ld bc, $3' )
        ldir
        pop hl
        pop de
        pop bc
    ifelse(`$3', `', `
        jp LABEL(skip)
LABEL(text):
        DEFB $2
        DEFC LABEL(text_end) = $
LABEL(skip):
    ')
')


