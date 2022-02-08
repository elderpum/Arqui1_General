include macros.asm
.model small

;----------------SEGMENTO DE PILA---------------------
.stack

;----------------SEGMENTO DE DATO---------------------

.data
enc db 0ah, 0dh, '-------------------- Universidad de San Carlos de Guatemala --------------------',0ah, 0dh,'------------------- Arquitectura de Ensambladores y Computadores 1 -------------' , 0ah, 0dh, '---------------------- Diego Andres Obin Rosales 201903865 ---------------------' , 0ah, 0dh, '---------------------------------- Practica 3 ----------------------------------',0ah, 0dh, 'Inrese x si desea cerrar el programa' , '$'

encMenu db 0ah, 0dh, '---------------------------------- Menu --------------------------------------', '$'
menuP db 0ah, 0dh, '1. -abrir_"ruta" ', 0ah, 0dh, '2. -contar_<diptongo | triptongo | hiato | palabra>', 0ah, 0dh, '3. -prop_<diptongo | triptongo | hiato>', 0ah, 0dh, '4. -colorear', 0ah, 0dh, '5. -reporte', 0ah, 0dh, '6. -diptongo_<palabra> ', 0ah, 0dh, '7. -hiato_<palabra>', 0ah, 0dh, '8. -triptongo_<palabra>',0ah, 0dh, '9. -x', '$'
seleccion db 0ah, 0dh, 'Por favor ingrese un comando: '
saltoLinea db 0Ah,0Dh,"$"
saludo db 0Ah,0Dh, "Analizando texto..........","$"
fin db 0Ah,0Dh, "Finalizando el programa.......", "$"

bufferEntrada db 1000 dup('$'),'$' ; ruta del archivo "c:/Diego/archivo.txt"
handlerEntrada dw ?				  ; Valor se asigno solo
bufferInformacion db 1000 dup('$') ; contiene la informacion de lo que esta en el archivo


tipo db 10 dup('$'),'$'
Gpalabra db 25 dup('$'),'$'
Porciento db '%','$'

EntradaC db 50 dup('$'), '$'

EntradaC2 db '-abrir_','$'
EntradaC3 db '-contar_','$'
EntradaC8 db '-prop_','$'
tipo1 db '-contar_diptongo','$'
tipo2 db '-contar_triptongo','$'
tipo3 db '-contar_hiato','$'
tipo4 db '-contar_palabra','$'

tipo5 db '-prop_diptongo','$'
tipo6 db '-prop_triptongo','$'
tipo7 db '-prop_hiato','$'


EntradaC4 db '-colorear','$'
EntradaC5 db '-diptongo_','$'
EntradaC6 db '-hiato_','$'
EntradaC7 db '-triptongo_','$'
EntradaS db '-x','$'

;; ================== ARRAY DE ANALISIS ================= ;;
ComandoSistema db 20 dup('$'), '$'

;; ================= MENSAJES EN CONSOLA ======================= ;;
msj1 db 0ah, 0dh, 'Comando no permitido','$'
msj2 db 0ah, 0dh, 'Abriendo el archivo...', '$'
msj3 db 0ah,0dh, 'Cambio de texto ', '$'
msj4 db 0ah,0dh, 'Error, no se puede abrir este archivo ', '$'
msj5 db 0ah,0dh, 'Estamos en contar', '$'
msj6 db 0ah, 0dh, 'Entra aqui','$'
msj7 db 0ah, 0dh, 'No se ha reconocido el tipo para Contar...', '$'
msj8 db 0ah, 0dh, 'Cantidad de Diptongos: ','$'
msj9 db 0ah, 0dh, 'Cantidad de Hiatos: ','$'
msj10 db 0ah, 0dh, 'Cantidad de Triptongos: ','$'
msj11 db 0ah, 0dh, 'Cantidad de Palabras: ','$'
msj12 db 0ah, 0dh, 'Si es un diptongo ','$'
msj13 db 0ah, 0dh, 'Si es un hiato ','$'
msj14 db 0ah, 0dh, 'Si es un triptongo ','$'
msj15 db 0ah, 0dh, 'No es un diptongo ','$'
msj16 db 0ah, 0dh, 'No es un hiato ','$'
msj17 db 0ah, 0dh, 'No es un triptongo ','$'
msj18 db 0ah, 0dh, 'No se ha reconocido el tipo para Proporcion','$'
msj19 db 0ah, 0dh, 'Porcentaje de Diptongos: ','$'
msj20 db 0ah, 0dh, 'Porcentaje de Triptongos: ','$'
msj21 db 0ah, 0dh, 'Porcentaje de Hiatos: ','$'


