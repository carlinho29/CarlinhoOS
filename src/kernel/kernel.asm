[org 0x1000]
[bits 32]

%include "src/kernel/video.asm"
%include "src/kernel/keyboard.asm"
%include "src/kernel/memory.asm"

kernel_main:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    call mem_init

    mov al, 0x1F
    call video_clear_screen

    mov esi, msg_banner
    mov ah, 0x1F
    call video_print_string

    mov ebx, 1024
    call mem_allocate
    mov [allocated_addr], eax

    mov esi, msg_mem_ok
    mov ah, 0x1E      
    call video_print_string
    mov edi, 0xB8A0    
main_loop:
    call keyboard_wait_key
    mov ah, 0x1F
    call video_print_char
    add edi, 2          
    jmp main_loop

hang:
    cli
    hlt
    jmp hang

msg_banner     db "=== CarlinhoOS v0.1 - Advanced Kernel ===", 13, 10, 0
msg_mem_ok     db " [OK] Heap de memoria inicializada em 2MB.", 0
allocated_addr dd 0

times 2048 - ($ - $$) db 0
