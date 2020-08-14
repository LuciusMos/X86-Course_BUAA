STACK		SEGMENT	PARA STACK
STACK_AREA      DW      100h DUP(?)
STACK_TOP	EQU	$-STACK_AREA
STACK		ENDS

DATA		SEGMENT	PARA
TABLE_LEN       DW 16
TABLE           DW 200,300,400,10,20,0,1,8
                DW 41H,40,42H,3321h,60,0FFFFH,2,3

MY_NAME         DB 'My name is Zhang Wuji','$'

ADD1            DD 20003000H
ADD2            DD 12345678h
DATA		ENDS

CODE		SEGMENT
		ASSUME	CS:CODE,DS:DATA
		ASSUME	SS:STACK
MAIN		PROC	FAR
		
START:          MOV     AX,STACK
		MOV	SS,AX
		MOV	SP,STACK_TOP
		MOV	AX,DATA
                MOV     DS,AX               ;SET SS,SP,DS

                JMP     START1
                LDS     SI,ADD1
                LES     DI,ADD2

                JMP     short l1
                JMP     NEAR ptr  l1
                JMP     FAR ptr   l1
                JMP     BX
                JMP     BX
                JMP     Word PTR  [BX]
                JMP     [BX]
                JMP     DWORD PTR [BX]
                JMP     DWORD PTR ADD1
                CALL    BX
                CALL    [BX]
                CALL    WORD PTR [BX]
                CALL    DWORD PTR ADD1
                CALL    ADD1

l1:             NOP
START1:         NOP
LP1:    	MOV     BX,1
        	MOV     CX,TABLE_LEN
        	DEC     CX
                LEA     SI,TABLE        ;MOV SI,offset Table
LP2:    	MOV     AX,[SI]
        	CMP     AX,[SI+2]
        	JBE     CONTINUE
        	XCHG    AX,[SI+2]
        	MOV     [SI],AX
        	MOV     BX,0
CONTINUE:
       		ADD     SI,2
        	LOOP    LP2

	        CMP     BX,1
        	JZ      EXIT
        	JMP     SHORT   LP1
EXIT:           MOV     DX,OFFSET MY_NAME
                MOV     AH,9
                INT     21H

                MOV     AX,4C00H
		INT     21H
MAIN		ENDP
CODE		ENDS		 

		END     START
END
