;; Macro library for CP/M system routines
;; September 2021

;; Macros n this library

DEFC EOF = 0x1a
DEFC ESC = 0x1b
DEFC CR = 13
DEFC LF = 10
DEFC TAB = 9
DEFC BLANK = 32  ; space characater
DEFC PERIOD = 46 ; decimal point
DEFC COMMA = 44

;; Generate a "unique" label by concatenating the source line number with a suffix
define(LABEL, ``L'__line__`_$1'')

;; Inline macro to embed version number
;; Usage: VERSION(RELEASE)
;;    RELEASE is a string
define(VERSION, `
    jp LABEL(skip)
    DEFM "Ver ", $1
LABEL(skip):
    ')

