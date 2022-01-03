dnl Macro library for CP/M system routines
dnl September 2021

dnl ############################################################################
dnl Macros in this library
dnl
dnl ENTER
dnl EXIT
dnl MEMCMP(DEST, SOURCE, BYTES)
dnl MEMCMPA(DEST, SOURCE, BYTES)
dnl MEMCPY(DEST, SOURCE, BYTES)
dnl PCHAR(VAL)
dnl READCH(REG)
dnl SYSF(FUNC, AE)
dnl TOUPPER(REG)
dnl UPPER_NYB(REG)
dnl VERSION(RELEASE)
dnl ############################################################################


DEFC BDOS = 5
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
dnl  Read character from console
dnl  Usage: READCH(REG)
dnl         READCH()     (assumes A register)
dnl ===========================================================================
define(READCH, `
        ifelse(`$1', `', , `ld a, $1')
        call SYSF_rdch
')


dnl ===========================================================================
dnl  Put character to console
dnl  Usage: PUTCH(REG)
dnl         PUTCH()     (assumes A register)
dnl ===========================================================================
define(PUTCH, `
        ifelse(`$1', `', , `ld a, $1')
        call SYSF_pch2
')

dnl ===========================================================================
dnl System Function
dnl Macro to generate BDOS calls
dnl FUNC is a BDOS function number for reg C
dnl
dnl Usage:    open:  SYSF 15
dnl           pchar: SYSF 2, AE
dnl ===========================================================================

define(SYSF, `
        push hl
        push de
        push bc
        ld c, $1
        ifelse(`$2', `', `
            call BDOS
        ', `
            ld e, a
            push af
            call BDOS
            pop af
        ')
        pop bc
        pop de
        pop hl
        ret
')

define(SYSF_JT, `
SYSF_rdch: SYSF(1)
SYSF_pch2: SYSF(2, AE)
')

dnl ===========================================================================
dnl  To Upper
dnl  Usage: TOUPPER(REG)
dnl         TOUPPER()     (assumes A register)
dnl ===========================================================================

define(TOUPPER, `
        ifelse(`$1', `', , `ld a, $1')

        cp 0x61   ; Z + 7
        jp c, LABEL(not_up)
        and 0x5f  ;make uppercase

LABEL(not_up):
        ifelse(`$1', `', , `ld $1, a')

')


dnl ===========================================================================
dnl  retrieve the upper nybble from a register
dnl  Usage: UPPER_NYB(REG)
dnl         UPPER_NYB()     (assumes A register)
dnl ===========================================================================

define(UPPER_NYB, `
        ifelse(`$1', `', , `ld a, $1')

        rar
        rar
        rar
        rar
        and 0x0f

        ifelse(`$1', `', , `ld $1, a')
')

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


