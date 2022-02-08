;macros generales y macros específicos de la práctica 3
print macro buffer ;imprime cadena
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

close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h
endm

getChar macro  ;obtiene el caracter y se almacena el valor en el registro al

	mov ah,01h ; se guarda en al en codigo hexadecimal
	int 21h

endm

;id_macro macro (variable1, variables2 ... variablen)
obtenerTexto macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	;while (caracter != "/n"){
		;buufer[i] = caracter
		;i++
		;}
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto

		; si = 1

		mov buffer[si],al ;mov destino, fuente arreglo[1] = al
		; si = 2
		inc si ; si = si + 1 // si++
		jmp ObtenerChar

	endTexto:

		mov al,24h ; asci del singo dolar $
		mov buffer[si], al 

endm



obtenerRuta macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto
		mov buffer[si],al ;mov destino, fuente
		inc si ; si = si + 1
		jmp ObtenerChar

	endTexto:
		mov al,00h ;
		mov buffer[si], al  
endm

pasarRuta macro buffer1,buffer2,init
	LOCAL paso, fin
	xor si,si
	xor di,di
	mov si,init
	paso:
		mov al, buffer2[si]
		cmp al, 24h
		je fin
		mov buffer1[di],al
		inc si
		inc di
		jmp paso
	fin:
		mov al,00h
		mov buffer1[si],al
endm

abrir macro buffer,handler

	mov ah,3dh
	mov al,02h ;010b 2d
	lea dx,buffer
	int 21h
	jc Error1
	mov handler,ax ;C:/arichi.txt ----- 1245h

endm

cerrar macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	;jc Error2
	mov handler,ax

endm

leer macro handler,buffer, numbytes
	
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer ; mov dx,offset buffer 
	int 21h
	;jc  Error5

endm

limpiar macro buffer, numbytes, caracter
LOCAL Repetir
push si
push cx

	xor si,si
	xor cx,cx
	mov	cx,numbytes
	;si = 0
	Repetir:
		mov buffer[si], caracter
		inc si ; si ++
		Loop Repetir
pop cx
pop si
endm

crear macro buffer, handler
	
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	;ya cree el archivo
	;jump carry si la bandera de accareo esta en 1 se ejecuta
	;jc Error4
	mov handler, ax

endm

escribir macro handler, buffer, numbytes

	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	;jc Error3

endm



StringToInt macro string
LOCAL Unidades,Decenas,salir, Centenas

	sizeNumberString string; en la variable bl me retorna la cantidad de digitos
	xor ax,ax
	xor cx,cx

	cmp bl,1
	je Unidades

	cmp bl,2
	je Decenas

	cmp bl,3
	je Centenas



	Unidades:
		mov al,string[0]
		SUB al,30h
		jmp salir

	Decenas:

		mov al,string[0]
		sub al,30h
		mov bl,10
		mul bl


		xor bx,bx
		mov bl,string[1]
		sub bl,30h

		add al,bl

		jmp salir

;bl 1111 1111 ->255
; 0 - 999 
; bx 1111 1111 1111 1111 -> 65535
	Centenas:
	    ;543
		mov al,string[0] ;[0] -> 53 -> 5 en ascii
		sub al,30h;  -> 53-48 = 5 => Ax=5 => Ax-Ah,Al
		mov bx,100;  -> bx = 100
		mul bx; -> ax*bx = 5*100 = 500
		mov cx,ax; cx = 500
		;dx = Centenas

		xor ax,ax ; ax = 0
		mov al,string[1] ;[1] -> 52 -> 4 en ascii
		sub al,30h ; -> 52-48 = 4 => Ax=4 => Ax-Ah,Al
		mov bx,10 ;  -> bx = 10
		mul bx ; -> ax*bx = 4*10 = 40

		xor bx,bx
		mov bl,string[2] ;[2] -> 51 -> 3 en ascii
		sub bl,30h ; -> 51-48 = 3 => Ax=3 => Ax-Ah,Al

		add ax,bx ; ax = 3 + 40
		add ax,cx ; ax = 43 + 500 = 543
		
		jmp salir

	salir:
	

endm

;1.1
;[49][46][49]
;ax = entera
;bx = decimal
IntToString macro num, number ; ax 1111 1111 1111 1111 -> 65535
LOCAL Inicio,Final,Mientras,MientrasN,Cero,InicioN
push si
push di
limpiar number,SIZEOF number,24h
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

sizeNumberString macro string
LOCAL LeerNumero, endTexto
	xor si,si ; xor si,si =	mov si,0
	xor bx,bx

	LeerNumero:
		mov bl,string[si] ;mov destino, fuente
		cmp bl,24h ; ascii de signo dolar
		je endTexto
		inc si ; si = si + 1
		jmp LeerNumero

	endTexto:
		mov bx,si

endm

FloatToString macro entera, decimal, number

LOCAL Inicio,Final,MientrasEntero,Cero,FinalEntero, InicioDecimal, MientrasDecimal
push si
push di

