include macros.asm
.model small

;----------------SEGMENTO DE PILA---------------------

.stack

;----------------SEGMENTO DE DATO---------------------
.data
encab db 0ah,0dh, '---------------------------------------------',0ah,0dh,'Universidad de San Carlos de Guatemala', 0ah,0dh,'Facultad de Ingenieria',0ah,0dh,'Ciencias y Sistemas',0ah,0dh,'Arquitectura de Computadores y Ensambladores 1',0ah,0dh,'Nombre: Elder Anibal Pum Rojas',0ah,0dh,'Carnet: 201700761',0ah,0dh,'Seccion: B',0ah,0dh,'--------------------------------------------',0ah,0dh,'$'

menuprincipal db 0ah,0dh, '----------------------MENU--------------------',0ah,0dh,'1).- -abrir_"ruta" ',0ah,0dh,'2).- -contar_[diptongo|triptongo|hiato|palabra]',0ah,0dh,'3).- -prop_[diptongo|triptongo|hiato]',0ah,0dh,'4).- -colorear',0ah,0dh,'5).- -reporte',0ah,0dh,'6).- -diptongo_[palabra]',0ah,0dh,'7).- -hiato_[palabra]',0ah,0dh,'8).- -triptongo_[palabra]',0ah,0dh,'9).- -x[Salir]' ,0ah,0dh,'$'

saltoLinea db 0Ah,0Dh,"$"
saludo db 0Ah,0Dh, "Analizando texto..........","$"
fin db 0Ah,0Dh, "Finalizando el programa.......", "$"

seleccion db 0ah,0dh, 'Ingresa un comando por favor: ','$'

bufferEntrada db 1000 dup('$'),'$'
handlerEntrada dw ?
bufferInformacion db 1000 dup('$')

bufferEntradaReporte db 1000 dup('$'),'$'
handlerEscrito dw ?
bufferInformacionReporte db 1000 dup('$')

bufferCantidad db 30 dup('$'), '$'

tipo db 10 dup('$'),'$'
gPalabra db 25 dup('$'),'$'
porcentaje db '%','$'

entradaC db 50 dup('$'),'$'

entradaC2 db '-abrir_','$'
entradaC3 db '-contar_','$'
entradaC8 db '-prop_','$'
tipo1 db '-contar_diptongo','$'
tipo2 db '-contar_triptongo','$'
tipo3 db '-contar_hiato','$'
tipo4 db '-contar_palabra','$'
tipo5 db '-prop_diptongo','$'
tipo6 db '-prop_triptongo','$'
tipo7 db '-prop_hiato','$'
entradaC4 db '-colorear','$'
entradaC5 db '-diptongo_','$'
entradaC6 db '-hiato_','$'
entradaC7 db '-triptongo_','$'
entradaS db '-x','$'
repo db '-reporte','$'

;Mensajes
msj1 db 0ah,0dh, 'Comando no permitido','$'
msj2 db 0ah,0dh, 'Abriendo el archivo','$'
msj3 db 0ah,0dh, 'Cambio de texto','$'
msj4 db 0ah,0dh, 'Error, no se puede abrir el archivo','$'
msj5 db 0ah,0dh, 'No se ha reconocido el tipo para contar','$'
msj6 db 0ah,0dh, 'Cantidad de diptongos: ','$'
msj7 db 0ah,0dh, 'Cantidad de hiatos: ','$'
msj8 db 0ah,0dh, 'Cantidad de triptongos: ','$'
msj9 db 0ah,0dh, 'Cantidad de palabras: ','$'
msj10 db 0ah,0dh, 'Si es un diptongo','$'
msj11 db 0ah,0dh, 'Si es un hiato','$'
msj12 db 0ah,0dh, 'Si es un triptongo','$'
msj13 db 0ah,0dh, 'No es un diptongo','$'
msj14 db 0ah,0dh, 'No es un hiato','$'
msj15 db 0ah,0dh, 'No es un triptongo','$'
msj16 db 0ah,0dh, 'No se reconocio el tipo para proporcion','$'
msj17 db 0ah,0dh, 'Porcentaje de diptongos: ','$'
msj18 db 0ah,0dh, 'Porcentaje de triptongos: ','$'
msj19 db 0ah,0dh, 'Porcentaje de hiatos: ','$'
msj20 db 0ah,0dh, 'Ingrese el nombre del reporte con extension txt al final: ','$'
msj21 db 0ah,0dh, 'No se ha podido crear el reporte, intente nuevamente','$'
msj22 db 0ah,0dh, 'Reporte creado con exito, revise la carpeta BIN por favor','$'

