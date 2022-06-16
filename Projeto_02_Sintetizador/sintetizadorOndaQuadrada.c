/*
 * File:   sintetizadorOndaQuadrada.c
 * Author: jonas
 *
 * Created on 14 de Junho de 2022, 14:07
 */

#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = ON         // Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
#include <xc.h>
#define _XTAL_FREQ 4e6 /* Define a frequencia do clock (4Mz)
                       O delay é definido a partir desta definicao */
void main(void) {

    TRISD = 0xFF; // em binário eh 1111 1111 (todo entrada)
    TRISBbits.RB0 = 0; // saida do sinal
    int Port;
    
    while(1){ // loop principal
        
        Port = PORTD;
        if(PORTD == 0)
            PORTBbits.RB0 = 0;
        else
            PORTBbits.RB0 ^= 1; //Operação de XOR
        
        switch(Port){
                
            case 0b10000000: //nota C3
                __delay_ms(1.911); 
                break;
            
            case 0b01000000: //nota D3
                __delay_ms(1.7025);
                break;
            
            case 0b00100000: //nota E3
                __delay_ms(1.517);
                break;
                
            case 0b00010000: //nota F3
                __delay_ms(1.4315);
                break;
                
            case 0b00001000: //nota G3
                __delay_ms(1.2755);
                break;
                
            case 0b00000100: //nota A3 
                __delay_ms(1.1365); 
                break;
                
            case 0b00000010: //nota B3   
                __delay_ms(1.0125); 
                break; 
            
            case 0b00000001: //nota C4   
                __delay_us(955.5);    
                break;
        }
   
    }
    return;
}
