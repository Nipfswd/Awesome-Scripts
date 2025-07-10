// x86_kernel.c - Minimal x86 kernel in C

typedef unsigned short uint16_t;
typedef unsigned int uint32_t;

// VGA text buffer starts at 0xB8000
volatile uint16_t* vga_buffer = (uint16_t*)0xB8000;

// VGA text mode: 80x25 characters
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

// Color attribute: light gray on black
#define VGA_COLOR 0x07

void kernel_main() {
    const char *message = "Hello from basic x86 kernel in C!";

    for (int i = 0; message[i] != '\0'; i++) {
        vga_buffer[i] = (uint16_t)message[i] | (VGA_COLOR << 8);
    }

    // Halt CPU indefinitely
    while (1) {
        __asm__ volatile ("hlt");
    }
}
