List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	; first number Low
	MOVLW 0x12
	MOVWF 0x01
	; second number Low
	MOVLW 0x93
	MOVWF 0x11
	
	ADDWF 0x01, w ; [wreg] =  [0x01] + [0x11]
	MOVWF 0x21 ; [0x21] = [wreg]
	
	; first number High
	MOVLW 0x76
	MOVWF 0x00
	
	; second number High
	MOVLW 0x44
	MOVWF 0x10
	
	BTFSC STATUS, 0 ; if carry bit is 0, skip the next line
	INCF WREG ; [wreg] = [0x10] + carry
	ADDWF 0x00, w ; [wreg] = [0x10] + carry + [0x00]
	MOVWF 0x20
	
	end


