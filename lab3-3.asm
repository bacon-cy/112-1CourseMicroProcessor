List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW 0x00
	MOVWF TRISC
	
	MOVLW 0x0F
	MOVWF TRISB ; multiplicand
	
	MOVLW 0x03
	MOVWF TRISA
	
	; [wreg] = TRISA
	loop:
	RLNCF TRISC ; left shift the anwser
	BTFSC TRISB, 7 ; if the MSB of multiplicand is 1, then add, else do nothing.
	ADDWF TRISC, f
	BCF TRISB, 7 ; left shift the multiplicand
	RLNCF TRISB
	BNZ loop ; without goto, use BNZ instead
	end