contadorD dw 0
contadorH dw 0
contadorT dw 0
contadorP dw 0
porcentajeD dw 0
porcentajeH dw 0
porcentajeT dw 0

cant db 25 dup ('$'), '$'
prop db 25 dup ('$'), '$'

fila db 0
columna db 0

;mensajes para el reporte
encabRepo db 0ah,0dh, '---------------------REPORTE---------------------', '$'
lineasRepo db 0ah,0dh, '-------------------------------------------------', '$'
resumenRepo db 0ah,0dh, 'Resumen de Datos obtenidos mediante el archivo leido', '$'
numeroDRepo db 0ah,0dh, 'Numero de Diptongos: ', '$'
numeroHRepo db 0ah,0dh, 'Numero de Triptongos: ', '$'
numeroTRepo db 0ah,0dh, 'Numero de Hiatos: ', '$'
numeroPRepo db 0ah,0dh, 'Numero de Palabras: ', '$'
proporcionDRepo db 0ah,0dh, 'Proporcion de Diptongos: ', '$'
proporcionHRepo db 0ah,0dh, 'Proporcion de Hiatos: ', '$'
proporcionTRepo db 0ah,0dh, 'Proporcion de Triptongos: ', '$'

;----------------SEGMENTO DE CODIGO---------------------
.code
main proc

; se inicializa modo video con una resolucion de 80x25

Inicio:
	print encab
	imprimir saltoLinea
	getChar
	cmp al, 120
	je salir

Menu:
	limpiar entradaC, SIZEOF entradaC, 24h
	limpiar gPalabra, SIZEOF gPalabra, 24h
	print menuprincipal
	imprimir saltoLinea
	print seleccion

	obtenerTexto entradaC
	jmp seleccion1

seleccion1:
	;-abrir_
	mov cx,7
	mov AX,DS 
	mov ES,AX 
	lea si,entradaC
	lea di,entradaC2
	repe cmpsb
	je abrirArchivo

	;-prop_
	mov cx,6
	mov AX,DS
	mov ES,AX
	lea si,entradaC
	lea di,entradaC8
	repe cmpsb
	je Proporcion

	;-contar_
	mov cx,8
	mov AX,DS
	mov ES,AX
	lea si,entradaC
	lea di,entradaC3
	repe cmpsb
	je Intermedio

	;-colorear
	mov cx,9
	mov AX,DS
	mov ES,AX
	lea si,entradaC
	lea di,entradaC4
	repe cmpsb
	je Ediptongo 

	;-reporte
	mov cx,8
	mov AX,DS
	mov ES,AX
	lea si,entradaC
	lea di,repo
	repe cmpsb
	je crearReporte

	;-diptongo_
	mov cx,10
	mov AX,DS
	mov ES,AX
	lea si,entradaC
	lea di,entradaC5
	repe cmpsb
	je aDiptongo

	;-hiato_
	mov cx,7
	mov AX,DS
	mov ES,AX
	lea si,entradaC
	lea di,entradaC6
	repe cmpsb
	je aHiato

	;-triptongo_
	mov cx,11
	mov AX,DS
	mov ES,AX
	lea si,entradaC
	lea di,entradaC7
	repe cmpsb
	je aTriptongo

	;-x
	mov cx,2
	mov AX,DS
	mov ES,AX
	lea si,entradaC
	lea di, entradaS
	repe cmpsb
	jne Dif
	je salir

abrirArchivo:
	print msj2
	print saltoLinea
	pasarRuta bufferEntrada,entradaC,7

	abrir bufferEntrada,handlerEntrada
	limpiar bufferInformacion,SIZEOF bufferInformacion,24h
	leer handlerEntrada,bufferInformacion,SIZEOF bufferInformacion
	print bufferInformacion
	print saltoLinea
	getChar

	jmp Menu

