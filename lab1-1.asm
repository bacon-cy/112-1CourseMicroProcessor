List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW 0x22 ; x1 value
	MOVWF 0x00
	
	MOVLW 0x88 ; x2 value
	MOVWF 0x01
	
	ADDWF 0x00, w ; x1 + x2 value, wreg = x2, wreg += [0x00]
	MOVWF 0x10 ;
	
	MOVLW 0xAF ; y1 value
	MOVWF 0x02
	
	MOVLW 0x04 ; y2 value
	MOVWF 0x03
	
	SUBWF 0x02, w ; y1 - y2 value, wreg = y1, wreg -= y2
	MOVWF 0x11
	
	CPFSEQ 0x10 ; if wreg (wreg = y1-y2) equals [0x10] (x1+x2)
	GOTO notEqual
	MOVLW 0xff ; wreg = 0xff
	MOVWF 0x20 ; [0x20] = [wreg] = 0xff
	GOTO equal
	
	notEqual: ; else
	MOVLW 0x01 ; wreg = 0x01
	MOVWF 0x20 ; [0x20] = [wreg] = 0x01
	
	equal:
	end