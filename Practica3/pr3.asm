include macros.asm ;archivo con los macros a utilizar

.model small

;----------------SEGMENTO DE PILA---------------------

.stack

;----------------SEGMENTO DE DATO---------------------

.data
enc db 0ah, 0dh, 'Universidad de San Carlos de Guatemala',0ah, 0dh,'Arquitectura de Ensambladores y Computadores 1' , 0ah, 0dh, 'Elder Anibal Pum Rojas 201700761' , 0ah, 0dh, 'Practica 3',0ah, 0dh, 'Ingrese x si desea cerrar el programa o enter para continuar' , '$'
jp1 db 0ah, 0dh, 'Jugador 1 ingrese su nombre:', '$'
jp2 db 0ah, 0dh, 'Jugador 2 ingrese su nombre:', '$'
msjTurno db 0ah, 0dh, 'Turno del jugador:', '$'
finJuego db 0ah, 0dh, 'Ingrese x para finalizar el juego o enter para continuar', '$'
juegaB db 0ah, 0dh, 'Juega blancas', '$'
juegaN db 0ah, 0dh, 'Juega negras', '$'
punteo db 0ah, 0dh, 'Punteo actual:', '$'
salto db 0ah,0dh, '$' ,'$'
nombre1 db 10 dup('$'), '$'
nombre2 db 10 dup('$'), '$'
textoComando db 0ah, 0dh, 'Ingrese su comando:', '$'

posicionInicial db 2 dup('$'), '$'
posicionFinal db 2 dup('$'), '$'

valorInicial db 0, '$' 
valorFinal db 0, '$' 

aux db 0, '$' 
resultado db 0, '$'
columna db 0, '$'
fila db 0, '$'
punteoBlancas db 5, '$'
punteoNegras db 5, '$'


tablero db 65 dup('$'), '$'

numero db 2 dup('$'), '$'

comando db 6 dup('$'), '$' ; A1:B2

numeros db 0, '$'
letras db 8 dup('N'), '$'
auxiliar db 0, '$'
errorj db 0ah, 0dh, 'No se puede realizar este movimiento', '$'
bufferEntrada db 100 dup('$')
handlerEntrada dw ?
bufferInfo db 300 dup('$')
arrayTexto db 78 dup(' ')
nombreArchivo db 0ah, 0dh, 'Escribir nombre del archivo:', '$'
nombreJugador db 0ah, 0dh, 'Nombre del jugador:'
punteoJugador db 0ah, 0dh, 'Punteo:'
tableroTotal db 0ah, 0dh, 'Tablero:'


;----------------REPORTES-----------------------------
html1 db '<html>',0ah,'<head>',0ah,'<title> 201700761 </title>',0ah,'</head>',0ah,
'<body style = ',22h,'background: black',22h,'>',0ah,'<center>',0ah,
'<h1 style = ',22h,'color: white; font-family: Corbel;',22h,'> JUEGO ACTUAL </h1>',0ah,
'<h2 style = ',22h,'color: white; font-family: Corbel;',22h,'> HORA ACTUAL: ', '$'


pinicio db 0ah, 0dh, '<p>', '$'
pfin db 0ah, 0dh, '</p>', '$'
htmlfinal db 0ah, 0dh, '</html>', '$'

;----------------SEGMENTO DE CODIGO---------------------

