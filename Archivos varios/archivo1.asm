include macros.asm ;archivo con los macros a utilizar


.model small

;----------------SEGMENTO DE PILA---------------------

.stack

.data
;----------------SEGMENTO DE DATO---------------------
enc db 0ah, 0dh, '-------------------- Universidad de San Carlos de Guatemala --------------------',0ah, 0dh,'------------------- Arquitectura de Ensambladores y Computadores 1 -------------' , 0ah, 0dh, '---------------------- Diego Andres Obin Rosales 201903865 ---------------------' , 0ah, 0dh, '---------------------------------- Practica 3 ----------------------------------',0ah, 0dh, 'Inrese x si desea cerrar el programa' , '$'
jp1 db 0ah, 0dh, 'Jugador 1 ingrese su nombre:', '$'
jp2 db 0ah, 0dh, 'Jugador 2 ingrese su nombre:', '$'
msjTurno db 0ah, 0dh, 'Turno del jugador:', '$'
finJuego db 0ah, 0dh, 'Ingrese x para finalizar el juego', '$'
juegaB db 0ah, 0dh, 'Juega blancas', '$'
juegaN db 0ah, 0dh, 'Juega negras', '$'
punteo db 0ah, 0dh, 'Punteo actual:', '$'
salto db 0ah,0dh, '$' ,'$'
nombre1 db 10 dup('$'), '$'
nombre2 db 10 dup('$'), '$'
textoComando db 0ah, 0dh, 'Ingrese su comando:', '$'
textoMenuPrincipal db 0ah, 0dh, '			1) Nueva Partida',0ah,0dh,'			2) Cargar Partida','$'

textoArchivo db 0ah, 0dh, '1) Generar Reporte html', '$'
textoSalir db 0ah, 0dh, '2) Salir', '$'

posicionInicial db 2 dup('$'), '$'
posicionFinal db 2 dup('$'), '$'

valorInicial db 0, '$' 
valorFinal db 0, '$' 

aux db 0, '$' 
resultado db 0, '$'
columna db 0, '$'
fila db 0, '$'

punteoBlancas db 48, '$'
punteoNegras db 48, '$'



tablero db 65 dup('_'), '$'
numeros db 0, '$'
letras db 8 dup('N'), '$'

numero db 2 dup('$'), '$'

comando db 6 dup('$'), '$' ; A1:B2

auxiliar db 0, '$'


errorsaso db 0ah, 0dh, 'No se puede realizar este movimiento', '$'

entraBlancas db 0ah, 0dh, 'Entro en blancas', '$'

entroNegras db 0ah, 0dh, 'Entro en negras', '$'

bufferEntrada db 100 dup('$')
handlerEntrada dw ?
bufferInformacion db 300 dup('$')

entra db 0ah, 0dh, 'Entra en abrir escribir en archivo', '$'
datos db 0ah, 0dh, 'Ingrese el texto a ingresar ', '$'
nombre db 0ah, 0dh, 'Ingrese el nombre del archivo', '$'

ArregloaGuardar db 78 dup(' ')

prueba dw 0ah, 0dh, '$'

