; 该程序会触发除法溢出中断
assume cs:code
code segment
start:
    mov ax,1000H
    mov bl,1
    div bl

    mov ax,4c00H
    int 21H

code ends
end start