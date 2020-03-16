assume cs:code

code segment
start:
    mov ax,cs
    mov ds,ax
    mov si,offset do0
    mov ax,0
    mov es,ax
    mov di,200H
    mov cx,offset do0end - offset do0
    cld
    rep movsb                  ; 安装do0 代码

; 更新中断向量表，向量表中，每个向量v的	v[0:1] 放着cs ，v[2:3] 放着ip

    mov ax,0
    mov es,ax
    mov word ptr es:[0*4],200H ; 设置向量表的CS
    mov word ptr es:[0*4+2],0  ; 设置向量表的ip
    mov ax,4C00H
    int 21H

do0:
    jmp short do0start
    db 'divide error'

do0start:
    mov ax,cs
    mov ds,ax
    mov si,202H

    mov ax,0B800H
    mov es,ax
    mov di,12*160+36*2         ; es:[di] 显存显示在屏幕中间的地址

    mov cx,12
s:
    mov al,[si]
    mov es:[di],al
    inc si
    inc di
    mov es:[di],3              ; 添加颜色信息
    inc di
    loop s

    mov ax,4c00H
    int 21H



do0end:
    nop
code ends
end start