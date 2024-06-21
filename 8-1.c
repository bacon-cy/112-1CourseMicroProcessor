#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)


int clockwise;

void initRB0(){
    TRISBbits.TRISB0 = 1; // input
    INTCONbits.INT0IE = 1; // open the interrupt0 enable bit (INT0 is in the same pin of RB0)
    INTCONbits.INT0IF = 0; // clear up Interrupt flag bit
}

void initTimer2andCCP1(){
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 �s
    OSCCONbits.IRCF = 0b001;
    
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8�s * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8�s * 4
     * = 0.00144s ~= 1450�s
     */
    
    // -90 : 500, 500 / 32 = 15.6, 16 = 4*4 + 0, CCPR1L = 0x04; CCP1CONbits.DC1B = 0b00;
    // -45 : 975, 975 / 32 = 30.46, 30 = 4*7 + 2. CCPR1L = 0x07; CCP1CONbits.DC1B = 0b02;
    // 0: 1450, 1450 / 32 = 45.3125, 45 = 4*11 + 1, CCPR1L = 0x0b; CCP1CONbits.DC1B = 0b01;
    // 45 : 1925, 1925 / 32 = 60.15, 60 = 4*15, CCPR1L = 0x0f; CCP1CONbits.DC1B = 0b00;
    // 90 : 2400, 2400 / 128 = 18.75, 19 = 4*4 + 3, CCPR1L = 0x04; CCP1CONbits.DC1B = 0b03; change prescalar to 16, T2CONbits.T2CKPS = 0b10;
    
    CCPR1L = 0x07;
    CCP1CONbits.DC1B = 0x01;
}

void init(){
    ADCON1 = 15;
    RCONbits.IPEN = 0;
    INTCONbits.GIE = 1;
    initRB0();
    initTimer2andCCP1();
}

void __interrupt(high_priority) H_ISR(){
    if(INTCONbits.INT0IF == 1){
            if (clockwise == 0){ // 15 = 7 + 4 + 4
                CCPR1L += 0x04;
                if (CCPR1L == 0x0f) clockwise = 1;
            } else {
                CCPR1L -= 0x04;
                if(CCPR1L == 0x07) clockwise = 0;
            }
    }
    INTCONbits.INT0IF = 0;
    return;
}



void main(int argc, char** argv) {
    init();
    while(1);
    return;
}


