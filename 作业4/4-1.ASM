STACK			SEGMENT	PARA STACK
STACK_AREA      DW      100h DUP(?)
STACK_TOP		EQU		$-STACK_AREA
STACK			ENDS

DATA			SEGMENT	PARA
STR1	        DB 		'17373157', 0
IN_LEN			EQU		121
IN_BUF			DB		IN_LEN-1
				DB		?
				DB		IN_LEN DUP(?)
NEW_LINE		DB		0DH,0AH,'$'
DATA			ENDS

CODE			SEGMENT
				ASSUME	CS:CODE,DS:DATA,SS:STACK
				
;主函数
MAIN			PROC	FAR
				MOV     AX,STACK
				MOV 	SS,AX
				MOV		SP,STACK_TOP
				MOV		AX,DATA
                MOV     DS,AX               ;SET SS,SP,DS
				MOV		ES,AX
				
				MOV		SI,OFFSET IN_BUF
				PUSH	SI
				CALL	READ_STR
				
				MOV		DX,OFFSET NEW_LINE
				MOV		AH,9
				INT		21H
				
				MOV		SI,OFFSET IN_BUF+2
				PUSH	SI
				MOV		SI,OFFSET STR1
				PUSH	SI
				CALL	CONCAT_STR
				
				MOV		SI,OFFSET STR1
				PUSH	SI
				CALL	DISP_STR
				
				MOV		AX,4C00H
				INT		21H
MAIN			ENDP

;从键盘输入字符串，堆栈传参：IN_BUF首地址
READ_STR		PROC
				PUSH	BP
				MOV		BP,SP
				PUSH	AX
				PUSH	DX
				
				MOV		AH,0AH
				MOV		DX,[BP+4]
				INT		21H
				
				POP		DX
				POP		AX
				POP		BP

				RET		2
READ_STR		ENDP		
				
;拼接字符串，堆栈传参：S1,S2首地址，结果存储在CAT_RESULT中
CONCAT_STR		PROC
				PUSH	BP
				MOV		BP,SP
				PUSH	DI
				PUSH	SI
				PUSH	AX
				
				MOV		SI,[BP+4]
				MOV		DI,[BP+6]
				CLD
CAT_LP1:		LODSB
				CMP		AL,0
				JNZ		CAT_LP1
				DEC		SI
CAT_LP2:		MOV		AL,BYTE PTR [DI]
				MOV		BYTE PTR [SI],AL
				INC		SI
				INC		DI
				CMP		AL,0
				JNZ		CAT_LP2

				POP		AX
				POP		SI
				POP		DI
				POP		BP				
				RET		4
CONCAT_STR		ENDP	

;显示字符串（ASCIIZ串，长度未知），堆栈传参：串首地址
DISP_STR		PROC
				PUSH	BP
				MOV		BP,SP
				PUSH	SI
				PUSH	AX
				PUSH	DX

				MOV		SI,[BP+4]
				CLD
DISP1:			LODSB
				CMP		AL,0
				JZ		DISP_EXIT
				MOV		DL,AL
				MOV		AH,2
				INT		21H
				JMP		SHORT DISP1
DISP_EXIT:		MOV		DL,0DH
				MOV		AH,2
				INT		21H
				MOV		DL,0AH
				MOV		AH,2
				INT		21H
				
				POP		DX
				POP		AX
				POP		SI
				POP		BP
				RET		2
DISP_STR		ENDP
				
CODE			ENDS
	 
				END     MAIN
