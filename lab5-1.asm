List p=18f4520
    #include"xc.inc"
    GLOBAL _is_square
    PSECT mytext, local, class=CODE, reloc=2
    
	; the function _is_square will be called by main.c
	_is_square:
	    ; the input is in wreg and 0x01
	    MOVLW 0x0F
	    MOVWF 0x03 ; [0x03] = D'15'
	    _is_square_loop:
		    MOVF 0x03, w
		    MULWF 0x03
		    MOVF PRODL, w
		    CPFSEQ 0x01
		    GOTO not_equal
		    equal:
			    MOVLW 0x01
			    GOTO finish
		    not_equal:
			    DECF 0x03
			    BNZ _is_square_loop
		    MOVLW 0xFF
	    finish:
		    MOVFF WREG, 0x01
	    RETURN



