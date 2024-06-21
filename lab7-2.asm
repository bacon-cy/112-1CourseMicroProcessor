#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

    org 0x00
    
goto Initial			    
ISR:				
    org 0x08                ; When interrupt occurs, the process jumps to here
    MOVLW 0x0F
    CPFSEQ LATA	    ; if f == W, skip
    goto NF	    
    F: ; if LATA == 0x0F
	CLRF LATA
	goto afterFNF
    NF: ; if LATA != 0x0F
	INCF LATA		    ; LATA+=1
				    ;goto afterFNF
    afterFNF:
	BTFSS 0x20, 0 ; if the bit 0 of 0x20 is 1, then skip (0: 1sec, 1: 0.5sec)
	goto toOneSec
	toHalfSec:
	    MOVLW D'122'		; every 256 * 4 = 1024 cycles, the count of TIMER2 is added 1
	    MOVWF PR2			; If system time is 250khz, then it costs 125000 cycles for each interruption, and between two interrupts, the delay is 0.5 second.
					; Thus, PR2 is set to 125000 / 1024 = 122.0703125, about 122
	    goto endofISR
	toOneSec:
	    MOVLW D'244'		; every 256 * 4 = 1024 cycles, the count of TIMER2 is added 1
	    MOVWF PR2			; If system time is 250khz, then it costs 250000 cycles for each interruption, and between two interrupts, the delay is 1 second.
					; THus, PR2 is set to 250000 / 1024, which is about 244
			    ;goto endofISR
    endofISR:
    COMF 0x20
    BCF PIR1, TMR2IF        ; TMR2IF must be cleared before return from the interruption (flag bit must be cleared)
    RETFIE
    
Initial:			
    MOVLW 0x0F
    MOVWF ADCON1
    CLRF TRISA
    CLRF LATA
    BSF TRISB,  0
    BSF RCON, IPEN
    BSF INTCON, GIE
    
    BCF PIR1, TMR2IF		; To use TIMER2, TMR2IF, TMR2IE, and TMR2IP must be set up
    BSF IPR1, TMR2IP
    BSF PIE1 , TMR2IE
    MOVLW b'11111111'	        ; The prescale and the postscale are set to 1:16. After that, TIMER2 is added 1 per 256 timer cycles
    MOVWF T2CON		; timer pulse (timer cycle) is quater of system pulse, thus timer is added 1 per 256 * 4 = 1024 clock cycles
    MOVLW D'122'		; If the system time pulse is 250kHz (instruction clocks / secs), and the delay between any two interrupts is 0.25 second, then PR2 = 125000 /2 / 1024= 65
    MOVWF PR2	
    MOVLW b'00100000'
    MOVWF OSCCON	        ; the system time is set to 250kHz
    CLRF 0x20			;0x20 == 0 : increase
main:		
    bra main	    

    
end