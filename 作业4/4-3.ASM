STACK           SEGMENT     PARA STACK
STACK_AREA      DW          100H DUP(?)
STACK_TOP       EQU         $-STACK_AREA
STACK           ENDS

DATA            SEGMENT     PARA
FUNC_TABLE      DW          READ_STR,STR_FIND,STR_CMP,STR_COPY,PRINT_STR
STR1            DB          "zhaoliangxuan",'$'
STR2            DB          "x86",'$'
TMP	            DB          30 DUP(?)
IN_LEN          EQU         121
IN_BUF			DB          IN_LEN - 1
                DB          ?
                DB          IN_LEN DUP(?)
SPACE			DB			20H,'$'
NEW_LINE        DB          0DH,0AH,'$'
DATA            ENDS

CODE            SEGMENT     PARA
                ASSUME      CS:CODE,DS:DATA,SS:STACK

;主程序
MAIN            PROC        FAR
				MOV         AX,STACK
                MOV         SS,AX
                MOV         SP,STACK_TOP
                MOV         AX,DATA
                MOV         DS,AX
                MOV         ES,AX

READ_OP:   		MOV         AH,1
                INT         21H
                MOV         DX,OFFSET NEW_LINE
                MOV         AH,9
                INT         21H
                
                CMP         AL,30H
                JB          READ_OP
                CMP         AL,36H
                JA          READ_OP
                CMP         AL,30H
                JZ          MAIN_END
				
                SUB         AL,31H
                SHL         AL,1
                MOV         BX,OFFSET FUNC_TABLE
                ADD         BL,AL
                CALL        [BX]
                MOV         DX,OFFSET NEW_LINE
                MOV         AH,9
                INT         21H
                JMP         READ_OP

MAIN_END:		MOV         AX,4C00H
                INT         21H
MAIN            ENDP

;1）字符串输入
READ_STR        PROC
                PUSH        SI
                PUSH        AX
                PUSH        DX

                MOV         DX,OFFSET IN_BUF 
                MOV         AH,0AH
                INT         21H
				MOV			CL,IN_BUF+1
				XOR			CH,CH
				MOV			SI,OFFSET IN_BUF+2
				ADD			SI,CX
                MOV         BYTE PTR [SI],'$'
                
                MOV         DX,OFFSET NEW_LINE
                MOV         AH,9
                INT         21H
                MOV         DX,OFFSET IN_BUF+2
                MOV         AH,9
                INT         21H

                POP         DX
                POP         AX
                POP         SI
                RET         
READ_STR        ENDP

;2）在串STR1中查找字符，字符为键盘输入
STR_FIND        PROC
                PUSH        SI
				PUSH		AX
                PUSH        BX
                PUSH        CX
				PUSH		DX

                MOV         SI,OFFSET STR1
                MOV         AH,1
                INT         21H
				PUSH		AX
				MOV         DL,':'
                MOV         AH,2
                INT         21H
				POP			DX
				XOR			DH,DH
                XOR			BX,BX
				CLD
FIND_LOOP:		LODSB		
				CMP         AL,'$'
				JZ			FIND_END
				CMP			AL,DL
				JNZ			FIND_LOOP
                INC         BX
				JMP			FIND_LOOP
                
FIND_END:		MOV         AX,BX
				CALL        DISP_VALUE
				POP			DX
                POP         CX
                POP         BX
				POP			AX
                POP         SI
                RET         
STR_FIND        ENDP


;3）比较STR1和STR2
STR_CMP			PROC
				PUSH	CX
				PUSH	BX
				PUSh	AX
				
				MOV     DX,OFFSET STR1
                MOV     AH,9
                INT     21H
				MOV     DX,OFFSET SPACE
                MOV     AH,9
                INT     21H
				
				MOV		SI,OFFSET STR1
				MOV		DI,OFFSET STR2
CMP_LP3:		CMP		BYTE PTR [SI],'$'
				JZ		CMP_LP3_1
				CMP		BYTE PTR [DI],'$'
				JZ		A
				JMP		CMP_LP3_2
CMP_LP3_1:		CMP		BYTE PTR [DI],'$'
				JZ		Z
				JMP		B
CMP_LP3_2:		MOV		AL,BYTE PTR [SI]
				CMP		AL,BYTE PTR [DI]
				JA		A
				JB		B
				INC		SI
				INC		DI
				JMP		CMP_LP3
				
B:				MOV     DL,'<'		;小于
				JMP		SHORT CMP_END
A:				MOV     DL,'>'		;大于
				JMP		SHORT CMP_END
Z:				MOV     DL,'='		;等于

CMP_END:		XOR     DH,DH
                MOV     AH,2
                INT     21H
				MOV     DX,OFFSET SPACE
                MOV     AH,9
                INT     21H
				MOV     DX,OFFSET STR2
                MOV     AH,9
                INT     21H
				POP		AX
				POP		BX
				POP		CX
				RET
STR_CMP			ENDP


;4）将STR1复制到STR2
STR_COPY        PROC
                PUSH        SI
                PUSH        DI
				PUSH		AX

                MOV         SI,OFFSET STR1
				MOV         DI,OFFSET STR2
                CLD
COPY_LOOP:		LODSB
				STOSB
				CMP			AL,'$'
				JNZ			COPY_LOOP

                PUSH		AX
                POP         DI
                POP         SI
                RET         
STR_COPY        ENDP


;5）显示字符串STR1及STR2
PRINT_STR       PROC
                PUSH        DX
                PUSH        AX
                
                MOV         DX,OFFSET STR1
                MOV         AH,9
                INT         21H
				MOV         DX,OFFSET SPACE
                MOV         AH,9
                INT         21H
                MOV         DX,OFFSET STR2
                MOV         AH,9
                INT         21H

                POP         AX
                POP         DX
                RET         
PRINT_STR           ENDP


;显示整数，将要显示的数字存在AX中
DISP_VALUE		PROC
				PUSH	DX
				PUSH	CX
				PUSH	BX
				PUSH	AX
				
				MOV		CX,5
				MOV		BX,10
DLP1:			XOR		DX,DX
				DIV		BX
				PUSH	DX		;余数
				LOOP	DLP1
				
				MOV		BX,0
				MOV		CX,5
DLP2:			POP		DX
				CMP		DL,0
				JNZ		DLP2_1
				CMP		BX,0
				JZ		DLP2_2
DLP2_1:			MOV		BX,1
				OR		DL,30H
				MOV		AH,2
				INT		21H
DLP2_2:			LOOP	DLP2

				POP		AX
				POP		BX
				POP		CX
				POP		DX
				RET
DISP_VALUE		ENDP

CODE            ENDS
                
				END         MAIN 