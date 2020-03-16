assume cs:code
code segment

    s1: db 'Good,better,best','$'
    s2: db 'Never let it rest','$'
    s3: db 'Till good is better','$'
    s4: db 'And better,best','$'
    s : dw offset s1,offset s2,offset s3,offset s4
    row: db 2,4,6,8
start:
    mov ax,cs
    mov ds,ax

    mov bx,offset s
    mov si,offset row
    mov cx,4

next:
    mov bh,0
    mov dh,[si] ; 填写行数，为存放着row的si
    mov dl,30   ; 设置为0 被遮挡，效果不明显
    mov ah,2    ; 功能号为2 的int 10H 设置光标位置
    int 10H

    mov dx,[bx] ; 字符串起点
    mov ah,9    ; 功能号为9 的int 21H显示ds:[dx] 开头的字符串，以'$' 结尾
    int 21h

    inc si
    add bx,2    ; 读取下一个,bx 对应的2字节，si 对应1字节
    loop next

    mov ax,4c00H
    int 21H

code ends
end start