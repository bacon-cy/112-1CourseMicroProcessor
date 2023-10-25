List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW 0x15 ; [wreg] = NUM1
	MOVLB 0x1 ; BSR = 1
	MOVWF 0x00, 1 ; bank select, copy [wreg] into [0x100]
	MOVLW 0x12 ; [wreg] = NUM2
	MOVWF 0x01, 1 ; bank select, copy [wreg] into [0x101]
	
	MOVLW 0x07 ; [0x01] = 7 for loop counting
	MOVWF 0x01
	
	LFSR 0, 0x100 ; start from 0x100
	loop:  ; assume calculating [0x102] in comments
	MOVF POSTINC0, w ; [wreg] = [LRFR0 (0x100)], LFSR0++ (0x101)
	BTFSS FSR0L, 0 ; (0x101) ; if bit 0 of LFSR 0 is 1 then skip, this is the objective address - 1 ; thus if bit 0 = 1, meaning that the objective address (0x102) is even, have to sum (skip the goto minus line)
	GOTO minus
	ADDWF POSTINC0, w ; [wreg] = [0x101] + [wreg (0x100)], LFSR0++ (0x102)
	GOTO answ
	minus:
	SUBWF POSTINC0, w; [wreg] = [0x102] - [wreg (0x101)], LFSR0++ (0x103)
	answ:
	MOVWF POSTDEC0 ; [0x102] = [wreg], LFSR0-- (0x101)
	
	DECFSZ 0x01 ; if 0x01 = 0, the end
	GOTO loop
	end
	
	
	

