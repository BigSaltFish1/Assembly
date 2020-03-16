assume cs:code
data segment
    db 'Welcome to masm',0
data ends

code segment
start:
    mov dh,8
    mov dl,3
    mov cl,2
    mov ax,data
    mov ds,ax
    mov si,0
    call show_str

    mov ax,4c00h
    int 21h

show_str:
    mov ax,0B800H
    mov es,ax
    mov al,0A0H    ; 一行80字符，160bytes
    mul dh         ; 行号

    mov bx,0
    add bl,dl      ; 列号,一个字符需要两个字节显示,加两次
    add bl,dl

    add bx,ax      ; bx存放显示的起始位置 B8000+dh * A0 + dl*2

show:
    mov al,[si]
    mov es:[bx],al ; 移动字符
    inc bx
    mov es:[bx],cl ; 添加颜色信息
    inc bx
    inc si
    cmp byte ptr [si],0
    jnz show       ; 不为零则继续
    ret

code ends
end start