STACK			SEGMENT	PARA STACK
STACK_AREA      DW      100H DUP(?)
STACK_TOP		EQU		$ - STACK_AREA
STACK			ENDS

DATA			SEGMENT	PARA
TABLE           DW 		3157H, 1234H, 5678H, 1737H
TABLE_LEN       EQU		4
SPACE			DB		20H,'$'
NEW_LINE		DB		0DH,0AH,'$'

DATA			ENDS

CODE			SEGMENT
				ASSUME	CS:CODE,DS:DATA,SS:STACK
				
;主函数
MAIN			PROC	FAR
				;初始化SS,SP,DS
				MOV     AX,STACK
				MOV 	SS,AX
				MOV		SP,STACK_TOP
				MOV		AX,DATA
                MOV     DS,AX   
				;主体
				CALL	DISP_ARRAY
				CALL	SORT
				CALL	DISP_ARRAY
				;返回DOS
				MOV		AX,4C00H
				INT		21H
MAIN			ENDP

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

;输出数组
DISP_ARRAY		PROC
				PUSH	DX
				PUSH	CX
				PUSH	BX
				PUSH	AX
				PUSH	SI
				
				MOV		CX,TABLE_LEN
				MOV		SI,OFFSET TABLE

DALP:			MOV		AX,[SI]
				CALL	DISP_VALUE ;显示一个字
				MOV		DX,OFFSET SPACE
				MOV		AH,9
				INT		21H ;显示空格
				INC 	SI
				INC		SI
				LOOP	DALP

				MOV		DX,OFFSET NEW_LINE ;换行
				MOV		AH,9
				INT		21H
				
				POP		SI
				POP 	AX
				POP		BX
				POP		CX
				POP		DX
				RET
DISP_ARRAY		ENDP

;排序			
SORT			PROC
				PUSH	DX
				PUSH	CX
				PUSH	BX
				PUSH	AX
				PUSH	SI
				
PART2:			MOV		CX,TABLE_LEN
				DEC		CX
				;外循环开始
LP2:			MOV		BX,1 ;BX为FLAG标志位
				MOV		SI,OFFSET TABLE
				PUSH	CX ;保护外循环次数
				;内循环开始
LP2_1:			MOV		AX,[SI]
				CMP		AX,[SI+2]
				JBE		CONTINUE
				XCHG	AX,[SI+2]
				MOV		[SI],AX
				MOV		BX,0
CONTINUE:		ADD		SI,2
				LOOP	LP2_1
				;内循环结束
				POP 	CX ;恢复外循环次数
				DEC		CX
				CMP		BX,1
				JZ		EXIT ;本次未发生交换
				JMP		SHORT LP2
				;外循环结束
				
EXIT:			POP		SI
				POP		AX
				POP		BX
				POP		CX
				POP		DX
				RET
SORT			ENDP	
				
CODE			ENDS
	 
				END     MAIN
