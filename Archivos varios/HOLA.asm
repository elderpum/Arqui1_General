include macros.asm ;archivo con los macros a utilizar


ImprimirTablero macro arreglo 
   LOCAL Mientras, FinMientras, ImprimirSalto
   push si
   push di

   xor si,si
   mov si,1
   xor di,di
   print textoCabFilas
   
   mov ah, 0
   
   mov [aux], ah
   add aux, 49
   print aux
   
   mov aux, 32
   print aux

	Mientras:
		cmp si,65
		je FinMientras				; while(si<65){}

			mov al, arreglo[si]
			mov aux, al 		   ; print(arreglo[si])
			print aux

			cmp di,7
			je ImprimirSalto	 ; if(di == 7){ Imprimir salto}


			mov aux,32   		; else{print(" ")
			print aux
			
         
			inc di				;di++
			inc si   			; si++}
		jmp Mientras

	ImprimirSalto:
		xor di,di 			; di = 0
		print salto			;print("/n")
		inc si  			; si++
      cmp si, 65
      je FinMientras
      inc ah
      mov [aux], ah
      add aux, 49
      print aux
      
      mov aux, 32
      print aux

		jmp Mientras

	FinMientras:

   pop di
   pop si
endm

AnalizarComando macro com ; A1:B2 arreglo1 = [A][1]; arreglo2 = [B][2]
   LOCAL inicio, movimiento, Error ,comprobacioncasillaBlanca, comprobacioncasillaNegra, ComprobarMov
   inicio:
      mov al,com[0]
      mov posicionInicial[0],al ; arreglo1[0] = comando[0]

      mov al,com[1]
      mov posicionInicial[1],al ; arreglo1[1] = comando[1]

      mov al,com[3]
      mov posicionFinal[0],al ;  arreglo2[0] = comando[3]

      mov al,com[4]
      mov posicionFinal[1],al ;  arreglo2[1] = comando[4]




      ConversionCoordenadas posicionInicial ;convierte la coordenada y la guarda en al


      xor si,si ;si tiene el indicie inicial
      mov si,ax

      ConversionCoordenadas posicionFinal ;convierte la coordenada y la guarda en al

      xor di,di ;di tiene el indice final
      mov di,ax

      mov al,tablero[si] 
      mov aux, al
      print aux

      mov al,tablero[di] 
      mov aux, al
      print aux

      ;aqui van validaciones

      xor ax,ax

      cmp turnoact, 1
      je comprobacioncasillaBlanca

      jmp comprobacioncasillaNegra
   
   comprobacioncasillaBlanca: ;si es el turno de los negros
      cmp tablero[si], 98 ; comparar si es negra
      ;mov al,tablero[si] 
      ;print al
      je ComprobarMov
      jmp Error

   comprobacioncasillaNegra: ; si es el turno de los blancos
      cmp tablero[si], 110 ; comparar si es blanca
      ;mov al,tablero[si] 
      ;print al
      je ComprobarMov
      jmp Error

   Error:
      ErrorConCoordenada


   ComprobarMov:


      jmp movimiento
   movimiento:
      
      mov al, tablero[si] ;al = arreglo[si]
      mov tablero[si],95 ;arreglo[si] = '_'

      mov tablero[di],al ;arreglo[di] = arreglo[si]

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
   MUL bl  ; (fila-1)*8 -> al

   xor bx,bx
   mov bl,columna 


   ;la conversion del resultado se guarda en al 
   ;IntToString ax,numero
   ;print numero
   ;print salto

   ADD al,bl ;(columna) + (fila-1)*4 = al

endm

ComprobacionCasillas macro coordenada1, coordenada2
LOCAL inicio, fin, mientras

inicio:

mientras: 


fin:

endm

ErrorConCoordenada macro 
   print textoErrorCoordenadas
   
   cmp turnoact, 1
   je Turno1
   jmp Turno2
endm

Redirigirturn macro
   cmp turnosig, 1
   je Turno1
   jmp Turno2
endm

ConversionColumna macro valor ; valor = valor - 64
   LOCAL hayError, salir
   mov al,valor ; al = valor
   sub al,64   ; al = al - 64


   cmp al, 8
   jg hayError
   jmp salir

   hayError:
      ErrorConCoordenada
   salir:
      mov valor,al ; valor = al

endm

ConversionFila macro valor ; valor = valor - 48
   LOCAL hayError, salir
   mov al,valor ; al = valor
   sub al,48   ; al = al - 48

   cmp al, 8
   jg hayError
   jmp salir

   hayError:
      ErrorConCoordenada
   salir:
      mov valor,al ; valor = al
endm

.model small

;----------------SEGMENTO DE PILA---------------------

.stack

;----------------SEGMENTO DE DATO---------------------

.data
enc db 0ah, 0dh, 'Universidad de San Carlos de Guatemala',0ah, 0dh,'Arquitectura de Ensambladores y Computadores 1' , 0ah, 0dh, 'Bryan Eduardo Gonzalo Mendez Quevedo 201801528' , 0ah, 0dh, 'Practica 3',0ah, 0dh, 'Inrese x si desea cerrar el programa' , '$'
jp1 db 0ah, 0dh, 'Jugador 1 ingrese su nombre:', '$'
jp2 db 0ah, 0dh, 'Jugador 2 ingrese su nombre:', '$'
msjTurno db 0ah, 0dh, 'Turno del jugador:', '$'
finJuego db 0ah, 0dh, 'Ingrese x para finalizar el juego y volver al menu, o escriba REP para generar el reporte', '$'
juegaB db 0ah, 0dh, 'Juega blancas', '$'
juegaN db 0ah, 0dh, 'Juega negras', '$'
punteo db 0ah, 0dh, 'Punteo actual:', '$'



