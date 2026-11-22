[bits 32]

global mem_init
global mem_allocate

section .data
heap_ptr dd 0x200000   

section .text
mem_init:
    mov dword [heap_ptr], 0x200000
    ret

mem_allocate:
    push ebx
    mov eax, [heap_ptr]
    add [heap_ptr], ebx     
    pop ebx
    ret
