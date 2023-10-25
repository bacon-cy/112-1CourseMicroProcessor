List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW 0x0A ; x1 value
	MOVWF 0x00
	MOVWF 0x01 ; copy x1 into 0x01
	
	MOVLW 0x10 ; x2 value
	MOVWF 0x02
	
	loop:
	BTFSS 0x00, 0 ; if the rightmost bit is 1, then odd, then skip next line code
	GOTO even
	
	; odd ;
	DECF 0x02 ; [0x02]--
	GOTO checkEndLoop
	
	even: ; even ;
	INCF 0x02 ; [0x02]++
	
	checkEndLoop:
	RRNCF 0x00 ; right shift 0x00
	MOVF 0x00, W ; wreg = [0x00]
	CPFSEQ 0x01 ; if wreg == [0x01], skip next line code
	GOTO loop
	
	end
	
	

