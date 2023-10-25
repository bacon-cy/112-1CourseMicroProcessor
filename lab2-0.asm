List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; PC = 0x00
	; https://hackmd.io/@6sDOReJWSiuPCQpk167vTg/HkNR5UeT3#1-What-is-Addressing-Mode; 
	
	; No Operation
	NOP
	
	; Inherent Addressing (Implied Addressing)
	SLEEP
	RESET ; clear all register and flag
	DAW ; Decimal adjust wreg, BCD +6 ??
	
	; Literal Addressing
	; 8 bit : MOVLW?ADDLW?SUBLW?ANDLW
	; 20 bit : GOTO
	; ?? project lab1 ? lab0.asm
	
	; Direct Accessing
	MOVLB 0x4 ; BSR = 4
	MOVWF 0x10, 1 ; move [wreg] into 0x410 ; f[, a] f: a: if a = 0, access bank (default), if a = 1, bank select
	MOVFF ; file register length = 12 bit, no banking, directly access 4096 bytes
	
	; Indirect Accessing
	;Similar to pointers in C
	LFSR 0, 0x000 ; ? LFSR 0 ?? 0x000
	LFSR 1, 0x010 ; ? LFSR 1 ?? 0x010
	MOVLW 0x10 ; wreg = 0x10
	
	INCF POSTINC0 ; [0x000] ++, and then LFSR 0 points to (0x000+1)
	INCF PREINC1 ; LFSR 1 points to (0x010+1), and then [0x011] ++
	INCF POSTDEC1 ; [0x011]--, and then LFSR 1 points to (0x011-1)
	INCF INDF1 ; [0x010] ++ , LFSR 1 keep pointing to 0x010
	INCF PLUSW1 ; [0x010 + [wreg]]++, LFSR 1 keep pointing to 0x010
	
	; Bit Addressing
	BSF 0x000, 1; bit set f ; [0x000] = b'00000010', bit 1 of [0x000] set to true
	BCF 
	BTFSC 0x000, 1; test bit 1 of [0x000], if true skip
	BTFSS ;
	
	; Relative Addressing
	BZ ; branch if zero
	
	


