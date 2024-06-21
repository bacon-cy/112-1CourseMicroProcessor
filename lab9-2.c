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

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = ADRESH * 4 + ADRESL / 64; // the converted value of variable resistor is in ADRESH
    
    
    //do things
    int field = (value / 146);
    
    switch(field){
        case 0:
            LATB = 4;
            break;
        case 1:
            LATB = 1;
            break;
        case 2: case 4:
            LATB = 0;
            break;
        case 3: case 6:
            LATB = 6;
            break;
        case 5:
            LATB = 2;
            break;
    }
    
    
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
    OSCCONbits.IRCF = 0b110; //4MHz
    TRISAbits.RA0 = 1;       //analog input port
    
    //configure led (PB0~4)
    TRISB = 0; // output
    LATB=0;
    
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