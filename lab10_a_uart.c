#include <xc.h>
    //setting TX/RX

char mystring[20];
int lenStr = 0;

void UART_Initialize() {
           
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX
    */
    
    // Green Line and White Line
    TRISCbits.TRISC6 = 1;     //white : transmitter
    TRISCbits.TRISC7 = 1;     //green : reciever   
    
    //  Setting baud rate
    //Since Fosc = 4MHz, and baud rate requirement is 1200
    TXSTAbits.SYNC = 0;                    
    TXSTAbits.BRGH = 0;
    BAUDCONbits.BRG16 = 0; 
    SPBRG = 51;      
    
    //  Serial enable 
    RCSTAbits.SPEN = 1;
    
    // transmitter
    PIR1bits.TXIF = 1;
        // interrupt enable
    PIE1bits.TXIE = 1;
            // priority
    IPR1bits.TXIP = 0; 
    //reciever
    PIR1bits.RCIF = 1;
        // continuous recieve enable
    RCSTAbits.CREN = 1;             
        // interrupt enable
    PIE1bits.RCIE = 1;
            // priority
    IPR1bits.RCIP = 0;    
    
    // enable transmission
    TXSTAbits.TXEN = 1;
    }

void UART_Write(unsigned char data){  // Output on Terminal // Transmitter
    // busy waiting, wait until writing finished
    while(!TXSTAbits.TRMT); //TRMT : Read only, which is set when the TSR register is empty.
    // then write new data to send
    TXREG = data;              //write to TXREG will send data 
}


void UART_Write_Text(char* text) { // Output on Terminal, limit:10 chars
    for(int i=0;text[i]!='\0';i++)
        UART_Write(text[i]);
}

void ClearBuffer(){
    for(int i = 0; i < 10 ; i++)
        mystring[i] = '\0';
    lenStr = 0;
}

void MyusartRead(){ // when interrupted, the data is well recieved, and we could process it
    /* TODObasic: try to use UART_Write to finish this function */
    UART_Write(RCREG);
    return ;
}

char *GetString(){
    return mystring;
}


// void interrupt low_priority Lo_ISR(void)
void __interrupt(low_priority)  Lo_ISR(void)
{
    if(RCIF)
    {
        if(RCSTAbits.OERR)
        {
            CREN = 0;
            Nop();
            CREN = 1;
        }
        
        MyusartRead();
    }
    
   // process other interrupt sources here, if required
    return;
}