C_D dw 0
C_Hi dw 0
C_Tr dw 0
C_P dw 0
P_D dw 0
P_T dw 0
P_H dw 0

cant db 25 dup('$'),'$'

prop db 25 dup('$'),'$'

texto db "Hola esto es un peine y una aula","$"

fila db 0
columna db 0

;----------------SEGMENTO DE CODIGO---------------------


.code
main proc

; se inicializa modo video con una resolucion de 80x25


Inicio:
	print enc
	imprimir saltoLinea
	getChar
	cmp al, 120
	je cerrar

Menu:
	print encMenu
	print menuP
	imprimir saltoLinea
	print seleccion

	Obtenertexto EntradaC
	jmp llenado1


llenado1:
	; -abrir_
	mov cx,7   ;Determinamos la cantidad de datos a leer/comparar
	mov AX,DS  ;mueve el segmento datos a AX
	mov ES,AX  ;Mueve los datos al segmento extra
	lea si,EntradaC  ; -abrir_archi.txt
	lea di,EntradaC2 ;cargamos en di la cadena que contiene EntradaC2
	repe cmpsb  ;compara las dos cadenas
	je AbrirArchivo ;Si fueron iguales

	; -prop_
	mov cx, 6
	mov AX, DS
	mov ES,AX
	lea si, EntradaC
	lea di, EntradaC8
	repe cmpsb
	je Proporcion

	; -contar_
	mov cx,8   ;Determinamos la cantidad de datos a leer/comparar
	mov AX,DS  ;mueve el segmento datos a AX
	mov ES,AX  ;Mueve los datos al segmento extra
	lea si,EntradaC  ;cargamos en si la cadena que contiene EntradaC
	lea di,EntradaC3 ;cargamos en di la cadena que contiene EntradaC3
	repe cmpsb  ;compara las dos cadenas
	je Intermedio ;Si fueron iguales

	; -colorear
	mov cx, 9
	mov AX, DS
	mov ES,AX
	lea si, EntradaC
	lea di, EntradaC4
	repe cmpsb
	je Ediptongos

	; -diptongo_
	mov cx, 10
	mov AX, DS
	mov ES,AX
	lea si, EntradaC
	lea di, EntradaC5
	repe cmpsb
	je ADiptongo

	; -hiato_
	mov cx, 7
	mov AX, DS
	mov ES,AX
	lea si, EntradaC
	lea di, EntradaC6
	repe cmpsb
	je AHiato

	; -triptongo_
	mov cx, 11
	mov AX, DS
	mov ES,AX
	lea si, EntradaC
	lea di, EntradaC7
	repe cmpsb
	je ATriptongo

	; -x
	mov cx, 2
	mov AX, DS
	mov ES,AX
	lea si, EntradaC
	lea di, EntradaS
	repe cmpsb
	Jne Dif
	je cerrar



AbrirArchivo:
	print msj2
	print saltoLinea
	; -abrir_archi.txt
	PasarRuta bufferEntrada, EntradaC, 7;

	; print bufferEntrada

	Abrir bufferEntrada,handlerEntrada
	Limpiar bufferInformacion,SIZEOF bufferInformacion,24h
	Leer handlerEntrada, bufferInformacion, SIZEOF bufferInformacion
	print bufferInformacion
	print saltoLinea
	getChar

	jmp Menu



