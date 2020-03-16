assume cs:code,ds:data
data segment
    db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

code segment
start:
    mov ax,data
    mov ds,ax
    mov si,0
    call letterc

    mov ax,4c00H
    int 21H

letterc:
    mov ah,'a'
    mov al,'z'
compare:
    cmp byte ptr [si],0  ; 该字符==0 返回
    je 	return
    cmp [si],ah          ; 该字符的ascii 码 < 'a' 或者 > 'z' continue
    jb 	continue
    cmp [si],al
    ja 	continue
    sub byte ptr [si],32 ; 大写字符转小写字符
continue:
    inc si
    jmp compare
return:
    ret

code ends
end start