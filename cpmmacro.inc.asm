; Macro library for CP/M system routines
; Justin Skists 2021


DEFC EOF = 0x1a
DEFC ESC = 0x1b
DEFC CR = 13
DEFC LF = 10
DEFC TAB = 9
DEFC BLANK = 32  ; space characater
DEFC PERIOD = 46 ; decimal point
DEFC COMMA = 44

; ===========================================================================
; Inline macro to embed version number
; Usage: VERSION(RELEASE)
;    RELEASE is a string
; ===========================================================================

MACRO VERSION str
LOCAL skip
        jp skip
        DEFM "Ver ", str
skip:
ENDM


; ===========================================================================
; ENTER (requires use of EXIT)
; Usage ENTER
;       ENTER_SP stack_size
; ===========================================================================

MACRO ENTER_SP space
    ld (__OLD_STACK_SP), sp
    ld sp, __STACK_BUFFER

SECTION data_user
__OLD_STACK_SP:
    DEFS  2

    DEFS space
__STACK_BUFFER:

SECTION code_user
ENDM

MACRO ENTER
        ENTER_SP 34
ENDM

; ===========================================================================
; Exit
; Usage: EXIT
; ===========================================================================

MACRO EXIT
__EXIT:
        ld SP, (__OLD_STACK_SP)
        ret
ENDM



; ===========================================================================
;  Copy memory
;  Usage: MEMCPY(DEST, SOURCE, BYTES)
;         MEMCPY_DE(SOURCE, BYTES)  DE=DEST
;         MEMCPY_HL(DEST, BYTES)    HL=SOURCE
;         MEMCPY_DEHL(BYTES)        DE=DEST, HL=SOURCE
;
;         STRCPY(DEST, STRING)
;         STRCPY_DE(STRING)         DE=DEST
; ===========================================================================

MACRO MEMCPY_DEHL bytes
    push bc
    ld bc, bytes
    ldir
    pop bc
ENDM

MACRO MEMCPY_DE source, bytes
    push hl
    ld hl, source
    MEMCPY_DEHL bytes
    pop hl
ENDM

MACRO MEMCPY_HL dest, bytes
    push de
    ld de, dest
    MEMCPY_DEHL bytes
    pop de
ENDM

MACRO MEMCPY dest, source, bytes
    push hl
    push de
    ld hl, source
    ld de, dest
    MEMCPY_DEHL bytes
    pop de
    pop hl
ENDM

MACRO STRCPY_DE string
LOCAL skip
LOCAL text
LOCAL text_end

    push hl
    ld hl, text
    MEMCPY_DEHL text_end-text
    jp skip

text:
    DEFB string
    DEFC text_end = $

skip:
    pop hl
ENDM

MACRO STRCPY dest, string
    push de
    ld de, dest
    STRCPY_DE string
    pop_de
ENDM


; ===========================================================================
;  Fill memory
;  Usage: MEMSET(DEST, VALUE, BYTES)
; ===========================================================================

MACRO MEMSET_DE val, bytes
    push bc
    push hl
    ld hl, de
    inc de
    ld (hl), val
    ld bc, bytes - 1
    ldir
    pop hl
    pop bc
ENDM


MACRO MEMSET dest, val, bytes
    push de
    ld de, dest
    MEMSET_DE val, bytes
    pop de
ENDM


; ===========================================================================
;  Compare memory
;  Usage: MEMCMP(DEST, SOURCE, BYTES)
;         MEMCMP_DE(SOURCE, BYTES)  DE=DEST
;         MEMCMP_HL(DEST, BYTES)    HL=SOURCE
;         MEMCMP_DEHL(BYTES)        DE=DEST, HL=SOURCE
;         Zero flag is set if both regions are the same
; ===========================================================================

MACRO MEMCMP_DEHL bytes
LOCAL repeat
LOCAL abort
    push bc
    ld bc, bytes

repeat:
    ld a, b
    or c
    jr z, abort

    ld a, (de)
    cpi
    inc de
    jr z, repeat

abort:
    pop bc
ENDM

MACRO MEMCMP_DE source, bytes
    push hl
    ld hl, source
    MEMCMP_DEHL bytes
    pop hl
ENDM

MACRO MEMCMP_HL dest, bytes
    push de
    ld de, dest
    MEMCMP_DEHL bytes
    pop de
ENDM

MACRO MEMCMP dest, source, bytes
    push hl
    push de
    ld hl, source
    ld de, dest
    MEMCMP_DEHL bytes
    pop de
    pop hl
ENDM


; ===========================================================================
;  Compare memory ASCII
;  Usage: MEMCMPA(DEST, SOURCE, BYTES)
;         MEMCMPA_DE(SOURCE, BYTES)  DE=DEST
;         MEMCMPA_HL(DEST, BYTES)    HL=SOURCE
;         MEMCMPA_DEHL(BYTES)        DE=DEST, HL=SOURCE
;
;         STRCMP(DEST, STRING)
;         STRCMP_DE(STRING)          DE=DEST
;         Zero flag is set if both regions are the same
; ===========================================================================

MACRO MEMCMPA_DEHL bytes
    LOCAL repeat
    LOCAL abort
    push bc
    ld bc, bytes

repeat:
    ld a, b
    or c
    jr z, abort

    ld a, (de)
    and 0x7f
    cp (hl)
    inc de
    inc hl
    dec bc
    jr z, repeat

abort:
    pop bc
ENDM

MACRO MEMCMPA_DE source, bytes
    push hl
    ld hl, source
    MEMCMPA_DEHL bytes
    pop hl
ENDM

MACRO MEMCMPA_HL dest, bytes
    push de
    ld de, dest
    MEMCMPA_DEHL bytes
    pop de
ENDM

MACRO MEMCMPA dest, source, bytes
    push hl
    push de
    ld hl, source
    ld de, dest
    MEMCMPA_DEHL bytes
    pop de
    pop hl
ENDM

MACRO STRCMP_DE string
LOCAL skip
LOCAL text
LOCAL text_end

    push hl
    ld hl, text
    MEMCPY_DEHL bytes
    jp skip

text:
    DEFB string
    DEFC text_end = $

skip:
    pop hl
ENDM

MACRO STRCMP dest, string
    push de
    ld de, dest
    STRCMP_DE string
    pop_de
ENDM


; ===========================================================================
;  To Upper
;  Usage: TOPUPPER_REG(REG)
;         TOPUPPER()     (assumes A register)
; ===========================================================================
MACRO TOUPPER
LOCAL abort
    cp 0x61   ; Z + 7
    jp c, abort

    and 0x5f  ;make uppercase

abort:
ENDM

MACRO TOUPPER_REG reg
    ld a, reg
    TOUPPER
    ld reg, a
ENDM


; ===========================================================================
;  retrieve the upper nybble from a register
;  Usage: UPPER_NYB_REG(REG)
;         UPPER_NYB()     (assumes A register)
; ===========================================================================

MACRO UPPER_NYB
    rar
    rar
    rar
    rar
    and 0x0f
ENDM

MACRO UPPER_NYB_REG reg
    ld a, reg
    UPPER_NYB
    ld reg, a
ENDM


; ===========================================================================
;  retrieve the lower nybble from a register
;  Usage: LOWER_NYB_REG(REG)
;         LOWER_NYB()     (assumes A register)
; ===========================================================================

MACRO LOWER_NYB
    and 0x0f
ENDM

MACRO LOWER_NYB_REG reg
    ld a, reg
    LOWER_NYB
    ld reg, a
ENDM

