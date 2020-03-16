assume cs:code,ss:stack
stack segment
    dw 8 dup(0)
stack ends

code segment
start:
    mov ax,stack
    mov ss,ax
    mov sp,10H          ; 设置栈顶指针
    mov ax,4240H
    mov dx,00FH
    mov cx,0AH

    call divdw

    mov ax,4c00H
    int 21H

divdw:
    push ax
    mov ax,dx
    mov dx,0
    div cx
    mov	bx,ax           ; 高16 位除数的商，这部分为溢出部分
    pop ax              ; 此时进行不会溢出的除法
    div cx
    mov cx,dx           ; cx 存放余数
    mov dx,bx           ; dx 存放溢出的高八位

    ret




code ends
end start