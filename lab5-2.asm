List p=18f4520
    #include"xc.inc"
    GLOBAL _multi_signed
    PSECT mytext, local, class=CODE, reloc=2
    neg_to_pos macro in
    DECF in
    COMF in
    endm
    
    _multi_signed:
	; 0x01:a(8bit), 0x02:b (4bit)
	MOVWF 0x03
	MOVFF 0x01, 0x02
	MOVFF 0x03, 0x01
	; let 0x10:0x11=|a| , 0x12=|b|
	; let the answer first be in 0x05 and 0x06
	; return unsigned int (16 bit)
	
	; init
	MOVLW 0x00
	MOVWF 0x05
	MOVWF 0x06
	
	MOVLW 0x08 ; counter for multipling
	MOVWF 0x04
	
	; change negative numbers into positive, 0x11:|a| ;0x12: |b|
	MOVLW 0x00
	MOVFF 0x01, 0x11
	BTFSS 0x11, 7
	GOTO next1
	neg_to_pos 0x11
	next1:
	MOVFF 0x02, 0x12
	BTFSS 0x12, 7
	GOTO next2
	neg_to_pos 0x12
	next2:

	multiply_loop:
	    ; left shift the answer, we have to fix the Low Byte shift to HighByte problem
	    RLNCF 0x05
	    BTFSC 0x06, 7
	    BSF 0x05, 0
	    RLNCF 0x06
	    BCF 0x06, 0
	    
	    ; if the MSB of multiplier is 1, then add multiplicand, else do nothing.
	    ; Everytime addtion should to consider the Low Byte carry
	    BTFSS 0x12, 7
	    GOTO do_nothing
	    ; lab3-2, two 2-byte number addition
	    ; low byte addition
		MOVF 0x11, w
		ADDWF 0x06, f 
	    ; high byte addition + carry
		MOVF 0x10, w
		BTFSC STATUS, 0 ; if carry bit is 0, skip the next line
		INCF WREG ; [wreg] = [0x12] + carry
		ADDWF 0x05, f ; [0x05] = [0x05] + [0x10] + carry
	    do_nothing:

	    ; left shift the multiplier we have to fix the Low Byte shift to HighByte problem
	    BCF 0x12, 7
	    RLNCF 0x12
	    DECF 0x04
	    BNZ multiply_loop
	    
	; sign bit = highest bit XOR
	; calculate sign bit 
	MOVF 0x01, w
	XORWF 0x02, w
	BTFSS WREG, 7
	GOTO finish
	; if negative, turn into 2's complement (y'+1)
	COMF 0x05
	COMF 0x06
	INCF 0x06
	BTFSC STATUS, 0 ; if carry bit is 0, skip the next line
	INCF 0x05
	
	finish:
	; Since little edian, so the low byte should be placed in 0x01
	MOVFF 0x05, 0x02
	MOVFF 0x06, 0x01
	RETURN



