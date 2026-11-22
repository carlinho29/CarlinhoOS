[org 0x7C00]
[bits 16]

KERNEL_LOAD_SEG equ 0x1000

start:
    cli                   
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          

    mov ah, 0x02            
    mov al, 2            
    mov ch, 0              
    mov cl, 2           
    mov dh, 0              
    mov dl, 0x80         
    mov bx, KERNEL_LOAD_SEG 
    
    push es
    mov ax, 0x0000
    mov es, ax
    mov bx, 0x1000
    int 0x13
    pop es
    jc disk_error        

    cli                     
    lgdt [gdt_descriptor]   

    mov eax, cr0
    or eax, 1             
    mov cr0, eax

    jmp 0x08:protected_mode_start

disk_error:
    mov si, err_msg
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

err_msg db "Erro fatal: Nao foi possivel carregar o kernel!", 0

gdt_start:
    dq 0x0000000000000000   

gdt_code:
    dw 0xFFFF              
    dw 0x0000               
    db 0x00                
    db 10011010b           
    db 11001111b           
    db 0x00                

gdt_data:
    dw 0xFFFF            
    dw 0x0000               
    db 0x00             
    db 10010010b            
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  
    dd gdt_start              

[bits 32]
protected_mode_start:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000        

    jmp 0x1000

times 510 - ($ - $$) db 0   
dw 0xAA55                 
