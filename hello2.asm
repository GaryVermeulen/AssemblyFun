section .data

STDOUT			equ 	1 ; standard output
SYS_write		equ 	1 ; call code for write
LF				equ 	10 ; line feed
NULL			equ 	0 ; end of string

EXIT_SUCCESS 	equ 	0 ; success code
SYS_exit 		equ 	60 ; terminate

message1	db "Hello System76 Ubuntu World.", LF, NULL
;;message1	db "Hello World."
message1Len	dq	14

message2	db	"Good bye World!", LF, NULL
newLine		db	LF, NULL

section .text
global _start
_start:
	
	mov 	rdi, message1 				; msg address
	call	printString

	mov 	rdi, message2 				; msg address
	call	printString
	
	mov 	rdi, newLine 				; msg address
	call	printString

	
exitProg:
	mov 	rax, SYS_exit
	mov 	rdi, EXIT_SUCCESS
	syscall

	
global printString
printString:

	push	rbx
	
; Count chrs
	mov		rbx, rdi
	mov		rdx, 0
strCountLoop:
	cmp		byte [rbx], NULL
	je		strCountDone
	inc 	rdx
	inc 	rbx
	jmp		strCountLoop
strCountDone:

	cmp		rdx, 0
	je		prtDone
	
; Call OS to print string
	mov 	rax, SYS_write
	mov		rsi, rdi
	mov 	rdi, STDOUT
	syscall
	
; return to caller
prtDone:
	pop		rbx
	ret
	
	
