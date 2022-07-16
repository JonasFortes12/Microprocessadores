/*
 * File:   LarguraDePulsoMain.c
 * Author: jonas
 *
 * Created on 15 de Julho de 2022, 13:13
 */

/*
 Configuração do Prescaler (divisão da frequencia)
 *  T2CONbits.T2CKPS0 = 0;  T2CONbits.T2CKPS1 = 0; -> 1:1 
 *  T2CONbits.T2CKPS0 = 0;  T2CONbits.T2CKPS1 = 1; -> 1:4
 *  T2CONbits.T2CKPS0 = 1;  T2CONbits.T2CKPS1 = X; -> 1:16
 
 */
#define _XTAL_FREQ 4000000
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include <stdio.h>
#include "lcd.h"

void putch(char data){
  escreve_lcd(data);   
}

unsigned char contador = 0;

void main(void) {
    
    TRISBbits.RB0 = 1;
    INTEDG0 = 1; // habilita a interrupcao por borda de subida
    
    TRISD = 0x00;
    inicializa_lcd();
    
    T2CONbits.T2CKPS0 = 1; //Prescaler de 1:16
    T2CONbits.T2CKPS1 = 1; //Prescaler de 1:16
    T2CONbits.TMR2ON = 1;//Liga o timer - contando a cada 15.2ms (62.5HZ) 
    
    INTCONbits.GIE = 1;//Ativa as interrupcoes globais
    INTCONbits.INT0IE = 1;//Ativa a interrupção do INT0
    
    while(1) {
     __delay_ms(10);
     caracter_inicio(1,1);  //define o ponto de inicio da frase na primeira linha
     printf("contagem = %d",contador);
     caracter_inicio(2,1);  //define o ponto de inicio da frase na segunda linha
     printf("periodo = %d",16*contador);
    
    }
    return;
}

void __interrupt(high_priority) ISR(void){ //Rotina de Servico de Interrupção 
    
  if(INT0IF){ //verifica a flag de interrupção do INT0.
     INT0IF = 0;
     if (INTEDG0){
      // Borda de subida
      TMR2 = 0;
      INTEDG0 = 0; 
     } else {
      // Borda de descida  
      contador = TMR2; //contagem recebe o valor atual do timer
      INTEDG0 = 1;          
     }       
  }
}

