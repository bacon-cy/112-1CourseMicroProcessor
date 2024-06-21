LIST p=18f4520
#include<p18f4520.inc>
    CONFIG OSC = INTIO67 ; 1 MHZ
    CONFIG WDT = OFF
    CONFIG LVP = OFF

    L1	EQU 0x14
    L2	EQU 0x15
    org 0x00
	
; Total_cycles = 2 + (2 + 7 * num1 + 2) * num2 cycles
; num1 = 200, num2 = 180, Total_cycles = 252360
; Total_delay ~= Total_cycles/1M = 0.25s
DELAY macro num1, num2 
    local LOOP1         ; innerloop
    local LOOP2         ; outerloop
    MOVLW num2          ; 2 cycles
    MOVWF L2
    LOOP2:
	MOVLW num1          ; 2 cycles
	MOVWF L1
    LOOP1:
	NOP                 ; 7 cycles
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1        ; 2 cycles
	BRA LOOP2
endm

	
start:
int:
; let pin can receive digital signal 
MOVLW 0x0f
MOVWF ADCON1            ;set digital IO
CLRF PORTB
BSF TRISB, 0            ;set RB0 as input TRISB = 0000 0001
CLRF LATA
CLRF TRISA            ;set RA0~7 as output TRISA = 0000 0000
    
; ckeck button
check_process:          
   BTFSC PORTB, 0 ; if push, then PORTB = 0, since button is pull-up resistor
   BRA check_process
   BRA lightup
   
    
lightup:
    BTFSC LATA, 0
    goto state1
    BTFSC LATA, 1
    goto state2
    BTFSC LATA, 2
    goto state3
    BTFSC LATA, 3
    goto state4
    state0:
    BSF LATA, 0
    goto finish
    state1:
    state2:
    state3:
    RLNCF LATA
    goto finish
    state4:
    CLRF LATA
    finish:
    DELAY d'200', d'90' ;delay 0.25s
    BRA check_process
end


