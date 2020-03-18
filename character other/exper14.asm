assume cs:code
data segment
    db '00/00/00 00:00:00','$' ; 用来显示的字符串，存放cmos 读取到的时钟值
    db 9,8,7,4,2,0             ; cmos 实时钟存放单元
data ends
code segment
start:
    mov ax,data
    mov ds,ax
    mov bx,0
    mov si,18
    mov cx,6                   ; 要读取6次，年月日，时分秒
l:	call read
    loop l

    call show
    mov ax,4c00H
    int 21H

read:
    push cx
    mov al,[si]
    out 70H,al
    in al,71H

    inc si
    call BCDto10               ; al 存放的BCD编码数值转成10进制，并放置到用来显示的字符串中

    pop cx
    ret

BCDto10:                       ; 把读取的字符转换后存入到上面定义的字符串中
    mov ah,al
    mov cl,4
    shr ah,cl                  ; 取得10进制十位数
    add ah,48                  ; 十进制转为字符串
    mov [bx],ah
    inc bx
    and al,00001111B           ; 取得个位数
    add al,48
    mov [bx],al
    add bx,2
    ret

show:                          ; 显示存放在data 段的第一个字符串
    mov ah,09H
    mov dx,0
    int 21H
    ret
code ends
end start