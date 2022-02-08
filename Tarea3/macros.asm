ModoVideo macro 
	mov ah, 00h
	mov al, 13h 
	int 10h   
	mov ax, 0A000h
	mov ds, ax  ; DS = A000h (memoria de graficos).
endm 

ModoTexto macro  
	mov ah, 00h 
	mov al, 03h 
	int 10h 
endm 

getChar macro ;obtener caracter
    mov ah,01h ;se guarda en al en código hexadecimal del caracter leído 
    int 21h
endm

print macro cadena ;imprimir cadenas
    push ax
    push dx
    mov ax,@data
    mov ds,ax
    mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
	mov dx,offset cadena ;especificamos el largo de la cadena, con la instrucción offset
	int 21h  ;ejecutamos la interrupción
    pop dx 
    pop ax      
endm 

close macro  ;cerrar el programa
    mov ah, 4ch ;Numero de función que finaliza el programa
    int 21h
endm


pintar_linea macro color
	mov dl, color
	mov di, 3360
	linea:
		mov[di], dl
		add di,320
		cmp di, 48160
		jne linea
endm

imprimirVideo macro caracter, color
    mov ah, 09h
    mov al, caracter ;al guarda el valor que vamos a escribir
    mov bh, 0
    mov bl, color
    mov cx,1
    int 10h
endm

posicionarCursor macro x,y
    mov ah,02h
    mov dh,x
    mov dl,y
    mov bh,0
    int 10h
endm 