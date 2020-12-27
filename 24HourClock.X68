*---------------------------------------------------------------------------------
* Title      : 24-Hour clock
* Written by : Mackenzie Kean
* Description: 24-hour interrupt driven clock written in Motorolo 68000 Assembly
*---------------------------------------------------------------------------------
ONE         EQU         %00000110
TWO         EQU         %01011011
THREE       EQU         %01001111
FOUR        EQU         %01100110
FIVE        EQU         %01101101
SIX         EQU         %01111101
SEVEN       EQU         %00000111
EIGHT       EQU         %01111111
NINE        EQU         %01100111
ZERO        EQU         %00111111
BLANK       EQU         %01000000

            ORG         $1000
START:      MOVE.L      #32,D0       ; task number 32
            CLR.B       D1           ; parameter: display window
            TRAP        #15          ; system call

            MOVE.B      #0,HH        ; initialize HH
            MOVE.B      #0,MM        ; initialize MM
            MOVE.B      #0,SS        ; initialize SS
            MOVE.B      #39,COUNTER  ; initialize counter

            MOVE.L      #ISR6,$78    ; put address of ISR6 into the vector table
            
MAIN        MOVE.B      HH,D1        ; moves the hours into D1
            DIVS        #10,D1       ; divides the hours by 10
            MOVE.W      D1,-(SP)     ; push first digit onto stack
            BSR         DISPLAY      ; invoke subroutine
            MOVE.W      (SP)+,D2     ; pops the returned display value off the stack
            MOVE.B      D2,$E00000   ; displays first digit
            
            SWAP        D1           ; moves second digit into the lower word of D1
            MOVE.W      D1,-(SP)     ; push second digit onto stack
            BSR         DISPLAY      ; invoke subroutine
            MOVE.W      (SP)+,D2     ; pops the returned display value off the stack
            MOVE.B      D2,$E00002   ; displays second digit
            
            CLR.L       D1
            MOVE.B      #BLANK,$E00004 ; move line into the third digit
            
            MOVE.B      MM,D1        ; moves the minutes into D1
            DIVS        #10,D1       ; divides the minutes by 10
            MOVE.W      D1,-(SP)     ; push fourth digit onto stack
            BSR         DISPLAY      ; invoke subroutine
            MOVE.W      (SP)+,D2     ; pops the returned display value off the stack
            MOVE.B      D2,$E00006   ; displays fourth digit
            
            SWAP        D1           ; moves fifth digit into the lower word of D1
            MOVE.W      D1,-(SP)     ; push fifth digit onto stack
            BSR         DISPLAY      ; invoke subroutine
            MOVE.W      (SP)+,D2     ; pops the returned display value off the stack
            MOVE.B      D2,$E00008   ; displays fifth digit
            
            CLR.L       D1
            MOVE.B      #BLANK,$E0000A ; move line into the sixth digit
            
            MOVE.B      SS,D1        ; moves the seconds into D1
            DIVS        #10,D1       ; divides the seconds by 10
            MOVE.W      D1,-(SP)     ; push seventh digit onto stack
            BSR         DISPLAY      ; invoke subroutine
            MOVE.W      (SP)+,D2     ; pops the returned display value off the stack
            MOVE.B      D2,$E0000C   ; displays seventh digit
            
            SWAP        D1           ; moves eighth digit into the lower word of D1
            MOVE.W      D1,-(SP)     ; push eighth digit onto stack
            BSR         DISPLAY      ; invoke subroutine
            MOVE.W      (SP)+,D2     ; pops the returned display value off the stack
            MOVE.B      D2,$E0000E   ; displays eighth digit
            
            CLR.L       D1

            BRA         MAIN
        
