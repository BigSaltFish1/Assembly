assume cs: codesg
codesg segment
    mov ax,4c00h
    int 21h

start:
    mov ax,0
s:
    nop
    nop
    mov di,offset s
    mov si,offset s2
    mov ax,cs:[si]  
    mov cs:[di],ax;此处发生了s 标签的偏移的命令复制给了s的nop,nop
	; 由于jmp short 是ip = ip + 偏移的形式
	; 因此在 jmp short s 后, s 的第一个命令已经被替换为ip 向上移动 8 个字节
	; 到达cs:0处，执行4c00h的int 21h 中断退出
s0:
    jmp short s
s1:
    mov ax,0
    int 21h
    mov ax,0
s2:
    jmp short s1		;机器码为ip 向上移动到s1的位置，ip = ip - 8
    nop
codesg ends
end start
