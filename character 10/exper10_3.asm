assume cs:code,ds:data,ss:stack
stack segment
    dw 16 dup(0)
stack ends
data segment
    dw 123,12666,1,8,3,38,0,0
    db 16 dup(0)
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov ax,020H
    mov sp,ax                   ; 初始化ss，sp，ds的地址

    mov bx,0H                   ; ds:[bx]指向需要显示的第一个数
    mov cx,6                    ; 有6个数需要打印

    mov dh,8                    ; 显示的起始行
    mov dl,1                    ; 显示的列数



l:	mov ax,[bx]
    push bx
    push cx
    push dx                     ; 压入栈，保留现场

    mov cx,0
    mov bx,0AH
    call dtoc                   ; 将ax的数据打印成字符显示

    pop dx                      ; pop dx，恢复，为显示在屏幕上的位置
    mov cl,3                    ; 颜色
    mov si,010H                 ; 要输出的字符串的起点
    call show_str
    mov cx,16                   ; 已显示的字符串占用的内存清为0，避免对数字显示时造成干扰
    mov bx,010H                 ; cx 位清除的字节数，ds:[bx]为清除的起始位置
    call clear

    inc dh                      ; 到下一行显示
    pop cx                      ; 恢复现场
    pop bx
    add bx,2                    ; 指向下一个数字

    loop l                      ; 循环打印所有数字

    mov ax,4c00H
    int 21H
dtoc:
    inc cx
    mov dx,0
    div bx
    add dx,48
    push dx                     ; 余数入栈
    cmp ax,0
    jne dtoc

    mov bx,010H
copy:
    pop ax
    mov [bx],al
    inc bx
    loop copy
    ret

show_str:
    mov ax,0B800H
    mov es,ax
    mov al,0A0H                 ; 一行80字符，160bytes
    mul dh                      ; 行号

    mov bx,0
    add bl,dl                   ; 列号,一个字符需要两个字节显示,加两次
    add bl,dl

    add bx,ax                   ; bx存放显示的起始位置 B8000+dh * A0 + dl*2

show:
    mov al,[si]
    mov es:[bx],al              ; 移动字符
    inc bx
    mov es:[bx],cl              ; 添加颜色信息
    inc bx
    inc si
    cmp byte ptr [si],0
    jnz show                    ; 不为零则继续
    ret

clear:
    mov byte ptr [bx],0
    inc bx
    loop clear
    ret


code ends
end start