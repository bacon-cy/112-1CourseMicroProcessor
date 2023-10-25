List p=18f4520
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; PC = 0x00
	
	unit_multiple macro first_matrix_left_element, first_matrix_right_element, second_matrix_top_element, second_matrix_low_element, answer_addr
	    MOVF first_matrix_left_element, w
	    MULWF second_matrix_top_element ; [PROD] = [first_matrix_left_element] * [second_matrix_top_element]
	    MOVFF PRODL, answer_addr ; [answer_addr] = [PRODL]
	    
	    MOVF first_matrix_right_element, w
	    MULWF second_matrix_low_element
	    MOVF PRODL, w
	    ADDWF answer_addr ; [answer_addr] = [PRODL}
	endm
	
	input_data macro addr, literal
	    MOVLW literal
	    MOVWF addr
 	endm
	
	; init the data
	input_data 0x11, 0x25 ; (a1)
	input_data 0x12, 0x1F ; (a2)
	input_data 0x13, 0x1D ; (a3)
	input_data 0x14, 0x30 ; (a4)
	input_data 0x21, 0x4 ; (b1)
	input_data 0x22, 0x3 ; (b2)
	input_data 0x23, 0x2 ; (b3)
	input_data 0x24, 0x1 ; (b4)
	
	RCALL multiply
	GOTO finish
	
	multiply:
	    unit_multiple 0x11, 0x12, 0x21, 0x23, 0x00 ; (c1)
	    unit_multiple 0x11, 0x12, 0x22, 0x24, 0x01 ; (c2)
	    unit_multiple 0x13, 0x14, 0x21, 0x23, 0x02 ; (c3)
	    unit_multiple 0x13, 0x14, 0x22, 0x24, 0x03 ; (c4) 
	RETURN
	
	finish:
	NOP
	end


