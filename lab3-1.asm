List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	; arithmetic right shift once
	MOVLW b'11110000'
	MOVWF TRISA
	RRNCF TRISA ; right rotate
	BSF TRISA, 7 ; set the MSB to 1
	BTFSS TRISA, 6 ; if 6th bit in TRISA is 1, then skip
	BCF TRISA, 7 ; if the sign bit is 0, clear the MSB
	NOP
	; logical right shift once
	RRNCF TRISA ; right rotate
	BCF TRISA, 7 ; clear 7th bit
	NOP
	end


