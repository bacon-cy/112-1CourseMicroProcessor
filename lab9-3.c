#include <xc.h>
#include<stdio.h>
#include<stdlib.h>
#include <time.h>

#define _XTAL_FREQ 1000000

#pragma config OSC = INTIO67  //OSCILLATOR SELECTION BITS (INTERNAL OSCILLATOR BLOCK, PORT FUNCTION ON RA6 AND RA7)
#pragma config WDT = OFF      //Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PWRT = OFF     //Power-up Timer Enable bit (PWRT disabled)
#pragma config BOREN = ON     //Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
#pragma config PBADEN = OFF   //PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF      //Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#pragma config CPD = OFF      //Data EEPROM Code Protection bit (Data EEPROM not code-protected)

void initTimer2andCCP1(){
    // Timer2 -> On, prescaler -> 4 
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;
    
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8µs * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    // configure for init duty cycle
    CCPR1L = 0x00;
    CCP1CONbits.DC1B = 0x00;
}


void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = ADRESH * 4 + ADRESL / 64; // the converted value of variable resistor is in ADRESH
    
    
    //do things
    CCPR1L = ADRESH / 2;
    CCP1CONbits.DC1B = ADRESL / 64 / 2;
    
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (ADRESH:ADRESL<7:6>) / 2 * 8µs * 4
     * = 16µs * 0~1023
     *
     * ???(>= 0.7 ??)and acquisition time(>= 2.4 ??)
     */
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
    /*
    delay at least 2tad
    ADCON0bits.GO = 1;
    */
    __delay_us(5);
    ADCON0bits.GO = 1;
    return;
}

void main(void) {
    //configure OSC and port
    OSCCONbits.IRCF = 0b110; //4MHz // Internal Oscillator Frequency, Fosc = 4MHz, Tosc = 0.25 us
    TRISAbits.RA0 = 1;       //analog input port
    initTimer2andCCP1();
    
    //configure led // CCP1/RC2 -> Output
    TRISC = 0; // output
    LATC=0;
    
    //step1 Configure the ADC module
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 : analog input,others : digital
    ADCON0bits.CHS = 0b0000;  //nalog channel : AN0
    ADCON2bits.ADCS = 0b100;  //since 4Mhz < 5.71Mhz, set to 0b100, Tad = 1/(4*10^6) *4 sec = 1 us
    ADCON2bits.ACQT = 0b010;  //acquisition time = 4 * Tad = 4 * 1 us > 2.4 us
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2 Configure the ADC interrupt
    PIE1bits.ADIE = 1; //enable A/D interrupt
    PIR1bits.ADIF = 0; //Clear A/D interrupt flag bit
    INTCONbits.PEIE = 1; //Enable peripheral interrupt
    INTCONbits.GIE = 1; //global-enable interrupts


    //step3 Start conversion
    ADCON0bits.GO = 1; //Start Conversion
    
    while(1);
    
    return;
}