;----------------SEGMENTO DE CODIGO---------------------
.code
main proc

	Menu:
		print enc
		print salto
		getChar
		cmp al, 120
		je Salir

		mov tablero[0], 0 ; tablero[0] = 0
		mov tablero[1], 95
		mov tablero[2], 98
		mov tablero[3], 95
		mov tablero[4], 98
		mov tablero[5], 95
		mov tablero[6], 98
		mov tablero[7], 95
		mov tablero[8], 98

		mov tablero[9], 98
		mov tablero[10], 95
		mov tablero[11], 98
		mov tablero[12], 95
		mov tablero[13], 98
		mov tablero[14], 95
		mov tablero[15], 98
		mov tablero[16], 95

		mov tablero[17], 95
		mov tablero[18], 98
		mov tablero[19], 95
		mov tablero[20], 98
		mov tablero[21], 95
		mov tablero[22], 98
		mov tablero[23], 95
		mov tablero[24], 98

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

		mov tablero[41], 110
		mov tablero[42], 95
		mov tablero[43], 110
		mov tablero[44], 95
		mov tablero[45], 110
		mov tablero[46], 95
		mov tablero[47], 110
		mov tablero[48], 95

		mov tablero[49], 95
		mov tablero[50], 110
		mov tablero[51], 95
		mov tablero[52], 110
		mov tablero[53], 95
		mov tablero[54], 110
		mov tablero[55], 95
		mov tablero[56], 110

		mov tablero[57], 110
		mov tablero[58], 95
		mov tablero[59], 110
		mov tablero[60], 95
		mov tablero[61], 110
		mov tablero[62], 95
		mov tablero[63], 110
		mov tablero[64], 95

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
		LlenarJ nombre1,ArregloaGuardar,9h
		print salto
		print jp2 
		LlenarJ nombre2,ArregloaGuardar,1Fh
		print salto
		

	Juego:

		Turno1:
			print msjTurno
			print nombre1
			print juegaB
			print punteo
			print punteoBlancas
			print salto
			print salto
			ImprimirLetras letras
			ImprimirTablero tablero
			print textoComando
			obtenerTexto comando
			mov comando[5], 98  ;movimiento de ficha Blanca
			print salto

			AnalizarComando comando

			mov al, comando[5]
			cmp al, 101
			je Turno1

			print finJuego
			getChar ; lee un caracter del teclado y lo guarda en al
			cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
			je CrearArchivo

			jmp Turno2

		Turno2:
			print msjTurno
			print nombre2
			print juegaN
			print punteo
			print punteoNegras
			print salto
			print salto
			ImprimirLetras letras
			ImprimirTablero tablero
			print textoComando
			obtenerTexto comando
			mov comando[5], 110  ;movimiento de ficha Negra

			AnalizarComando comando

			mov al, comando[5]
			cmp al, 101
			je Turno2

			print finJuego

			getChar ; lee un caracter del teclado y lo guarda en al
			cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
			je CrearArchivo

			jmp Turno1

		jmp Menu

	
	
	AbrirArchivo:
		;obtener ruta
		print salto
		Limpiar bufferEntrada,SIZEOF bufferEntrada,24h
		ObtenerRuta bufferEntrada

		Abrir bufferEntrada,handlerEntrada
		Limpiar bufferInformacion,SIZEOF bufferInformacion,24h
		Leer handlerEntrada, bufferInformacion, SIZEOF bufferInformacion
		print bufferInformacion
		print salto
		getChar
		; jmp SubMenu
		
		;abrir archivo
		;leerlo
	
	CrearArchivo:
		print salto
		print nombre
		print salto
		Limpiar bufferEntrada,SIZEOF bufferEntrada,24h
		ObtenerRuta bufferEntrada
		Crear bufferEntrada,handlerEntrada

		jmp EscribirEnArchivo
	
	EscribirEnArchivo:
		print salto
		print entra
		print salto
		; Limpiar bufferInformacion, SIZEOF bufferInformacion, 24h
		print datos
		print salto
		; Obtenertexto bufferInformacion
		mov ArregloaGuardar[0],78  ;N
		mov ArregloaGuardar[1],111 ;o
		mov ArregloaGuardar[2],109 ;m
		mov ArregloaGuardar[3],98  ;b
		mov ArregloaGuardar[4],114 ;r
		mov ArregloaGuardar[5],101 ;e
		mov ArregloaGuardar[6],95  ;_
		mov ArregloaGuardar[7],49 ;1
		mov ArregloaGuardar[8],58 ; :

		mov ArregloaGuardar[21],10 ; \n
		mov ArregloaGuardar[22],78  ;N
		mov ArregloaGuardar[23],111 ;o
		mov ArregloaGuardar[24],109 ;m
		mov ArregloaGuardar[25],98  ;b
		mov ArregloaGuardar[26],114 ;r
		mov ArregloaGuardar[27],101 ;e
		mov ArregloaGuardar[28],95  ;_
		mov ArregloaGuardar[29],50 ;2
		mov ArregloaGuardar[30],58 ; :

		mov ArregloaGuardar[42],10 ; \n
		mov ArregloaGuardar[43],80 ;P
		mov ArregloaGuardar[44],117 ;u
		mov ArregloaGuardar[45],110 ;n
		mov ArregloaGuardar[46],116 ;t
		mov ArregloaGuardar[47],111 ;o
		mov ArregloaGuardar[48],115 ;s
		mov ArregloaGuardar[49],95 ;_
		mov ArregloaGuardar[50],49 ;1
		mov ArregloaGuardar[51],58 ; :

		mov ArregloaGuardar[55],10 ; \n
		mov ArregloaGuardar[56],80 ;P
		mov ArregloaGuardar[57],117 ;u
		mov ArregloaGuardar[58],110 ;n
		mov ArregloaGuardar[59],116 ;t
		mov ArregloaGuardar[60],111 ;o
		mov ArregloaGuardar[61],115 ;s
		mov ArregloaGuardar[62],95 ;_
		mov ArregloaGuardar[63],50 ;2
		mov ArregloaGuardar[64],58 ; :

		mov ArregloaGuardar[68],10 ; \n
		mov ArregloaGuardar[69],84 ;T
		mov ArregloaGuardar[70],97 ;a
		mov ArregloaGuardar[71],98 ;b
		mov ArregloaGuardar[72],108 ;l
		mov ArregloaGuardar[73],101 ;e
		mov ArregloaGuardar[74],114 ;r
		mov ArregloaGuardar[75],111 ;o
		mov ArregloaGuardar[76],58 ; :
		mov ArregloaGuardar[77],10 ; :

		Escribir handlerEntrada,ArregloaGuardar, SIZEOF ArregloaGuardar
		Escribir handlerEntrada,tablero, SIZEOF tablero
		Cerrar handlerEntrada
		print salto
		jmp Menu

	Salir:
		close

	Error1:
		close

main endp
end main