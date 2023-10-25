List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; PC = 0x00
	
	input_data macro addr, literal
	    MOVLW literal
	    MOVWF addr
	endm
	
	input_data 0x00, 0 ; 0x00 = ans
	input_data 0x01, 8 ; 0x01 = n
	input_data 0x02, 3 ; 0x02 = k
	input_data 0x03, 0 ; 0x03 = constant 0
	
	Fact:
	; C(n, 0)
	INCF 0x00
	MOVF 0x02, w
	CPFSLT 0x03 ; skip if 0 < k (k!=0), [0x03] != [wreg] = 0
	RETURN
	DECF 0x00
	
	; C(n, n)
	INCF 0x00
	MOVF 0x02, w
	SUBWF 0x01, w ; wreg = n-k,  [0x01] - wreg
	CPFSLT 0x03 ; skip if  0 < n-k (n-k!=0)
	RETURN
	DECF 0x00
	
	;recursive
	; C(n-1, k-1)
	DECF 0x01
	DECF 0x02
	RCALL Fact
	
	; C(n-1, k)
	INCF 0x02
	RCALL Fact
	
	INCF 0x01
	RETURN
	end
