assume cs:code

a segment
    dw 1,2,3,4,5,6,7,8,9,0ah,0bh,0ch,0dh,0eh,0fh ; 32 bytes
a ends
b segment
    dw 0,0,0,0,0,0,0,0                           ; 16 bytes
b ends
; a,b,code 段在地址中连续的
; a段复制到b段会因为b段空间不足，而写入到code段上
; 覆盖掉code段的代码
code segment
start:
    mov ax,a
    mov ds,ax
    mov si,020H
    mov bx,0

    mov cx,010H
l:	mov ax,[bx]
    mov [bx][si],ax
    add bx,02H

    loop l

code ends
end start