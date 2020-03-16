; int 7ch 作为显示字符串的安装程序
assume cs:code
code segment
start:
    mov ax,cs
    mov ds,ax
    mov ax,0
    mov es,ax
    mov di,200H                   ; 复制到 0:200处

    mov si,offset do7c

    mov cx,offset do7cend - offset do7c
    rep movsb

    mov ax,0
    mov es,ax
    mov word ptr es:[7cH*4H],200H ; 设置向量表的CS
    mov word ptr es:[7cH*4H+2H],0 ; 设置向量表的ip

    mov ax,4c00H
    int 21H

do7c:
    mov ax,0B800H
    mov es,ax
    mov al,0A0H                   ; dh 行
    mul dh
    mov dh,0
    add ax,dx
    add ax,dx                     ; dl 列
    mov di,ax
l:
    cmp byte ptr [si],0
    je  return
    mov al,[si]
    mov es:[di],al                ; 显示字符
    inc si
    inc di
    mov es:[di],cl                ; 显示字符的颜色
    inc di
    jmp l
return:
    iret
do7cend:
    nop

code ends
end start