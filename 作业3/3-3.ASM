STACK			SEGMENT	PARA STACK
STACK_AREA      DW      100h DUP(?)
STACK_TOP		EQU		$-STACK_AREA
STACK			ENDS

DATA			SEGMENT	PARA
LEN				EQU		121
IN_BUF			DB		LEN-1
				DB		?
				DB		LEN DUP(?)
NEW_LINE		DB		0DH,0AH,'$'	
DATA			ENDS

CODE			SEGMENT
				ASSUME	CS:CODE,DS:DATA,SS:STACK

;主函数	
MAIN			PROC	FAR
				MOV     AX,STACK
				MOV		SS,AX
				MOV		SP,STACK_TOP
				MOV		AX,DATA
                MOV     DS,AX               ;SET SS,SP,DS
				MOV		ES,AX
				
                CALL	INPUT_STR
				MOV		SI,OFFSET IN_BUF+2
				MOV		CL,IN_BUF+1
				XOR		CH,CH
				PUSH	SI					;参数：串首地址
				PUSH	CX					;参数：串长度
				MOV		AL,'a'
				CALL	FIND
				
				PUSH	AX
				MOV		DX,OFFSET NEW_LINE
				MOV		AH,9
				INT		21H
				POP		AX
				MOV		DX,AX
				OR		DL,30H
				MOV		AH,2
				INT		21H

				MOV		AX,4C00H
				INT		21H
MAIN			ENDP

;查找串中出现字符AL的次数，将次数存入AX返回
;参数通过堆栈传入POP栈两次可得：1）串长度；2）串首地址
FIND			PROC
				MOV		BP,SP
				MOV		CX,[BP+2]
				MOV		SI,[BP+4]
				PUSH	DX
				PUSH	BX

				XOR		BX,BX
				MOV		DL,AL
				CLD
LP1:			LODSB
				CMP		AL,'$'
				JZ		LP1_1
				CMP		AL,DL
				JNZ		LP1
				INC		BX
				JMP		LP1
LP1_1:			MOV		AX,BX

				POP		BX
				POP		DX
				RET
FIND			ENDP

;读取字符串到IN_BUF（从IN_BUF+2开始，以'$'结尾）
INPUT_STR		PROC
				MOV		AH,0AH
				MOV		DX,OFFSET IN_BUF
				INT		21H
				MOV		CL,IN_BUF+1
				XOR		CH,CH
				MOV		SI,OFFSET IN_BUF+2
				ADD		SI,CX
				MOV		BYTE PTR [SI],'$'
				RET
INPUT_STR		ENDP

CODE			ENDS		 

				END     MAIN