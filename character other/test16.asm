assume cs:code
code segment
start:
    mov ah,1   ; 变前景色
    mov al,2
    int 7cH
    call delay

    mov ah,2   ; 变背景色
    mov al,6
    int 7cH
    call delay

    mov ah,3   ; 向上滚动一行
    int 7cH
    call delay

    mov ah,0   ; 清屏
    int 7cH

    mov ax,4c00H
    int 21H

delay:
    push ax
    push dx
    mov dx,30H
    mov ax,0
s1:	sub ax,1
    sbb dx,0
    cmp ax,0
    jne s1
    cmp dx,0
    jne s1

    pop dx
    pop ax
    ret

code ends
end start