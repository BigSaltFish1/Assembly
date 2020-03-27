assume cs:code
data segment
    dw clear,foreColor,backColor,upLine
data ends
code segment
start:
    mov ax,data
    mov es,ax
    mov ax,cs
    mov ds,ax

    mov bx,0
    mov cx,4
    mov si,offset table
sss:
    mov ax,es:[bx]
    sub ax,offset do7c
    add ax,0200H
    mov [bx][si],ax
    add bx,2
    loop sss

    mov ax,0
    mov es,ax
    mov di,200H                   ; 复制到 0:200处
    mov si,offset do7c
    mov cx,offset do7cend - offset do7c
    cld

    rep movsb

    mov ax,0
    mov es,ax
    mov word ptr es:[7cH*4H],200H ; 设置向量表的ip
    mov word ptr es:[7cH*4H+2H],0 ; 设置向量表的cs

    mov ax,4c00H
    int 21H


do7c:
    jmp do7cstart
    table :dw 0,0,0,0
do7cstart:
    push ax
    push bx
    push cx
    push dx
    push ds
    push es
    cmp ah,3
    ja	return

    mov si,203H                   ; 中断向量表的起始地址
    mov dl,ah
    mov dh,0
    add dx,dx
    add si,dx                     ; 功能号对应地址
    mov dl,al                     ; 颜色信息

    mov ax,0B800H
    mov es,ax                     ; es 指向屏幕起始
    mov cx,2000                   ; 屏幕第一页的总字数25 * 80 个

    call word ptr cs:[si]

    jmp return

clear:
    mov bx,0
cloop:
    mov byte ptr es:[bx],32       ; 填成空格键
    add bx,2
    loop cloop
    ret

foreColor:
    mov bx,1
floop:
    mov es:[bx],dl                ; 设置颜色
    add bx,2
    loop floop
    ret
backColor:
    mov cl,4
    shl dl,cl
    mov cx,2000
    mov bx,1
bloop:
    mov es:[bx],dl
    add bx,2
    loop bloop
    ret
upLine:
    sub cx,80
    mov ax,0B800H+10              ; 段地址指向第二行的起始 0B80A0
    mov ds,ax
    mov bx,0
uloop:
    mov al,ds:[bx]
    mov es:[bx],al
    add bx,2
    loop uloop

    mov cx,80
upadding:                         ; 最后一行填充为空格
    mov byte ptr ds:[bx],32
    add bx,2
    loop upadding
    ret

return:
    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret
do7cend:
    nop

code ends
end start