salto db 0ah,0dh, '$' ,'$'
nombre1 db 10 dup('$'), '$'
nombre2 db 10 dup('$'), '$'
textoComando db 0ah, 0dh, 'Ingrese su comando:', '$'

posicionInicial db 2 dup('$'), '$'
posicionFinal db 2 dup('$'), '$'

posicionAux db 2 dup('$'), '$'

valorInicial db 0, '$' 
valorFinal db 0, '$' 

aux db 0, '$' 
resultado db 0, '$'
columna db 0, '$'
fila db 0, '$'

tablero db 65 dup('$'), '$'

numero db 2 dup('$'), '$'

turnoact db 0 , '$'
turnosig db 0 , '$'

comando db 5 dup('$'), '$' ; A1:B2

textoErrorCoordenadas db  'Error en las coordenadas, vuelva a ingresar datos',0ah, 0dh, '$'

textoCabFilas db 0ah, 0dh,'  A B C D E F G H',0ah, 0dh,'$'



bufferEscrito db 100 dup('$')
handlerEscrito dw ?

cabecerahtml db 0ah, 0dh, '<html> <head> </head>', '$'
finhtml db 0ah, 0dh, '</html>', '$'

iniciobody db 0ah, 0dh, '<body>', '$'
finalbody db 0ah, 0dh, '</body>', '$'
etbr db 0ah, 0dh, '<br>', '$'


Nombrejug db 0ah, 0dh, 'Nombre del jugador: ', '$'

Punteojug db 0ah, 0dh, 'Punteo del jugador: ', '$'

;TableroActual db 0ah, 0dh, 'Tablero: ', '$'

punteoBlancas db 5, '$'
punteoNegras db 5, '$'

nombreArch db 0ah, 0dh, 'Ingrese el nombre del archivo', '$'
;----------------SEGMENTO DE CODIGO---------------------


.code
main proc
	
	Menu:

      ;mov punteoBlancas, 0
      ;mov punteoNegras, 0

		print enc
		print salto 
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

		getChar ; lee un caracter del teclado y lo guarda en al
		cmp al, 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
		je Salir

		print jp1
		obtenerTexto nombre1
		print salto

		print jp2 
		obtenerTexto nombre2
		print salto

	Juego:

		Turno1:
      mov turnoact, 1
		print msjTurno
		print nombre1
		print juegaB
		print punteo
		print salto
		ImprimirTablero tablero
		print textoComando
		obtenerTexto comando
		print salto

		AnalizarComando comando

		print finJuego
      mov turnosig,2
		obtenerTexto comando ; lee un caracter del teclado y lo guarda en al
		cmp comando[0], 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}

		je Menu

		jmp ComprarTextoRep

		Turno2:
      mov turnoact, 2
		print msjTurno
		print nombre2
		print juegaN
		print punteo
		print salto
		ImprimirTablero tablero
		print textoComando
		obtenerTexto comando

		AnalizarComando comando

		print finJuego
      mov turnosig,1
		obtenerTexto comando ; lee un caracter del teclado y lo guarda en al
		cmp comando[0], 120 ; if (al == 120){va a brincar a la etiqueta salir}else{va a continuar con el programa}
      
		je Menu
      
		jmp ComprarTextoRep

		jmp Menu


   ComprarTextoRep:
      ;print cabecerahtml
      cmp comando[0], 82
      je ComprarTextoRep1
      Redirigirturn
   ComprarTextoRep1:
      cmp comando[1],69
      je ComprarTextoRep2
      Redirigirturn
   ComprarTextoRep2:
      cmp comando[2],80
      je ComprarTextoRep3
      Redirigirturn
   ComprarTextoRep3:
      jmp CrearArchivo
      


   CrearArchivo:
		print salto
      print nombreArch
      print salto
      limpiar bufferEscrito, SIZEOF bufferEscrito, 24h
      ObtenerRuta bufferEscrito
      crear bufferescrito, handlerEscrito

		jmp EscribirEnArchivo
	
	EscribirEnArchivo:
		
      escribir handlerEscrito, cabecerahtml, SIZEOF cabecerahtml
      
      escribir handlerEscrito, etbr, SIZEOF etbr

      escribir handlerEscrito, Nombrejug, SIZEOF Nombrejug
      escribir handlerEscrito, nombre1, SIZEOF nombre1

      escribir handlerEscrito, etbr, SIZEOF etbr

      escribir handlerEscrito, Punteojug, SIZEOF Punteojug
      escribir handlerEscrito, punteoBlancas, SIZEOF Punteojug

      escribir handlerEscrito, etbr, SIZEOF etbr

      escribir handlerEscrito, Nombrejug, SIZEOF Nombrejug
      escribir handlerEscrito, nombre2, SIZEOF nombre2

      escribir handlerEscrito, etbr, SIZEOF etbr

      escribir handlerEscrito, Punteojug, SIZEOF Punteojug     
      escribir handlerEscrito, punteoNegras, SIZEOF punteoNegras

      escribir handlerEscrito, etbr, SIZEOF etbr

      escribir handlerEscrito, tablero, SIZEOF tablero

      escribir handlerEscrito, finhtml, SIZEOF finhtml

      cerrar handlerEscrito
      Redirigirturn

	Salir:
		close

main endp
end main	