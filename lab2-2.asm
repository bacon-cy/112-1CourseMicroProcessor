List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	;answer = x1 + x2
	; [0x01] = [0x00] + [0x18]
	; [0x17] = [0x18] - [0x00]
	; [0x02] = [0x01] + [0x17]
	; [0x16] = [0x17] - [0x01]
	
	MOVLW 0x0A ; [wreg] = NUM1
	MOVWF 0x00 ; [0x00] = 0x05
	MOVLW 0x03 ; [wreg] = NUM2
	MOVWF 0x18 ; [0x18] = 0x02
	LFSR 0, 0x001 ; LFSR 0 = 0x001 ; answer
	LFSR 1, 0x000 ; LFSR 1 = 0x000 ; x1
	LFSR 2, 0x018 ; LFSR 2 = 0x018 ; x2
	MOVLW 0x08 ; eight times for looping
	MOVWF 0x09
	loop:
	MOVF INDF1, w ; [wreg] = [0x00]
	ADDWF INDF2, w ; [wreg] = [0x00] + [0x18]
	MOVWF POSTINC0 ; [FSR0 (0x01)] = [wreg]
	
	MOVF POSTDEC2, w ; [wreg] = [0x18], FSR2-- (0x17)
	SUBWF POSTINC1, w ; [wreg] = [0x00] - [wreg], FSR1++ (0x01)
	MOVWF INDF2 ; [FSR2 (0x17)] = [wreg]
	
	DECFSZ 0x09
	GOTO loop
	end
	
	
	
	

