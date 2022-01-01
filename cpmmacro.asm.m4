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

dnl ===========================================================================
dnl Generate a "unique" label by concatenating the source line number with a suffix
dnl ===========================================================================
define(LABEL, ``L'__line__`_$1'')


dnl ===========================================================================
dnl Inline macro to embed version number
dnl Usage: VERSION(RELEASE)
dnl    RELEASE is a string
dnl ===========================================================================

define(VERSION, `
        jp LABEL(skip)
        DEFM "Ver ", $1
LABEL(skip):
')


dnl ===========================================================================
dnl ENTER (requires use of EXIT)
dnl Usage ENTER(STACK_BUFFER_SIZE)
dnl ===========================================================================

define(ENTER, `
        ld (__OLD_STACK_SP), sp
        ld sp, __STACK_BUFFER

SECTION data_user
__OLD_STACK_SP:
        DEFS  2

    ifelse(`$1', `', `
        DEFS 34
        ', `
        DEFS $1
    ')
__STACK_BUFFER:

SECTION code_user
')


dnl ===========================================================================
dnl Exit
dnl Usage: EXIT(JP_ADDR)
dnl ===========================================================================

define(EXIT, `
__EXIT:
        ld SP, (__OLD_STACK_SP)

    ifelse(`$1', `', `
        ret
        ', `
        jp $1
    ')
')


dnl ===========================================================================
dnl  Copy memory
dnl  Usage: MEMCPY(DEST, SOURCE, BYTES)
dnl         MEMCPY(DEST, STRING)
dnl ===========================================================================

define(MEMCPY, `
        push bc
        push de
        push hl

        ifelse(`$1', `', , `ld de, $1')
        ifelse(`$3', `', `
            ld hl, LABEL(text)
            ld bc, LABEL(text_end)-LABEL(text)
        ', `
            ifelse(`$2', `', , `ld hl, $2')
            ld bc, $3
        ')

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


dnl ===========================================================================
dnl  Fill memory
dnl  Usage: MEMSET(DEST, VALUE, BYTES)
dnl ===========================================================================

define(MEMSET, `
        push bc
        push de
        push hl
        ifelse(`$1', `', , `ld de, $1')
        ld hl, de
        inc de
        ld (hl), $2
        ld bc, $3 - 1
        ldir
        pop hl
        pop de
        pop bc
')


dnl ===========================================================================
dnl  Compare memory
dnl  Usage: MEMCMP(DEST, SOURCE, BYTES)
dnl         Zero flag is set if both regions are the same
dnl ===========================================================================

define(MEMCMP, `
        push bc
        push de
        push hl
        ifelse(`$1', `', , `ld de, $1')
        ifelse(`$2', `', , `ld hl, $2')
        ld bc, $3

LABEL(repeat):
        ld a, b
        or c
        jr z, LABEL(abort)

        ld a, (de)
        cpi
        inc de
        jr z, LABEL(repeat)

LABEL(abort):
        pop hl
        pop de
        pop bc
')


dnl ===========================================================================
dnl  Compare memory ASCII
dnl  Usage: MEMCMPA(DEST, SOURCE, BYTES)
dnl         MEMCMPA(DEST, STRING)
dnl         Zero flag is set if both regions are the same
dnl ===========================================================================

define(MEMCMPA, `
        push bc
        push de
        push hl
        ifelse(`$1', `', , `ld de, $1')
        ifelse(`$3', `', `
            ld hl, LABEL(text)
            ld bc, LABEL(text_end)-LABEL(text)
        ', `
            ifelse(`$2', `', , `ld hl, $2')
            ld bc, $3
        ')

LABEL(repeat):
        ld a, b
        or c
        jr z, LABEL(abort)

        ld a, (de)
        and 0x7f
        cp (hl)
        inc de
        inc hl
        dec bc
        jr z, LABEL(repeat)

LABEL(abort):
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
