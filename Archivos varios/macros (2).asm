print macro buffer
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset buffer
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

PasarRuta macro buffer1,buffer2,init
LOCAL paso, fin
xor si, si
xor di, di
mov si,init
paso:
	mov al, buffer2[si] ;;; -abrir_archi.txt
	cmp al, 24h ; '$'
	je fin
	mov buffer1[di], al
	inc si
	inc di
	jmp paso
fin:
	mov al, 00h
	mov buffer1[si], al
endm


Abrir macro buffer,handler
mov ah, 3dh
mov al, 02h
lea dx, buffer
int 21h
jc Error1
mov handler, ax
endm

; Cerrar macro handler
; mov ah, 3eh
; mov bx, handler
; int 21h
; endm


Leer macro handler, buffer, numbytes
mov ah, 3fh
mov bx, handler
mov cx, numbytes
lea dx, buffer
int 21h
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

; Crear macro buffer, handler
; mov ah,3ch
; mov cx, 00h
; lea dx, buffer
; int 21h
; endm

; Escribir macro handler, buffer, numbytes
; mov ah, 40h
; mov bx, handler
; mov cx, numbytes
; lea dx, buffer
; int 21h
; endm

imprimir macro buffer ;imprime cadena
push ax
push dx

	mov ax, @data
	mov ds,ax
	mov ah,09h ;Numero de funcion para imprimir buffer en pantalla
	mov dx,offset buffer ;equivalente a que lea dx,buffer, inicializa en dx la posicion donde comienza la cadena
	int 21h

pop dx
pop ax
endm

escribirChar macro char
		mov ah, 02h
		mov dl, char
		int 21h
endm

posicionarCursor macro x,y
	mov ah,02h
	mov dh,x
	mov dl,y
	mov bh,0
	int 10h
endm

imprimirVideo macro caracter, color
	mov ah, 09h
	mov al, caracter ;al guarda el valor que vamos a escribir
	mov bh, 0
	mov bl, color ; valor binario rojo
	mov cx,1
	int 10h
endm

esDiptongo macro caracter1, caracter2, caracter3 ;en el registor al va a tener un 1 si es un diptongo o un 0 si no lo es
LOCAL salida, esA, esE, esIi, esO, esU, esDip, esHia,esTrip,DHa,TRi,esIii, esUu
mov al,0h

cmp caracter3,105;i
je TRi

cmp caracter3,117;u
je TRi

DHa:
	esA:
		cmp caracter1,97 ;97 es a
		jne esE

		; --- Diptongo ---
		cmp caracter2,105	; i
		je esDip

		cmp caracter2, 117	; u
		je esDip

		; --- Hiato ---
		cmp caracter2,97	; a
		je esHia

		cmp caracter2,101	; e
		je esHia

		cmp caracter2, 111	; o
		je esHia

		jmp salida
		
	esE:

		cmp caracter1,101 ;97 es e
		jne esIi

		; --- Diptongo ---
		cmp caracter2,105	; i
		je esDip

		cmp caracter2, 117	; u
		je esDip


		; --- Hiato ---
		cmp caracter2,101	; e
		je esHia

		cmp caracter2, 97	; a
		je esHia

		cmp caracter2, 111	; o
		je esHia

		jmp salida

	esIi:
		cmp caracter1,105 ; es i
		jne esO

		; --- Diptongo ---
		cmp caracter2, 97	; a
		je esDip

		cmp caracter2, 101	; e
		je esDip

		cmp caracter2, 111	; o
		je esDip

		cmp caracter2, 117 	; u
		je esDip


		; --- Hiato ---
		cmp caracter2, 105	; i
		je esHia


		jmp salida

	esO:

		cmp caracter1,111 ; es o
		jne esU

		; -- Diptongo ---
		cmp caracter2,105 ; i
		je esDip

		cmp caracter2, 117	; u
		je esDip

		; --- Hiato ---
		cmp caracter2,111 ; o
		je esHia

		cmp caracter2, 97	; a
		je esHia

		cmp caracter2, 101	; e
		je esHia

		jmp salida

	esU:

		cmp caracter1,117 ;es u
		jne salida

		; --- Diptongo ---
		cmp caracter2,97 ; a
		je esDip

		cmp caracter2,101 ; e
		je esDip

		cmp caracter2,105 ; i
		je esDip

		cmp caracter2,111	;o
		je esDip

		; --- Hiato --- 
		cmp caracter2,117 ; u
		je esHia

		jmp salida

TRi:
	esIii:
		cmp caracter1,105 ; es i
		jne esUu

		; --- Triptongo ---
		cmp caracter2, 97	; a
		je esTrip

		cmp caracter2, 101	; e
		je esTrip

		cmp caracter2, 111	; o
		je esTrip

		jmp salida

	esUu:

		cmp caracter1,117 ;es u
		jne salida

		; --- Triptongo ---
		cmp caracter2,97 ; a
		je esTrip

		jmp salida

esDip:
	mov al,1h
	jmp salida

esHia:
	mov al,2h
	jmp salida

esTrip:
	mov al,3h
	jmp salida

salida: 

endm


;1.1
;[49][46][49]
;ax = entera
;bx = decimal
IntToString macro num, number ; ax 1111 1111 1111 1111 -> 65535
LOCAL Inicio,Final,Mientras,MientrasN,Cero,InicioN
push si
push di
Limpiar number,SIZEOF number,24h  ; '$'
mov ax,num ; ax = numero entero a convertir 23
cmp ax,0 
je Cero
xor di,di
xor si,si
jmp Inicio

;ax = 123

Inicio:
	
	cmp ax,0 ;ax = 0
	je Mientras
	mov dx,0 
	mov cx,10 
	div cx ; 1/10 = ax = 0 dx = 2
	mov bx,dx 
	add bx,30h ; 1 + 48 = ascii 
	push bx 
	inc di	; di = 3
	jmp Inicio

Mientras:
	;si = 0 , di = 3
	cmp si,di 
	je Final
	pop bx 
	mov number[si],bl 
	inc si 
	;si = 2 di = 3
	jmp Mientras

Cero:
 mov number[0],30h
 jmp Final

Final:
pop di
pop si
endm