Contar:
	;-contar_diptongo
	mov cx,16
	mov AX,DS
	mov ES,AX
	lea si,tipo1
	lea di,entradaC
	repe cmpsb
	je edip

	;-contar_triptongo
	mov cx,17
	mov AX,DS
	mov ES,AX
	lea si,tipo2
	lea di,entradaC
	repe cmpsb
	je etrip

	;-contar_hiato
	mov cx,13
	mov AX,DS
	mov ES,AX
	lea si,tipo3
	lea di,entradaC
	repe cmpsb
	je ehiato

	;-contar_palabra
	mov cx,15
	mov AX,DS
	mov ES,AX
	lea si,tipo4
	lea di,entradaC
	repe cmpsb
	je epalabra

	jmp Error2

	edip:
		IntToString contadorD, cant
		print msj6
		print cant
		print saltoLinea
		getChar
		jmp Menu

	ehiato:
		IntToString contadorH, cant
		print msj7
		print cant
		print saltoLinea
		getChar
		jmp Menu

	etrip:
		IntToString contadorT, cant
		print msj8
		print cant
		print saltoLinea
		getChar
		jmp Menu

	epalabra:
		IntToString contadorP, cant
		print msj9
		print cant
		print saltoLinea
		getChar
		jmp Menu

Proporcion:
	;=prop_diptongo
	mov cx,14
	mov AX,DS
	mov ES,AX
	lea si,tipo5
	lea di,entradaC
	repe cmpsb
	je p_dip

	;-prop_triptongo
	mov cx,15
	mov AX,DS
	mov ES,AX
	lea si,tipo6
	lea di,entradaC
	repe cmpsb
	je p_trip 

	;-prop_hiato
	mov cx,11
	mov AX,DS
	mov ES,AX
	lea si,tipo7
	lea di,entradaC
	repe cmpsb
	je p_hiato

	jmp Error3

	p_dip:
		mov dx,0
		mov ax,0

		mov bx,100
		mov ax, contadorD
		mul bx ;ax*bx y guarda en ax
		mov bx, contadorP
		div bx ;ax/bx y guarda en ax, ademas el residuo para en dx

		mov porcentajeD, ax
		IntToString porcentajeD,prop
		print msj17
		print prop
		print porcentaje
		getChar
		jmp Menu

	p_trip:
		mov dx,0
		mov ax,0

		mov bx,100
		mov ax, contadorT
		mul bx
		mov bx,contadorP
		div bx

		mov porcentajeT, ax
		IntToString porcentajeT,prop
		print msj18
		print prop
		print porcentaje
		getChar
		jmp Menu

	p_hiato:
		mov dx,0
		mov ax,0

		mov bx,100
		mov ax,contadorT
		mul bx
		mov bx,contadorP
		div bx

		mov porcentajeH,ax
		IntToString porcentajeH,prop
		print msj19
		print prop
		print porcentaje
		getChar
		jmp Menu

aDiptongo:
	pasarRuta gPalabra, entradaC, 10
	print saltoLinea
	print gPalabra
	mov si,0
	mov di,0
	ciclo1a:
		esDiptongo gPalabra[si], gPalabra[si+1], gPalabra[si+2]

		cmp al,1h
		je diptongo1a

		inc si
		cmp gPalabra[si], 36d
		jne ciclo1a
		je diptongo2a

	diptongo1a:
		print msj10
		print saltoLinea
		getChar
		jmp Menu

	diptongo2a:
		print msj13
		print saltoLinea
		getChar
		jmp Menu

aHiato:
	pasarRuta gPalabra, entradaC, 7
	print saltoLinea
	print gPalabra
	mov si,0
	mov di,0
	ciclo2a:
		esDiptongo gPalabra[si], gPalabra[si+1], gPalabra[si+2]

		cmp al, 2h 
		je hiato1a

		inc si
		cmp gPalabra[si], 36d
		jne ciclo2a
		je hiato2a

	hiato1a:
		print msj11
		print saltoLinea
		getChar
		jmp Menu

	hiato2a:
		print msj14
		print saltoLinea
		getChar
		jmp Menu


aTriptongo:
	pasarRuta gPalabra, entradaC, 11
	print saltoLinea
	print gPalabra
	mov si,0
	mov di,0
	ciclo3a:
		esDiptongo gPalabra[si], gPalabra[si+1], gPalabra[si+2]

		cmp al,3h 
		je tripto1a

		inc si
		cmp gPalabra[si], 36d
		jne ciclo3a
		je tripto2a

	tripto1a:
		print msj12
		print saltoLinea
		getChar
		jmp Menu

	tripto2a:
		print msj15
		print saltoLinea
		getChar
		jmp Menu

crearReporte:
	print saltoLinea
	print msj20
	print saltoLinea
	limpiar bufferEntradaReporte, SIZEOF bufferEntradaReporte,24h
	obtenerRuta bufferEntradaReporte
	crear bufferEntradaReporte,handlerEscrito

	jmp escribirReporte