.code
main proc
	
	Menu:

		print enc
		print salto
		getChar
		cmp al,120
		je Salir
 
		mov tablero[0], 0 ; tablero[0] = 0
		mov tablero[1], 110
		mov tablero[2], 95
		mov tablero[3], 110
		mov tablero[4], 95
		mov tablero[5], 110
		mov tablero[6], 95
		mov tablero[7], 110
		mov tablero[8], 95
		mov tablero[9], 95
		mov tablero[10], 110
		mov tablero[11], 95
		mov tablero[12], 110
		mov tablero[13], 95
		mov tablero[14], 110
		mov tablero[15], 95
		mov tablero[16], 110
		mov tablero[17], 110
		mov tablero[18], 95
		mov tablero[19], 110
		mov tablero[20], 95
		mov tablero[21], 110
		mov tablero[22], 95
		mov tablero[23], 110
		mov tablero[24], 95

		mov tablero[25], 95
		mov tablero[26], 95
		mov tablero[27], 95
		mov tablero[28], 95
		mov tablero[29], 95
		mov tablero[30], 95
		mov tablero[31], 95
		mov tablero[32], 95
		mov tablero[33], 95
		mov tablero[34], 95
		mov tablero[35], 95
		mov tablero[36], 95
		mov tablero[37], 95
		mov tablero[38], 95
		mov tablero[39], 95
		mov tablero[40], 95

		mov tablero[41], 95
		mov tablero[42], 98
		mov tablero[43], 95
		mov tablero[44], 98
		mov tablero[45], 95
		mov tablero[46], 98
		mov tablero[47], 95
		mov tablero[48], 98
		mov tablero[49], 98
		mov tablero[50], 95
		mov tablero[51], 98
		mov tablero[52], 95
		mov tablero[53], 98
		mov tablero[54], 95
		mov tablero[55], 98
		mov tablero[56], 95
		mov tablero[57], 95
		mov tablero[58], 98
		mov tablero[59], 95
		mov tablero[60], 98
		mov tablero[61], 95
		mov tablero[62], 98
		mov tablero[63], 95
		mov tablero[64], 98
		mov tablero[65], 95

		mov letras[0], 32
		mov letras[1], 65
		mov letras[2], 66
		mov letras[3], 67
		mov letras[4], 68
		mov letras[5], 69
		mov letras[6], 70
		mov letras[7], 71
		mov letras[8], 72

		print jp1
		obtenerTexto nombre1
		print salto

		print jp2 
		obtenerTexto nombre2
		print salto

	Juego:

		Turno1:
			print msjTurno
			print nombre1
			print juegaN
			print punteo
			print salto
			print salto
			ImprimirLetras letras
			ImprimirTablero tablero
			print textoComando
			obtenerTexto comando
			mov comando[5], 110 ; Movimiento de ficha negra
			print salto

			AnalizarComando comando

			mov al, comando[5]
			cmp al, 101
			je Turno1
			print finJuego
			getChar ; lee un caracter del teclado y lo guarda en al
			cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
			je crearArchivo

			jmp Turno2

		Turno2:
			print msjTurno
			print nombre2
			print juegaB
			print punteo
			print salto
			print salto
			ImprimirLetras letras
			ImprimirTablero tablero
			print textoComando
			obtenerTexto comando
			mov comando[5], 98 ; Movimiento de ficha blanca

			AnalizarComando comando

			mov al, comando[5]
			cmp al, 101
			je Turno2

			print finJuego
			getChar ; lee un caracter del teclado y lo guarda en al
			cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
			je crearArchivo

			jmp Turno1

		jmp Menu

	crearArchivo:
		print salto
		print nombreArchivo
		print salto
		limpiar bufferEntrada,SIZEOF bufferEntrada,24h
		obtenerRuta bufferEntrada
		crear bufferEntrada,handlerEntrada

		jmp escribirArchivo

	escribirArchivo:
		escribir handlerEntrada, html1, SIZEOF html1
		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, nombreJugador, SIZEOF nombreJugador
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, nombre1, SIZEOF nombre1
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, nombreJugador, SIZEOF nombreJugador
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, nombre2, SIZEOF nombre2
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, punteoJugador, SIZEOF punteoJugador
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, punteoBlancas, SIZEOF punteoBlancas
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, punteoJugador, SIZEOF punteoJugador
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, punteoNegras, SIZEOF punteoNegras
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, tableroTotal, SIZEOF TableroTotal
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, pinicio, SIZEOF pinicio
		escribir handlerEntrada, tablero, SIZEOF tablero
		escribir handlerEntrada, pfin, SIZEOF pfin

		escribir handlerEntrada, htmlfinal, SIZEOF htmlfinal
		cerrar handlerEntrada
		print salto
		jmp Salir

	Salir:
		close

main endp
end main	