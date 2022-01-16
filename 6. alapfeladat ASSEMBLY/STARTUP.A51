        CSEG    AT      0000H
        LJMP    0030H
        CSEG    AT      000BH
        LJMP    ISR_TIMER0_OVERFLOW
        
        CSEG    AT      0030H
        
        
        LCALL   S_INIT_INTERUPT
        LCALL   S_INIT_TIMER0
        
        MOV     R0,#00H
        MOV     R1,#00H
        
        MOV     P1,#00H
        MOV     P0,#00H
        
WATCH_INPUT:
        
        MOV     A,P1
        ANL     A,#10000000B
        CLR     P1.7
        
        JZ      NO_CHECKBACK
        
        LCALL   S_CHECKBACK     
NO_CHECKBACK:      
        CLR     A
        
        
        MOV     A,P1
        ANL     A,#07H
        
        /* 
                A -> ACC.0
                B -> ACC.1
                C -> ACC.2
        */
        
        MOV     C,ACC.0
        ANL     C,ACC.2
        MOV     ACC.4,C
        
        MOV     C,ACC.0
        ANL     C,ACC.1
        MOV     ACC.5,C
        
        MOV     C,ACC.1
        ANL     C,ACC.2
        
        ORL     C,ACC.4
        ORL     C,ACC.5
        
        CLR     A
        RLC     A
        
        
        JNZ     LOGICAL_A_NOT_NULL
        LCALL   S_RESET_TIMER0
        LJMP    WATCH_INPUT
        
LOGICAL_A_NOT_NULL:
        SETB    TR0
        
        
        LJMP    WATCH_INPUT
        
        
END_OF_PROGRAM:
        LJMP    END_OF_PROGRAM
        
ISR_TIMER0_OVERFLOW:
        
        DJNZ    R5,ISR_TIMER0_OVERFLOW_END
        MOV     R5,#0FAH
        DJNZ    R6,ISR_TIMER0_OVERFLOW_END
        MOV     R6,#20
        DJNZ    R7,ISR_TIMER0_OVERFLOW_END
        MOV     R7,#5
        
        CJNE    R0,#0,INTERUPT_10SEC
        INC     R0
        SETB    P0.0
        
        INC     R1
        CJNE    R1,#5,COUNT_NOT_OVER
        SETB    P0.2
        
COUNT_NOT_OVER:
        LJMP    ISR_TIMER0_OVERFLOW_END

INTERUPT_10SEC:       
        SETB    P0.1
        MOV     R0,#00H
        CLR     TR0

ISR_TIMER0_OVERFLOW_END:
        RETI
        
        
        
S_INIT_INTERUPT:
        /*
        * Timer0 és globális interupt engedélyezés
        */
        SETB    EA
        SETB    ET0
        
        RET
        
S_INIT_TIMER0:
        
        MOV     TMOD,#02H
        MOV     TH0,#38H
        
        MOV     R5,#0FAH
        MOV     R6,#20
        MOV     R7,#05H

        RET
        
S_RESET_TIMER0:
        ;TIMER0 RESET
        CLR     TR0
        MOV     TL0,#00H
        
        
        MOV     R5,#0FAH
        MOV     R6,#20
        MOV     R7,#5
        
        
        CLR     P0.0
        MOV     R0,#00H

        RET
        
S_CHECKBACK:
        CLR     P0.1
        
        JNB      P0.2,COUNTER_NOT_FULL
        MOV     R1,#0
        CLR     P0.2

COUNTER_NOT_FULL:

        RET
        

        
        END