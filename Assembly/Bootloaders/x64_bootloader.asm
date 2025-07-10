; x64_bootloader.asm
; Very minimal example to switch CPU to 64-bit long mode from BIOS bootloader
; This code fits in boot sector (512 bytes), but is just a *starting stub*

BITS 16
ORG 0x7C00

start:
    cli                     ; Disable interrupts

    ; Setup GDT for protected mode and long mode
    ; (GDT setup data follows after code)

    ; Load GDT
    lgdt [gdt_descriptor]

    ; Enable A20 line (needed for >1MB memory access)
    call enable_a20

    ; Enter protected mode
    mov eax, cr0
    or eax, 1               ; Set PE bit (bit 0)
    mov cr0, eax

    ; Far jump to flush prefetch and switch CS
    jmp 08h:protected_mode_start

; ------------------------------
BITS 32
protected_mode_start:
    ; Setup segments for protected mode
    mov ax, 10h             ; Data segment selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000        ; Setup stack

    ; Enable long mode
    mov ecx, 0xC0000080     ; IA32_EFER MSR
    rdmsr
    or eax, 0x100           ; Set LME (Long Mode Enable) bit
    wrmsr

    ; Setup page tables for long mode (not shown here, must be done)

    ; Enable paging and PAE in CR4 (not shown here)

    ; Enable paging in CR0 (not shown here)

    ; Jump to 64-bit long mode code segment (not shown here)

hang:
    hlt
    jmp hang

; ------------------------------
BITS 16

enable_a20:
    ; Simple A20 enable function using port 0x92
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

; ------------------------------
gdt_start:
    dq 0x0000000000000000    ; Null descriptor
    dq 0x00AF9A000000FFFF    ; Code segment descriptor (base=0, limit=4GB, code, readable)
    dq 0x00AF92000000FFFF    ; Data segment descriptor (base=0, limit=4GB, data, writable)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

times 510-($-$$) db 0
dw 0xAA55
