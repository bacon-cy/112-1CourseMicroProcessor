List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; PC = 0x00
	
	; [0x100] to [0x105]
	; 0xB5, 0xF8, 0x64, 0x7F, 0xA8, and 0x15
	
	MOVLB 0x1 ; BSR = 1
	
	MOVLW 0x10
	MOVWF 0x00, 1
	MOVLW 0x02
	MOVWF 0x01, 1
	MOVLW 0x04
	MOVWF 0x02, 1
	MOVLW 0x58
	MOVWF 0x03, 1
	MOVLW 0x2C
	MOVWF 0x04, 1
	MOVLW 0x5D
	MOVWF 0x05, 1
	
	MOVLW 0x00
	MOVWF 0x00 ; [0x00] = left (0)
	MOVLW 0x05 
	MOVWF 0x01 ; [0x01] = right (5)
	
	LFSR 0, 0x100 ; the pointer for the two for loop, make the bank count to 0x1
	loop: ; the while loop
    
	MOVF 0x00, w ; [wreg] = left
	MOVWF FSR0L ; [FSR0L] = [wreg] = left
	left_for:
	MOVF POSTINC0, w ; save the leftmost number into w, FSR0 = &a[i+1]
	CPFSLT INDF0 ; skip if wreg(a[i]) > FSR0(a[i+1])
	GOTO no_switch_left
	MOVWF 0x02 ; [0x02] = a[i]
	MOVF POSTDEC0, w ; [wreg] = a[i+1], FSR0 = &a[i]
	MOVWF POSTINC0 ; a[i] = [wreg], FSR0 = &a[i+1]
	MOVF 0x02, w ; [wreg] = [0x02] = a[i]
	MOVWF INDF0 ; a[i+1] = [wreg] = a[i], FSR0 still = &a[i+1]
	no_switch_left:
	MOVF 0x01, w
	CPFSLT FSR0L ; skip if left (FSR0L) < right (wreg[0x01])
	GOTO left_end ; if left >= right
	GOTO left_for
	
	left_end:
	DECF 0x01 ; right--
	
	MOVF 0x01, w ; [wreg] = right
	MOVWF FSR0L ; [FSR0L] = [wreg] = right
	right_for:
	MOVF POSTDEC0, w ; save the rightmost number into w (wreg = a[i]), FSR0 = &a[i-1]
	CPFSGT INDF0 ; skip (switch) if FSR0(a[i-1]) > wreg(a[i])
	GOTO no_switch_right
	MOVWF 0x02 ; [0x02] = [wreg] = a[i]
	MOVF POSTINC0, w ; [wreg] = a[i-1], FSR0 = &a[i]
	MOVWF POSTDEC0 ; a[i] = [wreg] = a[i-1], FSR0 = &a[i-1]
	MOVF 0x02, w ; [wreg] = [0x02] = a[i]
	MOVWF INDF0 ; a[i-1] = [wreg] = a[i], FSR0 still = &a[i-1]
	no_switch_right:
	MOVF 0x00, w
	CPFSGT FSR0L ; skip if right (FSR0L) > left (wreg[0x00])
	GOTO right_end
	GOTO right_for
	
	right_end:
	INCF 0x00 ; left++
    
	; check if it is the terminal of while
	MOVF 0x01, w ; [wreg] = [0x01] = right
	CPFSLT 0x00 ; skip if left ([0x00]) < right (wreg[0x01])
	GOTO end_loop
	GOTO loop
	
	end_loop:
	;copy the answer to each places
	LFSR 0, 0x100
	MOVF POSTINC0, w
	MOVWF 0x10, 1
	MOVF POSTINC0, w
	MOVWF 0x11, 1
	MOVF POSTINC0, w
	MOVWF 0x12, 1
	MOVF POSTINC0, w
	MOVWF 0x13, 1
	MOVF POSTINC0, w
	MOVWF 0x14, 1
	MOVF POSTINC0, w
	MOVWF 0x15, 1
	
	end
	


