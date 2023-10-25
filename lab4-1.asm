List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; PC = 0x00
	
	Add_mul macro xh, xl, yh, yl
	    ;add, same as lab 3-2
		;low
		MOVLW xl
		ADDLW yl
		MOVWF 0x01
		;high
		MOVLW xh
		BTFSC STATUS, 0
		INCF WREG
		ADDLW yh
		MOVWF 0x00
	    ;mul, MULWF
		MULWF 0x01 ; prod = [0x00] * [0x01]
		; low byte is fine, move to the answer address
		MOVF PRODL, w
		MOVWF 0x11
		    ; == MOVFF PRODL, 0x11 ; [0x11] = [PRODL]
		; if 0x00 is negative, then the high byte of product substract 0x01
		MOVF 0x01, w
		BTFSC 0x00, 7
		SUBWF PRODH, f
		; if 0x01 is negative, then the high byte of product substract 0x00
		MOVF 0x00, w
		BTFSC 0x01, 7
		SUBWF PRODH, f
		MOVFF PRODH, 0x10
	endm
	
	Add_mul 0xFF, 0xEB, 0x00, 0x0F
	;0x00, 0xFF, 0x02, 0x0C
	;0x04, 0x02, 0x0A, 0x04
	NOP
    end
		
		
		
	    
	    