limpiar number,SIZEOF number,24h
mov ax,entera ; ax = numero entero a convertir
cmp ax,0 
je Cero
xor di,di
xor si,si
jmp Inicio


Inicio:
	;514
	cmp ax,0 ; ax = 0 -> Brinca a mientras
	je MientrasEntero
	mov dx,0 ;dx = 0
	mov cx,10 ; cx = 10
	div cx ; ax / 10 ->   resultado => ax=0 ! residuo => dx = 1 
	mov bx,dx ; bx = residuo de la division = 1
	add bx,30h ; residuo => residuo + 30h => numero convertido a su valor en ascii
	push bx ; numero convertido a su valor en ascii en la pila [1] = 49 415
	inc di	; di = di + 1
	jmp Inicio

MientrasEntero:
;514
	cmp si,di ; di = 2 ! si = 1
	je FinalEntero
	pop bx ; bx = [0] = 52
	mov number[si],bl ; numero[1] = 52
	inc si ; si =1
	jmp MientrasEntero

Cero:
 mov number[0],30h
 jmp Final

FinalEntero:
;12.4
;si = 2
;Se termina de convertir la parte entera a texto
;Se asigna el punto decimal

mov number[si],46
inc si
inc di

;si = 3
;di = 3

mov ax,decimal ; ax = numero entero a convertir
cmp ax,0 
je CeroDecimal
jmp InicioDecimal


InicioDecimal:
	;514
	cmp ax,0 ; ax = 0 -> Brinca a mientras
	je MientrasDecimal
	mov dx,0 ;dx = 0
	mov cx,10 ; cx = 10
	div cx ; ax / 10 ->   resultado => ax=0 ! residuo => dx = 1 
	mov bx,dx ; bx = residuo de la division = 1
	add bx,30h ; residuo => residuo + 30h => numero convertido a su valor en ascii
	push bx ; numero convertido a su valor en ascii en la pila [1] = 49 415
	inc di	; di = di + 1
	jmp InicioDecimal

MientrasDecimal:
;514
	cmp si,di ; di = 7 ! si = 4
	je Final
	pop bx ; bx = [0] = 52
	mov number[si],bl ; numero[1] = 52
	inc si ; si =1
	jmp MientrasDecimal

CeroDecimal:
 mov number[si],30h
 jmp Final


Final:


pop di
pop si


endm


DivisionConDecimal macro num1, num2 ; 13 / 5
LOCAL ForAux,Final

	mov ax,num1 ;13
	mov bx,num2 ; 5
	div bx ;13/5 -> ax = 2 ! dx = 3
	mov residuo,dx
	mov resultadorDivisionEntero,ax ; 2

	ForAux:
		cmp residuo,0
		je Final
		mov bx,10 ; bx = 10
		mov ax, residuo ;ax = 3
		mul bx ; ax = 10*3 = 30
		mov bx,num2 ;bx = 5
		div bx ; 30/5
		mov residuo,dx
		mov resultadorDivisionDecimal,ax
		jmp ForAux

Final:

endm


agregarExt macro ruta

LOCAL Mientras, FinMientras
	xor si,si ; xor si,si =	mov si,0
	;hola
	;0 -> h ascii
	;
	Mientras:
		mov al,ruta[si] ;mov destino, fuente
		inc si ; si++
		cmp al,00h ; ascii de signo nulo
		je FinMientras
		jmp Mientras

	FinMientras:
		;ruta[4]
		dec si
		mov ruta[si], 2Eh ; .
		inc si
		mov ruta[si], 78h ; x
  		inc si
  		mov ruta[si], 6Dh ; m
  		inc si
  		mov ruta[si], 6Ch ; l
  		inc si
  		mov ruta[si], 00h ;caracter nulo al final
  

endm

ContarUnidades macro numero
LOCAL Mientras, FinMientras

xor si,si ;registro de 16 bits
xor bx,bx

	Mientras:
	mov al,numero[si]
	cmp al,24h ;cuando encontremos $ dejamos el contador
	je FinMientras
	inc si
	jmp Mientras

	FinMientras:
	;si el contador vale 2 el numero es > 9 si el contador vale 1 el numero <10
	mov bx,si ;bl nos indica si son unidades o si son decenas
	; como sabemos que el numero  <2 sabemos que el resultado de guarda en bl
endm

TextoAEntero macro texto ;en el registo al se va a guardar el numero convertido
LOCAL Unidades, Decenas, Final
xor al,al
ContarUnidades texto
;bl me indica si el numero tiene unidades o tiene decenas

cmp bl,1
je Unidades
cmp bl,2
je Decenas
jmp Final

	Unidades:
		;texto[0] -> numero de unidades en ascii
		mov al,texto[0]
		sub al, 48 ; al = al - 48
		jmp Final


	Decenas:
		
		;texto[0]-> numero de decenas en ascii
		;texto[1]-> numero de unidades en ascii
		mov al,texto[0]
		sub al,48 ; ya tengo las decenas en su valor decimal 45 -> 4
		mov bl,10
		mul bl ; al = al * bl
		;al = 40

		xor bl,bl
		mov bl, texto[1]
		sub bl, 48 ; bl = 5

		add al,bl ;  al = 40 +5

		jmp Final

	Final:

