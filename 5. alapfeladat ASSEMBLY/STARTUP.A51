        /*
        BCD bemenet -> P1 port
        Aktuális szám BCD formában ->
        
        Kimenetek és gombok -> P2 port
        
        
        
        */

        CSEG    AT      0000H
        LJMP    0030H
        
        CSEG    AT      000BH
        LJMP    ISR_TIMER0_OVERFLOW
        
        CSEG    AT      0030H
        
        LCALL   S_INIT_INTERUP
        LCALL   S_INIT_TIMER0_200U
        
        MOV     P2,#00H

MAIN_LOOP:
        
        
        JB     TR0,TIMER_RUN
        LCALL   CONVERT_BCD
        
        MOV     P0,R0
        setb    tr0
        SETB    P2.7
        
TIMER_RUN:   

        
        
        
        LJMP    MAIN_LOOP
        
END_OF_PROGRAM:
        LJMP    END_OF_PROGRAM
        
ISR_TIMER0_OVERFLOW:
        DJNZ    R5,ISR_TIMER0_OVERFLOW_END
        MOV     R5,#0FAH
        DJNZ    R6,ISR_TIMER0_OVERFLOW_END
        MOV     R6,#14H
        DJNZ    R2,ISR_TIMER0_OVERFLOW_END2
        mov     r2,#9
        DJNZ    R3,ISR_TIMER0_OVERFLOW_END2
        
        
        
        mov     p0,#00h
        clr     tr0
ISR_TIMER0_OVERFLOW_END2:

        ;LCALL   S_CONVERT_BIN_BCD
        MOV     P0,r2
ISR_TIMER0_OVERFLOW_END:
        RETI
        
S_INIT_INTERUP:
        SETB    EA
        SETB    ET0
        RET
        
S_INIT_TIMER0_200U:
        
        ANL     TMOD,#0FH
        ORL     TMOD,#02H
        
        MOV     TH0,#38H
        ;250X20 -> 
        
        ; 1SEC ALAP
        MOV     R5,#0FAH
        MOV     R6,#20H
        
        RET
        
        
CONVERT_BCD:
        MOV     R1,P1
        
        MOV     A,R1
        
        
        ANL     A,#00001111B
        
        MOV     R2,A
        
        CLR     C
        SUBB    A,#10
        
        JNC     BCD_BIG
        
        
        MOV     A,R1
        SWAP    A
        
        ANL     A,#00001111B
        
        MOV     R3,A
        
        CLR     C
        SUBB    A,#10
        
        JNC     BCD_BIG
        
        CLR     A
        /*MOV     B,#01H
        MOV     A,R2
        
        MUL     AB
        MOV     R0,A
        
        MOV     B,#10H
        MOV     A,R3
        
        MUL     AB
        
        ADD     A,R0
        MOV     R0,A
        
        MOV     R2,#00H
        MOV     R3,#00H*/
        
        LJMP    CONVERT_OK

BCD_BIG:
        MOV     P1,#00H

CONVERT_OK:
        RET
        
S_CONVERT_BIN_BCD:
        MOV     B,#10H
        MOV     A,R0
        
        DIV     AB
        
        SWAP    A
        
        ANL     A,#11110000B
        ANL     B,#00001111B
        ORL     A,B
        
        MOV     R4,A

        RET
        
        
        END