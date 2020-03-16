assume cs:code
a segment
    db 1,2,3,4,5,6,7,8   ; 小于16byte 故该segment 为 16bytes，下面同理
a ends
b segment
    db 3,1,4,6,2,5,6,7
b ends
c segment
    db 0,0,0,0,0,0,0,0
c ends
code segment
start:
    mov ax,a
    mov ds,ax
    mov bx,0H
    mov si,010H          ; segment 的长度

    mov cx,8H            ; 循环计算8次

l:	mov al,[bx]
    add al,[bx][si]
    mov [bx][si].010H,al ; 结果存入到 c segment 中 中
    inc bx
    loop l

    mov ax,4c00H
    int 21H
code ends
end start