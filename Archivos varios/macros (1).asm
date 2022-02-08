print macro buffer
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset buffer
    int 21h
endm

close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h
endm

getChar macro
mov ah, 01h
int 21h
endm

Obtenertexto macro buffer
LOCAL ObtenerChar, FinOT

xor si, si ; Igual a Mov si,0
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii del salto de linea en hexadecimal
		je FinOT
		mov buffer[si], al ; mov destino, fuente
		inc si ; si = si + 1
		jmp ObtenerChar

	FinOT:
		mov al, 24h ; ascii del signo dolar
		mov buffer[si], al

endm

LlenarJ macro array1, array2, init
LOCAL ObtenerChar, FinOT
	xor si, si ; Igual a Mov si,0
	xor di, di
	mov di, init
		ObtenerChar:
			getChar
			cmp al, 0dh ; ascii del salto de linea en hexadecimal
			je FinOT
			mov array1[si], al ; mov destino, fuente
			mov array2[di], al
			inc si ; si = si + 1
			inc di ; di = si + 1
			jmp ObtenerChar

		FinOT:
			mov al, 24h ; ascii del signo dolar
			mov array1[si], al
endm

ObtenerRuta macro buffer
LOCAL ObtenerChar, FinOT
xor si, si ; Igual a Mov si,0
ObtenerChar:
getChar
cmp al,0dh ; ascii del salto de linea en hexadecimal
je FinOT
mov buffer[si], al ; mov destino, fuente
inc si ; si = si + 1
jmp ObtenerChar

FinOT:
mov al, 00h ; ascii del signo dolar
mov buffer[si], al
endm

ImprimirTablero macro arreglo
LOCAL Inicio, Mientras, FinMientras, ImprimirSalto
push si
push di

