STACK			SEGMENT	PARA STACK
STACK_AREA      DW      100h DUP(?)
STACK_TOP		EQU		$-STACK_AREA
STACK			ENDS

DATA			SEGMENT	PARA
XX          	DD 		17373157H
YY				DD		17061706H
RESULT			DW		4 DUP(0H)
NEW_LINE		DB		0DH,0AH,'$'
DATA			ENDS

CODE			SEGMENT
				ASSUME	CS:CODE,DS:DATA,SS:STACK

;主函数	
MAIN			PROC	FAR
				;初始化SS,SP,DS
				MOV     AX,STACK
				MOV		SS,AX
				MOV		SP,STACK_TOP
				MOV		AX,DATA
                MOV     DS,AX
				;主体
                CALL	MUL_32
				CALL	DISP_HEX
				MOV		DX,OFFSET NEW_LINE ;换行
				MOV		AH,9
				INT		21H
				CALL	DISP_DEC
				;返回DOS
				MOV		AX,4C00H
				INT		21H
MAIN			ENDP

;32位乘法
MUL_32			PROC
				PUSH	SI
				PUSH	DI
				PUSH	AX
				PUSH	BX
				PUSH	DX
				
				MOV		SI,OFFSET XX
				MOV 	DI,OFFSET YY
				;XX低16位 * YY低16位
				MOV		AX,WORD PTR[SI]
				MOV		BX,WORD PTR[DI]
				MUL		BX
				MOV		[RESULT],AX
				MOV		[RESULT+2],DX
				;XX高16位 * YY低16位
				MOV		AX,WORD PTR[SI+2]
				MOV		BX,WORD PTR[DI]
				MUL		BX
				ADD		[RESULT+2],AX
				ADC		[RESULT+4],DX
				ADC		[RESULT+6],0
				;XX低16位 * YY高16位
				MOV		AX,WORD PTR[SI]
				MOV		BX,WORD PTR[DI+2]
				MUL		BX
				ADD		[RESULT+2],AX
				ADC		[RESULT+4],DX
				ADC		[RESULT+6],0
				;XX高16位 * YY高16位
				MOV		AX,WORD PTR[SI+2]
				MOV		BX,WORD PTR[DI+2]
				MUL		BX
				ADD		[RESULT+4],AX
				ADC		[RESULT+6],DX
				
				POP		DX
				POP		BX
				POP		AX
				POP		DI
				POP		SI		
				RET
MUL_32			ENDP

;16进制显示内存中的字,AX传入要输出的字
DISP_VALUE		PROC
				PUSH	DX
				PUSH	CX
				PUSH	BX
				PUSH	AX
				
				MOV		CX,4
				MOV		BX,16
DLP1:			XOR		DX,DX
				DIV		BX
				OR		DL,30H
				CMP		DL,39H
				JBE		DIGIT
				ADD		DL,'A'-'9'-1
DIGIT:			PUSH	DX
				LOOP	DLP1
				
				MOV		CX,4
DLP2:			POP		DX
				MOV		AH,2
				INT		21H
				LOOP	DLP2

				POP 	AX
				POP		BX
				POP		CX
				POP		DX
				RET
DISP_VALUE		ENDP

;十六进制输出RESULT
DISP_HEX		PROC
				PUSH	DX
				PUSH	CX
				PUSH	AX
				PUSH	SI
				
				MOV		CX,4
				MOV		SI,OFFSET RESULT+6
L1:				MOV		AX,[SI]
				CALL	DISP_VALUE
				DEC		SI
				DEC		SI
				LOOP	L1
				
				POP		SI
				POP 	AX
				POP		CX
				POP		DX
				RET
DISP_HEX		ENDP

;将RESULT转换为十进制，并输出
DISP_DEC		PROC
				PUSH	AX
				PUSH	BX
				PUSH	CX
				PUSH	DX
				PUSH	SI
				
				MOV		CX,20
				MOV		BX,10
				MOV		SI,OFFSET RESULT
				; 将64位数视为4个16位数，在不改变数的大小情况下每部分除以10
                ; 前一次的余数DX作为下一次参加除法运算中被除数DX:AX的高16位
DECLP1:			;1
				XOR		DX,DX
				MOV		AX,WORD PTR[SI+6]
				DIV		BX
				MOV		WORD PTR[SI+6],AX
				;2
				MOV		AX,WORD PTR[SI+4]
				DIV		BX
				MOV		WORD PTR[SI+4],AX
				;3
				MOV		AX,WORD PTR[SI+2]
				DIV		BX
				MOV		WORD PTR[SI+2],AX
				;4
				MOV		AX,WORD PTR[SI]
				DIV		BX
				MOV		WORD PTR[SI],AX
				;余数入栈
				PUSH	DX
				LOOP	DECLP1
				
				MOV		BX,0
				MOV		CX,20
DECLP2:			POP		DX
				CMP		DL,0
				JNZ		DECLP2_1
				CMP		BX,0
				JZ		DECLP2_2
DECLP2_1:		MOV		BX,1
				OR		DL,30H
				MOV		AH,2
				INT		21H
DECLP2_2:		LOOP	DECLP2

				POP		SI
				POP		DX
				POP		CX
				POP		BX
				POP		AX
				RET
DISP_DEC		ENDP
				
CODE			ENDS		 

				END     MAIN