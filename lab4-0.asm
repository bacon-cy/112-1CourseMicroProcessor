List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; PC = 0x00
	
	;PCL : program counter low 8 bits
	
	MOVLW 0x01; PCL+=2
	MOVWF PCL ; PCL+=4 since MOVFF saved 16 bit data
	
	MOVLW 0x08; wreg = 8
	MOVWF PCL ; PCL = 0x08
	
	MOVLW label ; wreg = address of label
	MOVWF PCL ; PCL = label
	
	label:
	    NOP
	    GOTO finish
	
	    
	;stack
	; ????function call??????push?stack??
	; STKPTR ; stack pointer, ???stack???????? (????function call?stack??????????)
	; TOS ; top of stack, ??????
	    
	;subroutine
	    ;label, return, rcall
	funct1:
	    NOP
	    RETURN
	    
	funct2:
	    RCALL funct1 ; this will make stkptr = 2
	    RETURN

	finish:
	    NOP
	    RETURN
	       
	; function call
	RCALL funct1
	NOP
	RCALL finish    
	
	; macro
	    ;macro_name macro p1,p2,p3,p4 
	    ;your macro code
	    ;endm
	MOVLF macro literal, F
	    MOVLW literal
	    MOVWF F
	    NEGF F ; make F become negative
	    endm
	    
	MOVLF 0x01, 0x00
	; if there are a lot of macro, they will make program memory full
	; we should notice that, the skip function only skip one line, if added a macro
	; after a skip operator, it will only slip the first line of macro
	
	; signed multiply
	MULWF ; two 8 bit multiply
	end


