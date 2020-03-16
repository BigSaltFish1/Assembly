assume cs:code,ss:stack,ds:data
stack segment
    dw 0,0,0,0,0,0,0,0
stack ends

data segment
    db '1. display      '
    db '2. brows        '
    db '3. replace      '
    db '4. modify       '
data ends

code segment
start:
    mov ax,data
    mov ds,ax                   ; 越过ds的头部信息到达存储数据的位置

    mov bx,3
    mov al,020H                 ; 小写字符 -32 = 大写字符
    mov cx,4
next:
    push cx
    mov cx,4
upper:
    sub ds:[bx],al
    inc bx
    loop upper
finish:
    add bx,12
    pop cx
    loop next


    mov ax,4c00H
    int 21H
code ends
end start