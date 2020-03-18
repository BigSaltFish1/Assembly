; install int 9
assume cs:code
stack segment
    db 128 dup(0)
stack ends

code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,128

    push cs
    pop ds

    mov ax,0
    mov es,ax

    mov si,offset int9
    mov di,204H

    mov cx,offset int9end - offset int9
    cld
    rep movsb

    push es:[9*4]
    pop es:[200H]
    push es:[9*4+2]
    pop es:[202H]   ; call 原int9 中断使用
    cli
    mov word ptr es:[9*4],204H
    mov word ptr es:[9*4+2],0
    sti
    mov ax,4c00H
    int 21H

int9:
    push ax
    push bx
    push cx
    push es

    in al,60H
    pushf
    pushf
    pop bx
    and bh,1111100b
    push bx
    popf
    call dword ptr cs:[200H]

    cmp al,1EH +80H ; A的断码
    jne int9ret

    mov cx,0BFFFH - 0B800H
    mov ax,0B800H
    mov es,ax
    mov bx,0
showA:              ; 显示满屏的'A'
    mov byte ptr es:[bx],'A'
    add bx,2
    loop showA

int9ret:
    pop es
    pop cx
    pop bx
    pop ax
    iret

int9end: nop
code ends
end start