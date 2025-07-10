; x32_bootloader.asm
; Simple x86 bootloader that switches to 32-bit protected mode
; Fits in 512 bytes boot sector

BITS 16
ORG 0x7C00

start:
    cli                     ; Disable interrupts

    call enable_a20         ; Enable A20 line

    ; Setup GDT descriptor
    lgdt [gdt_descriptor]

    ; Enable protected mode
    mov eax, cr0
    or eax, 1               ; Set PE bit in CR0
    mov cr0, eax

    ; Far jump to flush pipeline and switch CS to protected mode segment
    jmp 08h:protected_mode_start

; ---------------------------------
; A20 line enable subroutine (simple method)

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

; ---------------------------------
; Protected mode code (32-bit)

[BITS 32]
protected_mode_start:
    ; Set up segment registers with 32-bit data segment selector (0x10)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set up stack
    mov esp, 0x90000

    ; Now you are in 32-bit mode!
    ; Let's print a simple message using BIOS (will still work because INT 10h works in real mode segments)

    mov si, message
print_loop:
    lodsb                   ; load byte from [si] to al and increment si
    cmp al, 0
    je hang

    mov ah, 0x0E            ; BIOS teletype function
    mov bx, 0x0007          ; page 0, color light gray
    int 0x10

    jmp print_loop

hang:
    cli
    hlt
    jmp hang

; ---------------------------------
; GDT setup

gdt_start:
    dq 0x0000000000000000            ; Null descriptor
    dq 0x00CF9A000000FFFF            ; Code segment descriptor (base=0, limit=4GB, code, executable, readable)
    dq 0x00CF92000000FFFF            ; Data segment descriptor (base=0, limit=4GB, data, writable)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1       ; Limit (size of GDT - 1)
    dd gdt_start                     ; Base address of GDT

; ---------------------------------
message db "Hello from 32-bit protected mode!", 0

; Fill the rest of the 512 bytes with zeros and add boot signature
times 510 - ($ - $$) db 0
dw 0xAA55
