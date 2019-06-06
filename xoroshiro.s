;;;;
;;;; xoroshiro.s
;;;;
section .data

s0:         dd      137546
s1:         dd      729

buffer:     dd      0

section .text

global _start
_start:

    push rbp
    mov rbp, rsp

.loop:

    call next
    mov dword [buffer], eax ; Return value from next in eax

    mov rax, 1          ; Write syscall
    mov rdi, 1          ; Stdout
    mov rsi, buffer     ; Address
    mov rdx, 4          ; Length
    syscall

    jmp .loop

    pop rbp

    mov rax, 60
    mov rdi, 0
    syscall

next:
    ; ebx = tmp
    ; r12d = s0
    ; r14d = mul arg
    ; r15d = 2nd temp

    mov eax, [s0]        ; eax = s0
    mov r14d, 0x9E3779BB
    mul r14d             ; s0 * 0x9E...
    rol eax, 5           ; (s0 * 0x9E...) ROL 5
    mov r14d, 5
    mul r14d             ; ((s0 * 0x9E...) ROL 5) * 5

    mov ebx, [s1]
    xor ebx, [s0]  ; tmp = s1 XOR s0

    mov r15d, ebx  ; r15d = tmp
    mov r12d, [s0] ; r12d = s0
    rol r12d, 26   ; s0 ROL 26
    xor r12d, ebx  ; (s0 ROL 26) XOR tmp
    shl r15d, 9    ; tmp << 9
    xor r12d, r15d ; s0 = (s0 ROL 26) XOR tmp XOR (tmp << 9)
    mov [s0], r12d

    rol ebx, 13   ; s1 ROL 13
    mov [s1], ebx ; s1 = s1 ROL 13

    ; Return results in eax.
    ret