ISR6        ORI.W       #$0700,SR    ; set priority level to 7
            MOVEM.L     D0-D2,-(SP)  ; save working register
            ANDI.W      #$F6FF,SR    ; set priority level to 6
            
            MOVE.B      COUNTER,D0   ; move counter to D0
            TST         D0           ; compares COUNTER and 0
            BNE         DEC          ; if D0 != 0
            
            MOVE.B      #39,COUNTER  ; reset counter to 39
            ADD.B       #1,SS        ; add 1 to the seconds
            CMP.B       #60,SS       ; performs 60 - SS
            BEQ         MINUTE       ; case where minutes need to be incremented
            BRA         END          ; ends the ISR
            
MINUTE      MOVE.B      #0,SS        ; sets seconds to 0
            ADD.B       #1,MM        ; add 1 to the minutes
            CMP.B       #60,MM       ; performs 60 - MM
            BEQ         HOUR         ; case where hours need to be incremented
            BRA         END          ; ends the ISR
            
HOUR        MOVE.B      #0,MM        ; sets minutes to 0
            ADD.B       #1,HH        ; add 1 to the hours
            CMP.B       #24,HH       ; performs 24 - MM
            BNE         END          ; when hours != 24 the ISR ends
            MOVE.B      #0,HH        ; sets hours to 0
            BRA         END          ; this skips the decrement when the counter is reset
            
DEC         SUB.B       #1,COUNTER   ; decrement the counter in COUNTER            
END         MOVEM.L     (SP)+,D0-D2  ; restore working register
            RTE                      ; return from interrupt
            
DISPLAY     MOVEM.L     D0-D2,-(SP)  ; save working registers
            LINK        A0,#0        ; create stack frame
            
            MOVE.W      20(A0),D0    ; move passed in value to D0
            
            MOVE.W      #ZERO,20(A0) ; put display value of 0 on stack
            CMP         #0,D0        ; compare value on stack with 0
            BEQ         RETURN       ; exits subroutine

            MOVE.W      #ONE,20(A0)  ; put display value of 1 on stack
            CMP         #1,D0        ; compare value on stack with 1
            BEQ         RETURN       ; exits subroutine 
            
            MOVE.W      #TWO,20(A0)  ; put display value of 2 on stack
            CMP         #2,D0        ; compare value on stack with 2
            BEQ         RETURN       ; exits subroutine
            
            MOVE.W      #THREE,20(A0) ; put display value of 3 on stack
            CMP         #3,D0        ; compare value on stack with 3
            BEQ         RETURN       ; exits subroutine
            
            MOVE.W      #FOUR,20(A0) ; put display value of 4 on stack
            CMP         #4,D0        ; compare value on stack with 4
            BEQ         RETURN       ; exits subroutine
            
            MOVE.W      #FIVE,20(A0) ; put display value of 5 on stack
            CMP         #5,D0        ; compare value on stack with 5
            BEQ         RETURN       ; exits subroutine
            
            MOVE.W      #SIX,20(A0)  ; put display value of 6 on stack
            CMP         #6,D0        ; compare value on stack with 6
            BEQ         RETURN       ; exits subroutine
            
            MOVE.W      #SEVEN,20(A0) ; put display value of 7 on stack
            CMP         #7,D0        ; compare value on stack with 7
            BEQ         RETURN       ; exits subroutine
            
            MOVE.W      #EIGHT,20(A0) ; put display value of 8 on stack
            CMP         #8,D0        ; compare value on stack with 8
            BEQ         RETURN       ; exits subroutine
            
            MOVE.W      #NINE,20(A0) ; put display value of 9 on stack
            CMP         #9,D0        ; compare value on stack with 9
            BEQ         RETURN       ; exits subroutine

RETURN      UNLK       A0            ; free stack frame
            MOVEM.L    (SP)+,D0-D2   ; restore working registers
            RTS             


* Put variables and constants here
HH          DS.B        1            ; global variable for hours
MM          DS.B        1            ; global variable for minutes
SS          DS.B        1            ; global variable for seconds
COUNTER     DS.B        1            ; global counter variable
 
            END         START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