endm

EnteroATexto macro numero, texto
LOCAL Unidades, Decenas, Final
xor al,al

mov al,numero
cmp al,9 ;numero > 9 tiene decenas
ja Decenas
jmp Unidades

	Unidades:
		add al,48 ;2+48 = 50
		mov texto[0],al
		jmp Final
	


	Decenas:

		xor bl,bl
		;al tiene el numero completo 45
		mov bl,10

		div bl ; 45/10 al = 4 y ah = 5

		add al,48
		mov texto[0],al
		
		add ah,48
		mov texto[1],ah

		jmp Final



	Final:

endm


AgregarId macro arreglo, global
LOCAL Mientras, FinMientras, FinMientras2

	xor si,si
	xor di,di
	Mientras:
		mov al,global[si] ;mov destino, fuente
		inc si ; si++
		cmp al, 36 ; ascii de signo nulo
		je FinMientras
		jmp Mientras

	FinMientras:
		mov di,1
		mov al, arreglo[di] ;mov destino, fuente
		dec si
		mov global[si], al
		inc di
		inc si
		cmp al, 36 ; ascii de signo nulo
		je FinMientras2
		jmp FinMientras

	FinMientras2:
		mov al, 59
		mov global[si], al			

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
		print salto
		print salto			;print("/n")
		mov aux,32
		inc si              ; si++  			
		jmp Inicio

	FinMientras:

pop di
pop si
endm

AnalizarComando macro com ; A1:B2 arreglo1 = [A][1]; arreglo2 = [B][2]
LOCAL analizar, llenar, condicional, blancas, negras, mover, salida, error


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

	condicional:
		xor al,al
		mov al, com[5]
		mov auxiliar,al
		cmp auxiliar,98
		je blancas

		cmp auxiliar,110
		je negras

		jmp error

		blancas:
			xor ax,ax
			mov al,tablero[si]
			cmp al,98
			jne error
			mov al,tablero[di]
			cmp al,98
			je error
			jmp mover
			jmp error

		negras:
			xor ax,ax
			mov al,tablero[si]
			cmp al,110
			jne error
			mov al,tablero[di]
			cmp al,110
			je error
			cmp al,98
			je error
			jmp mover
			jmp error

		mover:
			xor ax,ax
			mov al,tablero[si]
			mov tablero[si],95
			mov tablero[di],al
			jmp salida

		error:
			mov comando[5],101
			print errorj
			getChar

		salida:

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

ImprimirLetras macro array
LOCAL aux1, aux2, aux3
push si
xor si,si
mov si,0

	aux1:
		cmp si,9
		je aux2
		mov al,array[si]
		mov aux,al            ; print (array[si])
		print aux
		mov aux,32
		print aux
		print aux
		print aux 			  ;3 espacios
		inc si
		jmp aux1

	aux2:
		xor si,si             ;di=0
		print salto           ;print espacio
		print salto           ;print espacio
		mov aux,32            ;else y print espacio
		jmp aux3

	aux3:

pop di
endm

;-----------------Macros que voy a usar para la práctica 4-------------------------------
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

ContarPalabras macro textobuf
    LOCAL ciclo1, imprimirTrip, imprimirdiptongo, imprimirHiato, letra, siguiente, conclusion, comparacionspace ,salir


    mov fila, dh
    mov columna, dl
    mov si, 0
    mov di, 0
    mov Cont_Hia, 0
    mov Cont_Dip, 0
    mov Cont_Trip, 0
    mov Cont_Palabra , 0

    ciclo1:
        ComprobarSiEs textobuf[si], textobuf[si+1], textobuf[si+2]

        cmp al,0  
        je letra

        cmp al, 3
        je imprimirTrip

        cmp al,1
        je imprimirdiptongo

        cmp al,2
        je imprimirHiato

        
    imprimirTrip:
        inc si
        inc si

        xor di, di 
        mov di, Cont_Trip
        inc di 
        mov Cont_Trip, di 

        jmp siguiente

    
    imprimirdiptongo:
        inc si
        
        xor di, di 
        mov di, Cont_Dip
        inc di 
        mov Cont_Dip, di 

        jmp siguiente

    imprimirHiato:
        inc si

        xor di, di 
        mov di, Cont_Hia
        inc di 
        mov Cont_Hia, di 

        jmp siguiente
    

    letra:       
        jmp siguiente


    siguiente:        
        inc si
        cmp textobuf[si], 32d
        je comparacionspace
        cmp textobuf[si], 36d
        jne ciclo1
        
        jmp conclusion

    comparacionspace:
        xor di, di 
        mov di, Cont_palabra
        inc di 
        mov Cont_palabra, di 

        cmp textobuf[si], 36d
        jne ciclo1

        jmp conclusion

    conclusion:
        jmp salir

    salir:    

endm 