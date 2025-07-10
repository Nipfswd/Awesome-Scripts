; x86_bootloader.asm
; Simple bootloader
; Assembled with NASM, 512 bytes total

BITS 16                  ; 16-bit real mode
ORG 0x7C00               ; BIOS loads boot sector here

start:
    mov si, msg          ; SI points to the message string

print_loop:
    lodsb                ; Load byte at SI into AL, increment SI
    cmp al, 0            ; Check for string end (null byte)
    je hang              ; If zero, jump to hang

    mov ah, 0x0E         ; BIOS teletype print function
    mov bh, 0x00         ; Page number
    mov bl, 0x07         ; Text color (light gray)
    int 0x10             ; BIOS interrupt to print character

    jmp print_loop       ; Repeat for next char

hang:
    cli                  ; Disable interrupts
    hlt                  ; Halt CPU

msg db "Hello, Bootloader!", 0

; Fill rest of 512 bytes with zeros except last 2 bytes
times 510 - ($ - $$) db 0
dw 0xAA55               ; Boot signature - must be at byte 511-512
