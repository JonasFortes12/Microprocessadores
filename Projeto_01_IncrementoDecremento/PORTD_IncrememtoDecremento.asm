#include "p18f4550.inc"

; Configurations Bits
CONFIG FOSC = XT_XT 
CONFIG WDT = OFF
CONFIG LVP = OFF 
    
VARIAVEIS UDATA_ACS 0
    CONT1 RES 1 ; Reserva 1byte da RAM para a vari�vel CONT1
    CONT2 RES 1 ; Reserva 1byte da RAM para a vari�vel CONT2
    CONT RES 1 ;Reserva 1byte da RAM para a vari�vel CONT
    BT_SW1 EQU  .6 ;equivale ao pino 6
    BT_SW2 EQU  .7 ;equivale ao pino 7

RES_VECT CODE 0X0000
    
   GOTO START ; Desvia o programa para o START
   MAIN_PROG CODE 

START
    CLRF TRISD
    BSF TRISC, BT_SW1 ;pino RD2
    BSF TRISC, BT_SW2 ;pino RD3
    
LOOP ;define uma se��o de c�digo LOOP
    
    BTFSC PORTC, BT_SW1 ; Se o BT_SW1 for 0, pula proxima instru��o.
    CALL SEC1 ;executa se��o SEC1 de c�digo
    BTFSC PORTC, BT_SW2 ; Se o BT_SW2 for 0, pula proxima instru��o.
    CALL SEC2 ;executa se��o SEC1 de c�digo
    MOVFF  CONT,  PORTD
    
GOTO LOOP ; retorna ao in�cio do LOOP
 
SEC1 ;define uma se��o de c�digo SEC1
    ;Delay de 1 segundov
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    
    BTFSC PORTC, BT_SW2 ;Se o BT_SW1 for pressionado tamb�m, retorna.
	RETURN
    BTFSS PORTC, BT_SW1 ;Se o BT_SW1 for 1, pula proxima instru��o.
	RETURN
    INCF CONT ;Incrementa a vari�vel CONT
    MOVFF  CONT,  PORTD
RETURN 
 
SEC2 ;define uma se��o de c�digo SEC2
    ;Delay de 1 segundo
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS
    CALL	DELAY200MS

    BTFSC PORTC, BT_SW1 ;Se o BT_SW1 for pressionado tamb�m, retorna.
	RETURN
    BTFSS PORTC, BT_SW2 ;Se o BT_SW1 for 1, pula proxima instru��o.
	RETURN
    DECF CONT ;Incrementa a vari�vel CONT
    MOVFF  CONT,  PORTD
 RETURN 

 
DELAY200MS
    MOVLW .200 ;move o literal 200 para o registrador W
    MOVWF CONT2 ;move o dado do registrador W para a vari�vel CONT2
 
    DELAYM 
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	CALL	DELAY200US
	DECFSZ CONT2 ;Decrementa a vari�vel CONT2 e pula intru��o se for 0 
    BRA DELAYM
RETURN

DELAY200US
    MOVLW .48 ;move o literal 48 para o registrador W
    MOVWF CONT1 ;move o dado do registrador W para a vari�vel CONT1

    DELAY
	NOP ;espera
	DECFSZ CONT1 ;Decrementa a vari�vel CONT1 e pula intru��o se for 0 
    BRA DELAY
    
    BTFSC PORTC, BT_SW1 ;Se o BT_SW1 for 0, pula proxima instru��o.
	RETURN
    BTFSC PORTC, BT_SW2 ;Se o BT_SW2 for 0, pula proxima instru��o.
	RETURN
    
    POP
    POP
RETURN ; retorna ao in�cio do LOOP

END