List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	CLRF WREG
	MOVLW d'255'
	; current round number is in 0x00
	MOVWF 0x00 ; load wreg value into 0x00
	MOVWF 0x01 ; load wreg value into 0x01
	MOVWF 0x02 ; load wreg value into 0x02
	
	RRCF 0x01, f ; [0x01] = [0x00] >> 1 ; y = x >> 1
	COMF WREG, w ; [wreg] = x'
	ANDWF 0x01, f ; [0x01] = x'y
	
	RRCF 0x02, f ; [0x02] = [0x00] >> 1 ; y = x >> 1
	COMF 0x02, f ; [0x02] = y'
	COMF WREG, w ; [wreg] = x
	ANDWF 0x02, w ; [wreg] = xy'
	
	IORWF 0x01, f ; [0x01] = [wreg] || [0x01] = x'y + xy'
	
	MOVLW b'01111111' ; [wreg] = b'01111111'
	ANDWF 0x01, f ; [0x01] = [0x01] && b'01111111'
	COMF WREG, w ; [wreg] = b'10000000'
	ANDWF 0x00, w ; [wreg] = [wreg] && [0x00]
	IORWF 0x01, f ; [0x01] = [wreg] || [0x01]
	end


