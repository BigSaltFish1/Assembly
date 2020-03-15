assume cs: codesg,ds: datasg		; B8000H~BFFFFH 为显卡缓冲区

datasg segment
		db	'welcome to masm!'  ;16bytes
		db	0BH
		db 	10B,100100B,01110001B
datasg ends

codesg segment
start:
	mov ax,0B800H	
	mov es,ax  		;es 定位屏幕第一页起始
	mov bx,110H		;16 ds:[bx]之后为存放行数的,因为存在头部之类的原因，需要偏移100H，跳过头部
	;再偏移10H到达 0BH在ds存放的偏移地址
	mov cx,3		;复制3行
	
	mov al,0A0H   ;1行80 字符，160bytes
	mul byte ptr ds:[bx]		;0BH * 0A0H 定位到屏幕12行
	add ax,60		;定位到行中间,ax 存放着偏移地址
	mov di,ax
	add di,020h		;指向打印后字符串末尾，方便循环用,字符串长16bytes，加上颜色信息32bytes = 020H
	inc bx    		;bx 指向颜色的区域,此时bx 指向颜色部分
	
next:
	mov si,0100H	; 字符串起始偏移
	add di,0a0h-020h; 到达下一行的复制起点
	push cx			; 外层循环cx
	mov cx,010H		; 内存循环
	
copy:
	
	mov al,[si]		;复制一个字符到屏幕缓存中
	mov es:[di],al		
	inc si				
	inc di
	
	mov al,ds:[bx]
	mov es:[di],al 	;添加颜色信息
	inc di
	loop copy
	
	
	inc bx   		; 下一行的颜色信息储存的偏移地址
	pop cx			; 外层循环
	loop next
	
	mov ax,4c00h	; 程序返回向dos
	int 21h
	
codesg ends
end start

	
	