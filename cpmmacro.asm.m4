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

;; Inlione macro to embed version number
;; Usage: VERSION(RELEASE)
;;    RELEASE is a string
define(VERSION, `
    jp version_skip
    DEFM "Ver ", $1
version_skip:
    ')
