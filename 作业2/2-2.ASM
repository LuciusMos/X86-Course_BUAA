STACK			SEGMENT	PARA STACK
STACK_AREA      DW      100h DUP(?)
STACK_TOP		EQU		$-STACK_AREA
STACK			ENDS

DATA			SEGMENT	PARA
				
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
                CALL	GETNUM
				MOV		BX,AX
				CALL	GETNUM
				MUL		BX
				CALL	DISP_VALUE
				;返回DOS
				MOV		AX,4C00H
				INT		21H
MAIN			ENDP

;从键盘输入读取一个数,结果存在AX中
GETNUM			PROC
				PUSH 	SI
				PUSH	DX
				PUSH	BX
				
				MOV		SI,0 ;SI存放结果
				MOV		BX,10 ;乘数
				XOR		AX,AX
LP1:			MOV		AH,1
				INT		21H
				CMP		AL,0DH
				JE		RETURN ;是否为回车
				CMP		AL,30H
				JB		LP1 ;是否小于'0'
				CMP		AL,39H
				JA		LP1 ;是否大于'9'
				AND		AL,0FH
				XOR		AH,AH
				PUSH	AX
				MOV		AX,SI
				MUL		BX
				MOV		SI,AX
				POP		AX
				ADD		SI,AX
				LOOP	LP1
				
RETURN:			MOV		AX,SI
				POP		BX
				POP		DX
				POP		SI
				RET
GETNUM			ENDP

;显示内存中的字,AX传入要输出的字
DISP_VALUE		PROC
				PUSH	DX
				PUSH	CX
				PUSH	BX
				PUSH	AX
				
				MOV		CX,5
				MOV		BX,10
				
DVLP1:			XOR		DX,DX
				DIV		BX
				PUSH	DX
				LOOP	DVLP1
				
				MOV		BX,0 ;BX为是否为前导0的标志位
				MOV		CX,5
DVLP2:			POP		DX
				CMP		DL,0
				JNZ		DVLP2_1 ;不是0，转去显示
				CMP		BX,0
				JZ		DVLP2_2 ;是0，但不是前导0，也要显示
DVLP2_1:		MOV		BX,1
				OR		DL,30H
				MOV		AH,2
				INT		21H ;从0变为'0'，然后显示
DVLP2_2:		LOOP	DVLP2 ;不显示，直接continue

				POP 	AX
				POP		BX
				POP		CX
				POP		DX
				RET
DISP_VALUE		ENDP

CODE			ENDS		 

				END     MAIN