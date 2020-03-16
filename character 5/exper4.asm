assume cs: code
code segment
    mov ax,code         ; cs 的段起点
    mov ds,ax
    mov ax,0020h
    mov es,ax
    mov cx,offset s+08H ; 代码段至mov ax,4c00H的长度
s:	mov al,[bx]
    mov es:[bx],al
    inc bx
    loop s
    mov ax,4c00H
    int 21H
code ends
end