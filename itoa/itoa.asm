; Example program to convert an integer into an ASCII char/string
;

;  Data declarations

section .data

;  Constants

NULL			equ	0
EXIT_SUCCESS		equ	0
SYS_exit		equ	60

;  Data

intNum			dd	1498	; 32 bit var

section			.bss
strNum			resb	10	; 10 element byte array


section			.text
global			_start
_start:

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
	
	; Shoule be done				
	
	last:
	
		mov	rax, SYS_exit
		mov	rdi, EXIT_SUCCESS
		syscall
		
