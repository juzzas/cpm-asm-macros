; TESTVER to test macro VERSION

DEFC BOOT = 0

INCLUDE "cpmmacro.inc.asm"

SECTION code_user

start:
    ;ENTER
    ENTER_SP 16
    VERSION  "20210906"
    EXIT

DEFC end = $

