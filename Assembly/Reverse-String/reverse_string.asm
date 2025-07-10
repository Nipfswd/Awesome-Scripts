section .data
    input    db 'Hello, Assembly!', 0
    msg      db 'Reversed: ', 0
    newline  db 10, 0

section .bss
    output   resb 100

section .text
    global _start

_start:
    ; Find length of input
    mov rsi, input
    xor rcx, rcx
find_len:
    cmp byte [rsi + rcx], 0
    je reverse
    inc rcx
    jmp find_len

reverse:
    ; RCX holds length
    mov rdi, output
    dec rcx
rev_loop:
    mov al, [input + rcx]
    mov [rdi], al
    inc rdi
    dec rcx
    jns rev_loop

    ; Null-terminate output
    mov byte [rdi], 0

    ; Write message
    mov rax, 1         ; syscall: write
    mov rdi, 1         ; file descriptor: stdout
    mov rsi, msg
    mov rdx, 10
    syscall

    ; Write reversed string
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, 100
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60        ; syscall: exit
    xor rdi, rdi
    syscall