escribirReporte:
	escribir handlerEscrito, encabRepo, SIZEOF encabRepo
	escribir handlerEscrito, saltoLinea, SIZEOF saltoLinea
	escribir handlerEscrito, lineasRepo, SIZEOF lineasRepo
	escribir handlerEscrito, saltoLinea, SIZEOF saltoLinea
	escribir handlerEscrito, resumenRepo, SIZEOF resumenRepo

	escribir handlerEscrito, numeroDRepo, SIZEOF numeroDRepo
	limpiar bufferCantidad, SIZEOF bufferCantidad, 24h
	IntToString contadorD, bufferCantidad
	escribir handlerEscrito, bufferCantidad, SIZEOF bufferCantidad

	escribir handlerEscrito, numeroHRepo, SIZEOF numeroHRepo
	limpiar bufferCantidad, SIZEOF bufferCantidad, 24h
	IntToString contadorH, bufferCantidad
	escribir handlerEscrito, bufferCantidad, SIZEOF bufferCantidad
	
	escribir handlerEscrito, numeroTRepo, SIZEOF numeroTRepo
	limpiar bufferCantidad, SIZEOF bufferCantidad, 24h
	IntToString contadorT, bufferCantidad
	escribir handlerEscrito, bufferCantidad, SIZEOF bufferCantidad

	escribir handlerEscrito, numeroPRepo, SIZEOF numeroPRepo
	limpiar bufferCantidad, SIZEOF bufferCantidad, 24h
	IntToString contadorP, bufferCantidad
	escribir handlerEscrito, bufferCantidad, SIZEOF bufferCantidad

	escribir handlerEscrito, proporcionDRepo, SIZEOF proporcionDRepo
	limpiar bufferCantidad, SIZEOF bufferCantidad, 24h
	IntToString porcentajeD, bufferCantidad
	escribir handlerEscrito, bufferCantidad, SIZEOF bufferCantidad

	escribir handlerEscrito, proporcionHRepo, SIZEOF proporcionHRepo
	limpiar bufferCantidad, SIZEOF bufferCantidad, 24h
	IntToString porcentajeH, bufferCantidad
	escribir handlerEscrito, bufferCantidad, SIZEOF bufferCantidad

	escribir handlerEscrito, proporcionTRepo, SIZEOF proporcionTRepo
	limpiar bufferCantidad, SIZEOF bufferCantidad, 24h
	IntToString porcentajeT, bufferCantidad
	escribir handlerEscrito, bufferCantidad, SIZEOF bufferCantidad

	escribir handlerEscrito, saltoLinea, SIZEOF saltoLinea
	escribir handlerEscrito, lineasRepo, SIZEOF lineasRepo

	cerrar handlerEscrito
	print saltoLinea
	print msj22
	print saltoLinea
	jmp Menu

Error1:
	print msj4
	getChar
	jmp Menu

Error2:
	print msj5
	getChar
	jmp Menu

Error3:
	print msj16
	getChar
	jmp Menu

Error4:
	print msj21
	getChar
	jmp Menu

Ediptongo:
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
	je dip

	cmp al,2h
	je hiat

	cmp al,3h
	je trip

	dip:
		imprimirVideo bufferInformacion[si], 0010b ;imprimos verde
		inc columna ;aumenta la posicion del cursor
		inc si

		posicionarCursor fila, columna

		
		imprimirVideo bufferInformacion[si], 0010b ;imprimos verde
		jmp siguiente

	hiat:
		imprimirVideo bufferInformacion[si], 0100b ;imprimos rojo
		inc columna ;aumenta la posicion del cursor
		inc si

		posicionarCursor fila, columna
		
		imprimirVideo bufferInformacion[si], 0100b ;imprimos rojo
		jmp siguiente

	trip:
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
	mov contadorD,0
	mov contadorH,0
	mov contadorT,0
	mov contadorP,0
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
		mov di,contadorD
		inc di
		mov contadorD,di
		inc si
		jmp siguienteD

	Hiati1:
		mov di, contadorH
		inc di
		mov contadorH, di
		inc si
		jmp siguienteD

	Tripti1:
		mov di, contadorT
		inc di
		mov contadorT, di
		inc si
		inc si
		jmp siguienteD

	letraD:
		cmp bufferInformacion[si], 32
		jne siguienteD

		PalabraD:
			mov di, contadorP
			inc di
			mov contadorP, di
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
	
salir:
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h

main endp
end main	
