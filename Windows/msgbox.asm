global start

NULL  equ 0
MB_OK equ 0

extern MessageBoxA   ;from user32
extern ExitProcess   ;from kernel32

section .data
hello:  db 'Hello, Windows!',0
title:  db 'My First Win32',0

section .text
start:

        push    MB_OK
        push    title
        push    hello
        push    NULL
        call    MessageBoxA

        push    0
        call    ExitProcess


;nasm -f win64 myprog.asm
;golink myprog.obj user32.dll kernel32.dll