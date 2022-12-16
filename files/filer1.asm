; Example of assembly file I/O
;

section .data

; Constants

LF		equ	10
NULL		equ	0
BUFF_SIZE	equ	255
EXIT_SUCCESS	equ	0
STDIN		equ	0
STDOUT		equ	1

SYS_exit	equ	60
SYS_read	equ	0
SYS_write	equ	1
SYS_open	equ	2
SYS_close	equ	3

O_RDONLY	equ	000000q

; Variables

newLine		db	LF, NULL
header		db	LF, "File read example."
		db	LF, LF, NULL
		
fileName	db	"test.txt"
fileDesc	dq	0

errMsgOpen	db	"Error opening file.", LF, NULL
errMsgRead	db	"Error reading file.", LF, NULL

section .bss

readBuffer	resb	BUFF_SIZE

section .text
global _start
_start:

; Display header
	mov	rdi, header
	call	printString
	
; Attempt to open file
;
;  System Service - Open
;      rax = SYS_open
;      rdi = address of file name string
;      rsi = attributes (i.e., read only, etc.) 
;  Returns:
;      if error -> eax < 0
;      if success -> eax = file descriptor number
;
openInputFile:
	mov	rax, SYS_open
	mov	rdi, fileName
	mov	rsi, O_RDONLY
	syscall
	
	cmp	rax, 0			; check for success
	jl	errorOnOpen
	
	mov	qword [fileDesc], rax	; save descriptor
	
; read from file
;
;  System Service - Read
;      rax = SYS_read
;      rdi = file descriptor
;      rsi = address of where to place data
;      rdx = count of characters to read 
; Returns:
;      if error -> rax < 0
;      if success -> rax = count of characters actually read
;
	mov	rax, SYS_read
	mov	rdi, qword [fileDesc]
	mov	rsi, readBuffer
	syscall
	
	cmp	rax, 0
	jl	errorOnRead
	
; print the buffer (and add NULL for printString)
;
	mov	rsi, readBuffer
	mov	byte [rsi + rax], NULL
	mov	rdi, readBuffer
	call	printString
	
	; print newLine
	mov	rdi, newLine
	call	printString
	
; close open file
	mov	rax, SYS_close
	mov	rdi, qword [fileDesc]
	syscall
	
	jmp	endOfProgram
	
errorOnOpen:				; eax contains error which is not yet used
	mov	rdi, errMsgOpen
	call	printString
	
	jmp	endOfProgram
	
errorOnRead:
	mov	rdi, errMsgRead
	call	printString
	
	jmp	endOfProgram
	
; end of program
endOfProgram:

	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall
	
; printString
;
global printString
printString:

	push	rbp
	mov	rbp, rsp
	push	rbx
	
	; Count the string chars
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
	mov	rax, SYS_write
	mov	rsi, rdi
	mov	rdi, STDOUT
	syscall
prtDone:
	pop	rbx
	pop	rbp
	ret

