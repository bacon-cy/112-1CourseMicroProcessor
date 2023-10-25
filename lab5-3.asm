List p=18f4520
    #include"xc.inc"
    GLOBAL _lcm
    PSECT mytext, local, class=CODE, reloc=2
 
    _lcm:
    MOVF 0x01, w
    CPFSLT 0x03 ;if [0x03] < wreg (b < a), skip
    GOTO change
    MOVWF 0x11 ; a is bigger
    MOVFF 0x03, 0x12 ; b is smaller
    change:
    MOVWF 0x12 ; a is smaller
    MOVFF 0x03, 0x11 ; b is bigger
    
    ; find gcd first
    ; gcd(a,b) : keep calling recursive gcd(b, a%b);, until b==0, a:0x11, b:0x12, and a >= b
	gcd:
	    MOVF 0x12, w
	    BZ finish
	    modd:
	    SUBWF 0x11, f
	    CPFSLT 0x11 ; [0x11] < wreg ; if a < b skip
	    GOTO modd
	    MOVF 0x11, w
	    MOVFF 0x12, 0x11
	    MOVWF 0x12
	    GOTO gcd
	finish: ; [0x11] = gcd
	CLRF 0x12
    ; calculate lcm
    ; lcm = a * b / gcd
    MOVF 0x01, w
    MULWF 0x03 ; PROD = a * b
    
    ; turn gcd into negative
    COMF 0x11
    COMF 0x12
    INCF 0x12
    BTFSC STATUS, 0 ; if carry bit is 0, skip the next line
    INCF 0x11
	MOVLW 0x08 ; count for loop
	MOVWF 0x05
	div: ; Divisor : gcd, 0x11:0x12 / Dividend : PROD / Quotient : 0x0E:0x0F
	; PROD+=(-gcd) , subtract | gcd |
	MOVF 0x12, w
	ADDWF PRODL, w
	MOVWF 0x14 ; save the result in 0x14
	MOVF 0x11, w
	ADDWFC PRODH, w
	MOVWF 0x13 ; save the result in 0x13
	; if reminder >= 0, quotient += 1
	BTFSS 0x13, 7
	GOTO bigger
	GOTO smaller
	bigger:
	INCF 0x0F
	BTFSC STATUS, 0 ; if carry
	INCF 0x0E
	MOVFF 0x14, PRODL
	MOVFF 0x13, PRODH
	smaller:
	; right shift gcd 
	RRNCF 0x12
	BCF 0x12, 7
	BTFSC 0x11, 0
	BSF 0x12, 7
	RRNCF 0x11
	BSF 0x11, 7 ; since it is negative, set the right most bit 1
	
	; left shift quotient
	RLNCF 0x0E
	BTFSC 0x0F, 7
	BSF 0x0E, 0
	RLNCF 0x0F
	BCF 0x0F, 0
	
	DECF 0x05
	BNZ div
	
    MOVFF 0x0E, 0x02
    MOVFF 0x0F, 0x01
    
    RETURN
	    
	    
	
	
	    
    
	    
	
    
    
    RETURN


