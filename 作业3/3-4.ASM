STACK			SEGMENT     PARA STACK
STACK_AREA      DW          100H DUP(?)
STACK_TOP    EQU         $-STACK_AREA
STACK			ENDS

DATA			SEGMENT     PARA
NEWLINE         DB          0DH,0AH,'$'
STR1            DB          "beihang",'$'
STR2            DB          "SCSE",'$'
STR3            DB          "X86",'$'
STR4			DB			"2020", '$'
STR5            DB          "zuoye3",'$'
STR6            DB          "xuanzuoti",'$'
TABLE_LEN       EQU         6
PRINT_TABLE_LEN DW          ?
TABLE           DW          STR1,STR2,STR3,STR4,STR5,STR6	;存单词表中单词首地址
TABLE_IN        Dw          ?								;输入的单词的首地址
TABLE_END       DW          TABLE_IN

LEN             EQU         121
IN_BUFF         DB          LEN - 1
                DB          ?
                DB          LEN DUP(?)
DATA			ENDS

CODE			SEGMENT     PARA
                ASSUME      CS:CODE,DS:DATA,SS:STACK

MAIN            PROC        FAR
INIT:           MOV         AX,STACK
                MOV         SS,AX
                MOV         SP,STACK_TOP
                MOV         AX,DATA
                MOV         DS,AX
				MOV			ES,AX

                MOV         PRINT_TABLE_LEN,TABLE_LEN
                CALL        PRINT_TABLE
                MOV         DX,OFFSET NEWLINE
                MOV         AH,9
                INT         21H

                CALL        SORT

                CALL        PRINT_TABLE
                MOV         DX,OFFSET NEWLINE
                MOV         AH,9
                INT         21H

                MOV			DX,OFFSET IN_BUFF
                MOV			AH,0AH
                INT			21H
                MOV			BL,IN_BUFF+1
                XOR			BH,BH
                MOV			SI,OFFSET IN_BUFF + 2
                MOV			BYTE PTR [SI+BX],'$'
				MOV         DX,OFFSET NEWLINE
                MOV         AH,9
                INT         21H

                CALL		INSERT
                
                MOV         DX,OFFSET NEWLINE
                MOV         AH,9
                INT         21H
                MOV			PRINT_TABLE_LEN,TABLE_LEN+1
                CALL		PRINT_TABLE

EXIT:           MOV         AX,4C00H
                INT         21H
MAIN            ENDP

PRINT_TABLE		PROC
                PUSH        CX
                PUSH        SI
                PUSH        DX
                PUSH        AX

                MOV         SI,OFFSET TABLE
				MOV         CX,PRINT_TABLE_LEN
PRINT_LOOP:     MOV         DX,[SI]
                MOV         AH,9
                INT         21H
                MOV         DX,OFFSET NEWLINE
                MOV         AH,9
                INT         21H
				INC			SI
				INC			SI
                LOOP        PRINT_LOOP
				
                POP         AX
                POP         DX
                POP         SI
                POP         CX
                RET
PRINT_TABLE		ENDP

SORT			PROC
                MOV         CX,TABLE_LEN
                DEC         CX
SORT_OUT:		MOV         BX,0			;LOOP_FLAG
                MOV         SI,OFFSET TABLE
                PUSH        CX

SORT_IN:		PUSH        SI
                MOV         DI,[SI+2]		;string2
                MOV         SI,[SI]			;string1
				CLD
STR_CMPARE:		LODSB
				CMP			AL,'$'
				JZ			NOT_ABOVE
				CMP			BYTE PTR [DI],'$'
				JZ			ABOVE
				CMP         AL,ES:[DI]
                JA          ABOVE
                JB          NOT_ABOVE
                INC			DI
                JMP         STR_CMPARE
ABOVE:			POP         SI				;EXCHANGE
                PUSH        [SI]    
                PUSH        [SI+2]
                POP         [SI]
                POP         [SI+2]
                MOV         BX,1
                JMP         CONTINUE
NOT_ABOVE:		POP         SI
CONTINUE:       INC			SI
				INC			SI
                LOOP        SORT_IN

                POP         CX
                CMP         BX,0
                JZ          SORT_END
                LOOP        SORT_OUT
SORT_END:		RET
SORT			ENDP

INSERT          PROC
                MOV         CX,TABLE_LEN
                MOV         SI,OFFSET TABLE
LOOP_I1:		PUSH        SI         
                MOV         SI,[SI]					;string1 = DS:SI
                MOV         DI,OFFSET IN_BUFF+2		;string2 = ES:DI
                CLD         

INSERT_STRCMP:  LODSB					;STRCMP
                CMP         AL,ES:[DI]
                JA          INSERT_SWAP		;ABOVE
                JB          NEXT_STR	;BELOW
                CMP         AL,'$'
                JZ          NEXT_STR	;EQUAL + BELOW
                INC         DI
                JMP         INSERT_STRCMP

INSERT_SWAP:	POP         SI
                PUSH        DI
                MOV         DI,TABLE_END
SWAP_LOOP:		PUSH        [DI-2]
                POP         [DI]
				DEC			DI
				DEC			DI
                CMP         DI,SI
                JNZ         SWAP_LOOP

                MOV         WORD PTR [DI],OFFSET IN_BUFF+2
                POP         DI
                JMP         INSERT_RET
NEXT_STR:       POP         SI
                ADD         SI,2
                LOOP        LOOP_I1
				
                MOV         SI,TABLE_END
                MOV         WORD PTR [SI],OFFSET IN_BUFF+2
INSERT_RET:		RET
INSERT          ENDP

CODE			ENDS
                END         MAIN    