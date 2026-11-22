[bits 32]

global keyboard_wait_key

scancode_to_ascii:
    db 0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8  
    db 9, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 13   
    db 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', 39,  96        
    db 0, 92, 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',  0          
    db '*'
    db 0, ' '                                                              

keyboard_wait_key:
.wait_input:
    in al, 0x64        
    test al, 1       
    jz .wait_input

    in al, 0x60         
    test al, 0x80      
    jnz .wait_input

    cmp al, 0x3A        
    ja .wait_input

    movzx ecx, al
    mov al, [scancode_to_ascii + ecx]
    test al, al
    jz .wait_input     
    ret
