[org 0x1000]
[bits 32]

kernel_main:
    mov ax, 0x10
    mov ds, ax
    mov es, ax

    mov edi, 0xB8000
    mov ecx, 80 * 25     
    mov ah, 0x1F           
    mov al, ' '

clear_screen:
    mov [edi], ax
    add edi, 2
    loop clear_screen

    mov esi, msg_welcome
    mov edi, 0xB8000       
    mov ah, 0x1F           

print_loop:
    lodsb                   
    test al, al
    jz hang
    mov [edi], ax       
    add edi, 2
    jmp print_loop

hang:
    cli
    hlt                   
    jmp hang

msg_welcome db "CarlinhoOS v0.1 - Ready to code", 0

times 1024 - ($ - $$) db 0  