xor si,si
mov si,1
xor di,di
xor al,al
mov numeros, 49

	Inicio:
		cmp numeros, 57
		je FinMientras
			print numeros
			mov aux, 32
			print aux
			print aux
			print aux
			inc numeros
		jmp Mientras

	Mientras:
		cmp si,65
		je FinMientras				; while(si<=65){}

			mov al, arreglo[si]
			mov aux, al 		   ; print(arreglo[si])
			print aux

			cmp di,7
			je ImprimirSalto	 ; if(di == 7){ Imprimir salto}

			mov aux,32   		; else{print(" ")
			print aux
			print aux
			print aux
			
			inc di				;di++
			inc si   			; si++}
		jmp Mientras

	ImprimirSalto:
		xor di,di 			; di = 0
		print salto			;print("/n")
		print salto			;print("/n")
		mov aux,32   		; else{print(" ")
		inc si  			; si++
		jmp Inicio

	FinMientras:
pop di
pop si
endm


PasarTablero macro arreglo, arreglo2
LOCAL Mientras, FinMientras, ImprimirSalto
push si
push di
push sp

xor si,si
mov si,1
xor di,di
xor al,al
xor cx,cx
xor sp,sp
mov sp,5Fh
mov numeros, 49
	Mientras:
		cmp si,65
		je FinMientras			
			mov cx, arreglo[si]
			mov arreglo2[sp], cx
			cmp di,7
			je ImprimirSalto	
			inc di				
			inc si   			
			inc sp
		jmp Mientras

	ImprimirSalto:
		xor di,di 			; di = 0
		inc sp
		mov arreglo2[sp],10
		inc sp
		inc si  			; si++
		jmp Mientras

	FinMientras:
pop sp
pop di
pop si
endm


ImprimirLetras macro arreglo1
LOCAL aux1, aux2, aux3
push si
xor si,si
mov si,0

	aux1:
		cmp si,9
		je aux2
		mov al, arreglo1[si]
		mov aux, al 		   ; print(arreglo[si])
		print aux
		mov aux, 32
		print aux
		print aux
		print aux
		inc si
		jmp aux1

	aux2:
		xor si,si 			; di = 0
		print salto			;print("/n")
		print salto			;print("/n")
		mov aux,32   		; else{print(" ")
		jmp aux3

	aux3:
	
pop di
endm


AnalizarComando macro com ; A1:B2 arreglo1 = [A][1]; arreglo2 = [B][2]
LOCAL analizar, llenar, Condicional, Blancas, Negras, Error, Mover, SaLida

	analizar:
		mov al,com[0]
		mov posicionInicial[0],al ; arreglo1[0] = comando[0]

		mov al,com[1]
		mov posicionInicial[1],al ; arreglo1[1] = comando[1]

		mov al,com[3]
		mov posicionFinal[0],al ;  arreglo2[0] = comando[3]

		mov al,com[4]
		mov posicionFinal[1],al ;  arreglo2[1] = comando[4]

	llenar:

		ConversionCoordenadas posicionInicial ;convierte la coordenada y la guarda en al

		xor si,si ;si tiene el indicie inicial
		mov si,ax

		ConversionCoordenadas posicionFinal ;convierte la coordenada y la guarda en al

		xor di,di ;di tiene el indice inicial
		mov di,ax


	Condicional:
		xor al, al
		mov al, com[5]
		mov auxiliar, al
		cmp auxiliar, 98
		je Blancas

		cmp auxiliar, 110
		je Negras

		jmp Error


		Blancas:
			xor ax, ax
			mov al, tablero[si]
			cmp al, 98
			jne Error
			mov al, tablero[di]
			cmp al, 98
			je Error
			cmp al, 110
			je Error

			jmp Mover

			jmp Error


		Negras:
			xor ax, ax
			mov al, tablero[si]
			cmp al, 110
			jne Error
			mov al, tablero[di]
			cmp al, 110
			je Error
			cmp al, 98
			je Error


			; mov al, di
			; mov auxiliar, di
			; print di


			jmp Mover

			jmp Error


		Mover:
			xor ax,ax
			mov al, tablero[si] ;al = arreglo[si]
			mov tablero[si],95 ;arreglo[si] = '_'

			mov tablero[di],al ;arreglo[di] = arreglo[si]

			jmp SaLida

		Error:
			mov comando[5], 101
			print errorsaso
			getChar

		SaLida:


endm


ConversionCoordenadas macro coordenada ; A1 -> 1 -> (columna) + (fila-1)*4
	; ADD valor1, valor2 -> valor1 = valor1 + valor2
	; MUL valor -> al = al * valor
	; SUB valor1, valor2 -> valor1 = valor1 - valor2
	; DIV valor -> al = al / valor -> ah tiene el residuo 

	mov al, coordenada[0] ; al = A = 65
	mov columna, al        ; columna = 65
	ConversionColumna columna ; columna convertida

	mov al, coordenada[1] ; al = 1 = 49
	mov fila,al 		  ; fila =  49

	ConversionFila fila

	xor ax,ax
	xor bx,bx

	mov al,fila ;fila - 1
	SUB al,1

	mov bl,8
	MUL bl  ; (fila-1)*4 -> al

	xor bx,bx
	mov bl,columna 

	ADD al,bl ;(columna) + (fila-1)*4 = al

	;la conversion del resultado se guarda en al 
	;IntToString ax,numero
	;print numero
	;print salto

endm



ConversionColumna macro valor ; valor = valor - 64

	mov al,valor ; al = valor
	sub al,64   ; al = al - 64
	mov valor,al ; valor = al

endm



ConversionFila macro valor ; valor = valor - 48

	mov al,valor ; al = valor
	sub al,48   ; al = al - 48
	mov valor,al ; valor = al

endm


Abrir macro buffer,handler
mov ah, 3dh
mov al, 02h
lea dx, buffer
int 21h
jc Error1
mov handler, ax
endm

Cerrar macro handler
mov ah, 3eh
mov bx, handler
int 21h
jc Error1
endm


Leer macro handler, buffer, numbytes
mov ah, 3fh
mov bx, handler
mov cx, numbytes
lea dx, buffer
int 21h
jc Error1
endm

Limpiar macro buffer, numbytes, caracter
LOCAL Repetir
xor si,si
xor cx,cx
xor cx, numbytes
    Repetir:
    mov buffer[si], caracter
    Loop Repetir
endm

Crear macro buffer, handler
mov ah,3ch
mov cx, 00h
lea dx, buffer
int 21h
jc Error1
mov handler,ax
endm

Escribir macro handler, buffer, numbytes
mov ah, 40h
mov bx, handler
mov cx, numbytes
lea dx, buffer
int 21h
jc Error1
endm