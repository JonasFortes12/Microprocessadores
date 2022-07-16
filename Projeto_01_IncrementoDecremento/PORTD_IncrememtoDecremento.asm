#include "p18f4550.inc"

; Configurations Bits
CONFIG FOSC = XT_XT 
CONFIG WDT = OFF
CONFIG LVP = OFF 
    
VARIAVEIS UDATA_ACS 0
    CONT1 RES 1 ; Reserva 1byte da RAM para a variável CONT1
    CONT2 RES 1 ; Reserva 1byte da RAM para a variável CONT2
    CONT RES 1 ;Reserva 1byte da RAM para a variável CONT
    BT_SW1 EQU  .6 ;equivale ao pino 6
    BT_SW2 EQU  .7 ;equivale ao pino 7

RES_VECT CODE 0X0000
    
   GOTO START ; Desvia o programa para o START
   MAIN_PROG CODE 

START
    CLRF TRISD
    BSF TRISC, BT_SW1 ;pino RD2
    BSF TRISC, BT_SW2 ;pino RD3
    
LOOP ;define uma seção de código LOOP
    
    BTFSC PORTC, BT_SW1 ; Se o BT_SW1 for 0, pula proxima instrução.
    CALL SEC1 ;executa seção SEC1 de código
    BTFSC PORTC, BT_SW2 ; Se o BT_SW2 for 0, pula proxima instrução.
    CALL SEC2 ;executa seção SEC1 de código
    MOVFF  CONT,  PORTD
    
GOTO LOOP ; retorna ao início do LOOP
 
SEC1 ;define uma seção de código SEC1
    ;Delay de 1 segundov
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    
    BTFSC PORTC, BT_SW2 ;Se o BT_SW1 for pressionado também, retorna.
	RETURN
    BTFSS PORTC, BT_SW1 ;Se o BT_SW1 for 1, pula proxima instrução.
	RETURN
    INCF CONT ;Incrementa a variável CONT
    MOVFF  CONT,  PORTD
RETURN 
 
SEC2 ;define uma seção de código SEC2
    ;Delay de 1 segundo
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS

    BTFSC PORTC, BT_SW1 ;Se o BT_SW1 for pressionado também, retorna.
	RETURN
    BTFSS PORTC, BT_SW2 ;Se o BT_SW1 for 1, pula proxima instrução.
	RETURN
    DECF CONT ;Incrementa a variável CONT
    MOVFF  CONT,  PORTD
 RETURN 

 
DELAY200MS
    MOVLW .200 ;move o literal 200 para o registrador W
    MOVWF CONT2 ;move o dado do registrador W para a variável CONT2
 
    DELAYM 
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	DECFSZ CONT2 ;Decrementa a variável CONT2 e pula intrução se for 0 
    BRA DELAYM
RETURN

DELAY200US
    MOVLW .48 ;move o literal 48 para o registrador W
    MOVWF CONT1 ;move o dado do registrador W para a variável CONT1

    DELAY
	NOP ;espera
	DECFSZ CONT1 ;Decrementa a variável CONT1 e pula intrução se for 0 
    BRA DELAY
    
    BTFSC PORTC, BT_SW1 ;Se o BT_SW1 for 0, pula proxima instrução.
	RETURN
    BTFSC PORTC, BT_SW2 ;Se o BT_SW2 for 0, pula proxima instrução.
	RETURN
    
    POP
    POP
RETURN ; retorna ao início do LOOP

END