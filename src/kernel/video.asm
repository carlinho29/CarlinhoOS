[bits 32]

global video_clear_screen
global video_print_string
global video_print_char

video_clear_screen:
    push edi
    push ecx
    push ax
    
    mov edi, 0xB8000
    mov ecx, 80 * 25
    mov ah, al         
    mov al, ' '
.clear_loop:
    mov [edi], ax
    add edi, 2
    loop .clear_loop
    
    pop ax
    pop ecx
    pop edi
    ret

video_print_string:
    push esi
    push edi
    push eax
    
    mov edi, 0xB8000   
.print_loop:
    lodsb
    test al, al
    jz .done
    mov [edi], ax
    add edi, 2
    jmp .print_loop
.done:
    pop eax
    pop edi
    pop esi
    ret

video_print_char:
    mov [edi], ax
    ret
