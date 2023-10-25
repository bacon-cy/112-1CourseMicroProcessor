List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00
	
	MOVLW 0x2b ; hex
	MOVLW D'15' ; digit
	MOVLW B'00000111' ; binary
	MOVWF 0x00 ; put working register value into file register 0x00
	MOVWF 0x01 ; put working register value into file register 0x01
	CLRF 0x00 ; clear up file register 0x00
	CLRF WREG ; clear up working register
	INCF WREG ; wreg ++
	DECF WREG ; wreg --
	
	; ADDWF ;
	MOVLW 0x31
	MOVWF 0x00
	MOVLW 0x02
	ADDWF 0x00; add wreg to file register 0x00
	ADDWF 0x00, 0 ; put the result of (wreg + 0x00) into wreg, since the parameter 0
	ADDWF 0x00, W ; put the result into wreg
	ADDWF 0x00, F ; put the result into 0x00
	
	MOVF 0x00, 0 ; put the value of file register 0x00 to working register
	MOVF 0x00, W ; put the value of file register 0x00 to working register
	
	; init before loop ;
	inital:
	    CLRF 0x00;
	    MOVLW 0x05;
	    MOVWF 0x00;
	; loop ;
	start: ; label
	    DECFSZ 0x00 ; [0x000] --, if the value == 0, skip the next line code
	    CPFSEQ 0x00 ; skip the next line code if wreg == the value of [0x000]
	    CPFSGT 0x00 ; skip if [0x00] > wreg
	    CPFSLT 0x00 ; skip if [0x00] < wreg
	    GOTO start
	    NOP ; do nothing, use for debug
	
	RRNCF 0x00 ; right shift (the right most bit will be rotated to the left most bit)
	RLNCF 0x00 ; left shift
	BTFSS 0x00, 3 ; if the 3rd bit(count from right with the right most one is 0th) is 1, then skip next line
	end
	
	