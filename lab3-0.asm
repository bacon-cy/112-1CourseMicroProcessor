; STATUS Register
    ;| 7 | 6 | 5 | 4 |  3 | 2 |  1 | 0 |
    ;| - | - | - | N | OV | Z | DC | C |
    ; N     Negative
    ; OV  Overflow
    ; Z      Zero
    ; DC   Digit Carry  0x0F ? 0x10
    ; C      Carry
; Bank Select Register
    ; BSR, 4 bits

; Byte-oriented operation
    XORWF
    ANDWF
    CLRF 0x01 ; clear up [0x01] to 0
; Unconditional Branch
    BRA here
    GOTO here
    
; Conditional Branch
    BC	here	;Branch if Carry
    BN	here	;Branch if Negative
    BNC here	;Branch if Not Carry
    BNOV here	;Branch if Not Overflow
    BNZ	 here 	;Branch if Not Zero
    BOV here	;Branch if Overflow
    BZ	here  	;Branch if Zero

    here:
    NOP