Contar:
	; -contar_diptongo
	mov cx, 16
	mov AX, DS
	mov ES,AX
	lea si, tipo1
	lea di, EntradaC
	repe cmpsb
	je eDipt

	; -contar_triptongo
	mov cx, 17
	mov AX, DS
	mov ES,AX
	lea si, tipo2
	lea di, EntradaC
	repe cmpsb
	je eTrip

	; -contar_hiato
	mov cx, 13
	mov AX, DS
	mov ES,AX
	lea si, tipo3
	lea di, EntradaC
	repe cmpsb
	je eHiat

	; -contar_palabra
	mov cx, 15
	mov AX, DS
	mov ES,AX
	lea si, tipo4
	lea di, EntradaC
	repe cmpsb
	je ePalabra
			
	jmp Error2

	eDipt:
		IntToString C_D, cant
		print msj8
		print cant
		print saltoLinea
		getChar
		jmp Menu
	
	eHiat:
		IntToString C_Hi, cant
		print msj9
		print cant
		print saltoLinea
		getChar
		jmp Menu
	
	eTrip:
		IntToString C_Tr, cant
		print msj10
		print cant
		print saltoLinea
		getChar
		jmp Menu

	ePalabra:
		IntToString C_P, cant
		print msj11
		print cant
		print saltoLinea
		getChar
		jmp Menu

Proporcion:
	; -prop_diptongo
	mov cx, 14
	mov AX, DS
	mov ES,AX
	lea si, tipo5
	lea di, EntradaC
	repe cmpsb
	je P_Diptongo

	; -prop_triptongo
	mov cx, 15
	mov AX, DS
	mov ES,AX
	lea si, tipo6
	lea di, EntradaC
	repe cmpsb
	je P_Triptongo

	; -prop_hiato
	mov cx, 11
	mov AX, DS
	mov ES,AX
	lea si, tipo7
	lea di, EntradaC
	repe cmpsb
	je P_Hiato

	jmp Error3

	P_Diptongo:
		mov dx, 0
		mov ax, 0
		
		mov bx, 100
		mov ax, C_D
		mul bx	; ax * bx -> ax
		mov bx, C_P ;
		div bx	; ax / bx -> ax && residuo -> dx
		
		mov P_D, ax
		IntToString P_D,prop
		print msj19
		print prop
		print Porciento
		getChar
		jmp Menu
	
	P_Triptongo:
		mov dx, 0
		mov ax, 0
		
		mov bx, 100
		mov ax, C_Tr
		mul bx
		mov bx, C_P
		div bx
		
		mov P_T, ax

		IntToString P_T,prop
		print msj20
		print prop
		print Porciento
		getChar
		jmp Menu

	P_Hiato:
		mov dx, 0
		mov ax, 0
		
		mov bx, 100
		mov ax, C_Tr
		mul bx
		mov bx, C_P
		div bx
		
		mov P_H, ax

		IntToString P_H,prop
		print msj21
		print prop
		print Porciento
		getChar
		jmp Menu

ADiptongo:
	PasarRuta Gpalabra, EntradaC, 10
	print saltoLinea
	print Gpalabra
	mov si, 0
	mov di, 0
	ciclo1a:
		esDiptongo Gpalabra[si], Gpalabra[si+1], Gpalabra[si+2]

		cmp al,1h
		je Dipti1a

		inc si
		cmp Gpalabra[si], 36d 
		jne ciclo1a
		je Dipti2a

	Dipti1a:
		print msj12
		print saltoLinea
		getChar
		jmp Menu

	Dipti2a:
		print msj15
		print saltoLinea
		getChar
		jmp Menu



AHiato:
	PasarRuta Gpalabra, EntradaC, 7
	print saltoLinea
	print Gpalabra
	mov si, 0
	mov di, 0
	ciclo2a:
		esDiptongo Gpalabra[si], Gpalabra[si+1], Gpalabra[si+2]

		cmp al,2h
		je Hiati1a

		inc si
		cmp Gpalabra[si], 36d 
		jne ciclo2a
		je Hiati2a

	Hiati1a:
		print msj13
		print saltoLinea
		getChar
		jmp Menu

	Hiati2a:
		print msj16
		print saltoLinea
		getChar
		jmp Menu


ATriptongo:
	PasarRuta Gpalabra, EntradaC, 11
	print saltoLinea
	print Gpalabra
	mov si, 0
	mov di, 0
	ciclo3a:
		esDiptongo Gpalabra[si], Gpalabra[si+1], Gpalabra[si+2]

		cmp al,3h
		je Tripti1a

		inc si
		cmp Gpalabra[si], 36d 
		jne ciclo3a
		je Tripti2a

	Tripti1a:
		print msj14
		print saltoLinea
		getChar
		jmp Menu

	Tripti2a:
		print msj17
		print saltoLinea
		getChar
		jmp Menu

