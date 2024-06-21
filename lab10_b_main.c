#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"

#define _XTAL_FREQ 1000000
// using namespace std;

int count = 0;
char str[20];

void main(void) {
    
    SYSTEM_Initialize() ;
    while(1);
    return;
}

void __interrupt(high_priority) Hi_ISR(void){
    if(INTCONbits.INT0IF == 1){
        count ++;
        count %= 16;
        LATA = count;
        if(LATA > 9)
            UART_Write('A'+count-10);
        else
            UART_Write('0'+count);
        __delay_ms(5);
        INTCONbits.INT0IF = 0;
    }
}