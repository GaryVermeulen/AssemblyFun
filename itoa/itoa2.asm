; Example program to convert an integer into an ASCII char/string
;

;  Data declarations

section .data

;  Constants

NULL			equ	0
LF			equ	10
EXIT_SUCCESS		equ	0
STDIN			equ	0
STDOUT			equ	1
SYS_exit		equ	60
SYS_read		equ	0
SYS_write		equ	1
STRLEN			equ	20

;  Data

newLine			db	LF, NULL
intNum			dd	1498					; 32 bit var
pmpt			db	"Converting int to char string: ", NULL

section			.bss
strNum			resb	10					; 10 element byte array
chr			resb	1
inLine			resb	STRLEN+2				; STRLEN + LF & NULL


section			.text
global			_start
_start:

; Display prompt

	mov	rdi, pmpt			; Display prompt
	call	printString
	
	mov	rbx, inLine			; inLine addr
	mov	r12, 0				; char count
			
; Part A -- Successive division

	mov	eax, dword [intNum]		; Get integer
	mov	rcx, 0				; digitCounter = 0
	mov	ebx, 10				; Set for dividing by 10
	
divideLoop:

	mov	edx, 0
	div	ebx
	
	push	rdx
	inc	rcx
	
	cmp	eax, 0
	jne	divideLoop

; Part B - Convert remainders and store
	
	mov	rbx, strNum			; Get addr of string
	mov	rdi, 0				; idx = 0
	
popLoop:

	pop	rax
	
	add	al, "0"				; char = int + "0"
	
	mov	byte [rbx + rdi], al		; string[idx] = char
	inc	rdi				; inc idx
	loop	popLoop				; if (digit Count > 0)
						;    goto popLoop
						
	; Output results
	
	mov	rdi, newLine
	call	printString
	
	mov	rdi, strNum
	call	printString
	
	mov	rdi, newLine
	call	printString	
	
	; Shoule be done				
	
	last:
	
		mov	rax, SYS_exit
		mov	rdi, EXIT_SUCCESS
		syscall
		
;
; Print function
;
global printString
printString:

	push rbx
	
; Count characters in string

	mov	rbx, rdi
	mov	rdx, 0
	
strCountLoop:

	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rdx
	inc	rbx
	jmp	strCountLoop
	
strCountDone:

	cmp	rdx, 0
	je	prtDone
	
; Call OS to output string

	mov	rax, SYS_write			; system code for write
	mov	rsi, rdi			; address of chars to write
	mov	rdi, STDOUT			; std out
						; RDX=count to write set above
	syscall
	
prtDone:

	pop	rbx
	ret
	