CrearReporte:
	getChar
	jmp Menu


Error1:
	print msj4
	getChar
	jmp Menu

Error2:
	print msj7
	getChar
	jmp Menu
Error3:
	print msj18
	getChar
	jmp Menu
Ediptongos:
	mov ah, 0
	mov al, 03h
	int 10h

	imprimir saludo
	imprimir saltoLinea

	mov ah, 03h
	mov bh, 00h
	int 10h ;dh guarda el valor de la ultima posicion fila y dl guarda la ultima posicion de la columna

	mov fila, dh
	mov columna, dl
	mov si, 0
	mov di, 0

ciclo1:
	posicionarCursor fila, columna

	esDiptongo bufferInformacion[si], bufferInformacion[si+1], bufferInformacion[si+2]  ; Diego

	cmp al,0h 
	je letra

	cmp al,1h
	je Dipti

	cmp al,2h
	je Hiati

	cmp al,3h
	je Tripti

	Dipti:
		imprimirVideo bufferInformacion[si], 0010b ;imprimos verde
		inc columna ;aumenta la posicion del cursor
		inc si

		posicionarCursor fila, columna

		
		imprimirVideo bufferInformacion[si], 0010b ;imprimos verde
		jmp siguiente

	Hiati:
		imprimirVideo bufferInformacion[si], 0100b ;imprimos rojo
		inc columna ;aumenta la posicion del cursor
		inc si

		posicionarCursor fila, columna
		
		imprimirVideo bufferInformacion[si], 0100b ;imprimos rojo
		jmp siguiente

	Tripti:
		imprimirVideo bufferInformacion[si], 1110b ;imprimos amarillo
		inc columna ;aumenta la posicion del cursor
		inc si

		posicionarCursor fila, columna
		
		imprimirVideo bufferInformacion[si], 1110b ;imprimos amarillo
		inc columna ;aumenta la posicion del cursor
		inc si

		posicionarCursor fila, columna

		imprimirVideo bufferInformacion[si], 1110b ;imprimos amarillo
		jmp siguiente

	letra:
		imprimirVideo bufferInformacion[si], 1111b ;imprimos blanco
		jmp siguiente

	siguiente:

	inc columna ;aumenta la posicion del cursor
	inc si

	cmp columna, 80
	
	jl noSalto
		mov columna,0
		inc fila
	noSalto:
		cmp bufferInformacion[si], 36d 
		jne ciclo1
		je Menu
		
	inc fila
	mov ah,02h
	mov dh,fila
	mov dl,0
	mov bh,0
	int 10h

Intermedio:
	mov si,0
	mov di,0
	mov C_D,0
	mov C_Hi,0
	mov C_Tr,0
	mov C_P,0
	jmp ciclo2

ciclo2:
	esDiptongo bufferInformacion[si], bufferInformacion[si+1], bufferInformacion[si+2]

	cmp al,0h
	je letraD

	cmp al,1h
	je Dipti1

	cmp al,2h
	je Hiati1

	cmp al,3h
	je Tripti1

	Dipti1:
		mov di,C_D
		inc di
		mov C_D,di
		inc si
		jmp siguienteD

	Hiati1:
		mov di, C_Hi
		inc di
		mov C_Hi, di
		inc si
		jmp siguienteD

	Tripti1:
		mov di, C_Tr
		inc di
		mov C_Tr, di
		inc si
		inc si
		jmp siguienteD

	letraD:
		cmp bufferInformacion[si], 32
		jne siguienteD

		PalabraD:
			mov di, C_P
			inc di
			mov C_P, di
			jmp siguienteD
		

	siguienteD:
	inc si
	cmp bufferInformacion[si], 36d 
	mov di,0
	jne ciclo2
	
	je Contar


Dif:
	print EntradaC
	imprimir saltoLinea
	print msj1
	getChar
	jmp Menu

cerrar:
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h

main endp
end main