; 要求为 参数循环次数cx，位移bx 为循环起点到终点的位移，int 7ch 的调用方式在书上
; 已复制在test13_2.asm中
; 参照书上的代码，bx 为s 到se 中长度，循环体为s到se
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
    push bp
    mov bp,sp
    dec cx                        ; 在执行前已被循环部分已被执行过一次，
                                  ; 先dec cx 会跳转到 循环开始处cx - 1次
    jcxz return                   ; 循环结束
    sub [bp+2],bx                 ; 得到s 处的位置，[bp + 2]存放的是se 的位置，s到se 的偏移为bx
                                  ; 则 offset se - bx = offset s
                                  ; 若执行了这一步，会返回到循环开始处
return:
    pop bp
    iret
do7cend:
    nop

code ends
end start