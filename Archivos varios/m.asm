print macro cadena 
	MOV ax, @data
	MOV ds, ax
	MOV ah,09h 
	MOV dx, offset cadena 
	int 21h
endm

getChar macro
	mov ah,01h
	int 21h
endm

ImpCaracter macro arreglo, pos
 LOCAL BLANCA, RBLANCA, NEGRA, RNEGRA, SINVAL,FINCAR, VALMOV
	mov al, arreglo[pos]
	mov var,al
	cmp al, 62h
	je BLANCA
	cmp al, 42h
	je RBLANCA
	cmp al, 6Eh
	je NEGRA
	cmp al, 4Eh
	je RNEGRA
	JMP SINVAL
	
	BLANCA:
	Imprimir 46h
	Imprimir 42h
	JMP FINCAR

	RBLANCA:
	Imprimir 52h
	Imprimir 42h
	JMP FINCAR

	NEGRA:
	Imprimir 46h
	Imprimir 4Eh
	JMP FINCAR

	RNEGRA:
	Imprimir 52h
	Imprimir 4Eh
	JMP FINCAR
	
	SINVAL:
	print var
	print var

	FINCAR:
endm

ObtenerDato macro arreglo, pos
 LOCAL BLANCA, RBLANCA, NEGRA, RNEGRA, SINVAL,FINCAR, VALMOV
	mov al, arreglo[pos]
	mov var,al
	cmp al, 62h
	je BLANCA
	cmp al, 42h
	je RBLANCA
	cmp al, 6Eh
	je NEGRA
	cmp al, 4Eh
	je RNEGRA
	JMP SINVAL
	
	BLANCA:
	Mov dato[0], 46h
	Mov dato[1], 42h
	JMP FINCAR

	RBLANCA:
	Mov dato[0], 52h
	Mov dato[1], 42h
	JMP FINCAR

	NEGRA:
	Mov dato[0],46h
	Mov dato[1],4Eh
	JMP FINCAR

	RNEGRA:
	Mov dato[0],52h
	Mov dato[1],4Eh
	JMP FINCAR
	
	SINVAL:
	Mov dato[0],32
	Mov dato[1],32

	FINCAR:
endm

Imprimir macro dato 
	mov al, dato
	mov var, al
	print var
endm

ImpTablero macro arreglo
 LOCAL OBTENIENDO, FILA, VALOR, INICIO, FIN
	mov si,0
	mov di,0
	MOV al, 49
	MOV cont, al
	
	OBTENIENDO:
	cmp si, 40h
	je FIN
	cmp di, 08h
	jne FILA
	Imprimir 7ch
	print barrita
	print salt
	mov di, 00h
	jmp OBTENIENDO

	FILA:
	inc di;
	cmp si, 00h
	je INICIO
	cmp si, 08h
	je INICIO
	cmp si, 10h
	je INICIO
	cmp si, 18h
	je INICIO
	cmp si, 20h
	je INICIO
	cmp si, 28h
	je INICIO
	cmp si, 30h
	je INICIO
	cmp si, 38h
	je INICIO

	VALOR:
	Imprimir 7ch
	ImpCaracter arreglo, si
	inc si
	JMP OBTENIENDO

	INICIO:
	print cont
	Imprimir 32
	Imprimir 32
	Imprimir 32
	MOV al, cont
	INC al
	MOV cont, al
	jmp VALOR

	FIN:
	UltimaFila	
endm

UltimaFila macro
 LOCAL PASOS, NOPASOS
	Imprimir 7ch
	print barrita
	Imprimir 0ah
	Imprimir 0dh
	print sangria
	Imprimir 32
	Imprimir 32
	MOV cont, 41h
	MOV al, cont
	PASOS:
	print cont
	Imprimir 32
	Imprimir 32
	MOV al, cont
	INC al
	cmp al, 49h
	je NOPASOS
	MOV cont, al
	JMP PASOS
	NOPASOS:
endm
	
FichasBlancas macro arreglo
	MOV al, 62h
	MOV arreglo[1],al
	MOV arreglo[3],al
	MOV arreglo[5],al
	MOV arreglo[7],al
	MOV arreglo[8],al
	MOV arreglo[10],al
	MOV arreglo[12],al
	MOV arreglo[14],al
	MOV arreglo[17],al
	MOV arreglo[19],al
	MOV arreglo[21],al
	MOV arreglo[23],al
endm

FichasNegras macro arreglo
	MOV al, 6Eh
	MOV arreglo[40],al
	MOV arreglo[42],al
	MOV arreglo[44],al
	MOV arreglo[46],al
	MOV arreglo[49],al
	MOV arreglo[51],al
	MOV arreglo[53],al
	MOV arreglo[55],al
	MOV arreglo[56],al
	MOV arreglo[58],al
	MOV arreglo[60],al
	MOV arreglo[62],al
endm


Jugando macro
 LOCAL INICIO, IMPAR, PAR, MOVS, FINTURNO, SINORIGEN, ERROR, COMANDO_S, SALIDA, SAVE, SHOW, MOV_PAR, MOV_IMPAR, FIN, TURNS
	INICIO:
	MOV al, turnos
	TEST al, 1
	jnz IMPAR
	jz PAR

	IMPAR:
	print msgBlanco
	JMP MOVS

	PAR:
	print msgNegro
	JMP MOVS

	MOVS:
	getChar
	MOV c1, al
	MOV mensaje[0], al
	getChar
	MOV c2, al
	MOV mensaje[1], al
	getChar
	MOV c3, al
	MOV mensaje[2], al
	cmp al, 13
	je SINORIGEN
	getChar
	MOV c4, al
	MOV mensaje[3], al
	getChar
	MOV c5, al
	MOV mensaje[4], al
	MOV al, 36
	MOV mensaje[5], al

	print salt

	cmpExit mensaje
	cmpSave mensaje
	cmpShow mensaje

	CasillaSet c1, c2, casillaOrigen
	CasillaSet c4, c5, casillaDestino

	TURNS:
	MOV si,0
	MOV di,0
	MOV ah, turnos
	TEST ah, 1
	jnz MOV_IMPAR
	jz MOV_PAR

	MOV_IMPAR:
	MovBlanco 

	jmp FINTURNO

	MOV_PAR:
	MovNegro

	jmp FINTURNO


	SINORIGEN:
	print msgRand
	print salt
	CasillaSet c1, c2, casillaDestino
	MOV di, 0

	RECORRIDO_LLEGADA:
	MOV al, casillaDestino
	MOV bl, auxiliar2
	cmp al, auxiliar2
	je LEERVALOR
	MOV bl, auxiliar2
	INC di
	INC bl
	MOV auxiliar2, bl
	JMP RECORRIDO_LLEGADA

	LEERVALOR:
	MOV al, tablero[di+7]
	MOV ah, turnos
	TEST ah, 1
	jnz M_I
	jz M_P


	M_I:
	CMP al, 42h
	je MORE1
	CMP al, 62h
	je MORE1
	JMP COMP2

	M_P:
	CMP al, 4Eh
	je MORE1
	CMP al, 6Eh
	je MORE1
	JMP COMP2

	COMP2:
	MOV al, tablero[di+9]
	MOV ah, turnos
	TEST ah, 1
	jnz M_I2
	jz M_P2


	M_I2:
	CMP al, 42h
	je MORE2
	CMP al, 62h
	je MORE2
	JMP COMP3

	M_P2:
	CMP al, 4Eh
	je MORE2
	CMP al, 6Eh
	je MORE2
	JMP COMP3


	COMP3:
	MOV al, tablero[di-7]
	MOV ah, turnos
	TEST ah, 1
	jnz M_I3
	jz M_P3


	M_I3:
	CMP al, 42h
	je MORE3
	CMP al, 62h
	je MORE3
	JMP COMP4

	M_P3:
	CMP al, 4Eh
	je MORE3
	CMP al, 6Eh
	je MORE3
	JMP COMP4

	COMP4:
	MOV al, tablero[di-9]
	MOV ah, turnos
	TEST ah, 1
	jnz M_I4
	jz M_P4


	M_I4:
	CMP al, 42h
	je MORE4
	CMP al, 62h
	je MORE4
	JMP TOTAL

	M_P4:
	CMP al, 4Eh
	je MORE4
	CMP al, 6Eh
	je MORE4
	JMP TOTAL

	
	MORE1:
	ADD dir1, 1
	JMP COMP2

	MORE2:
	ADD dir2, 1
	JMP COMP3
	
	MORE3:
	ADD dir3, 1
	JMP COMP4
	
	MORE4:
	ADD dir4, 1
	JMP TOTAL
		
	TOTAL:
	MOV al, dir1
	ADD tot, al
	MOV al, dir2
	ADD tot, al
	MOV al, dir3
	ADD tot, al
	MOV al, dir4
	ADD tot, al

	CMP tot, 1
	je VAL
	JMP NO_VAL

	VAL:
	print msgRan3
	MOV al, dir1
	CMP al, 1
	je SET1
	MOV al, dir2
	CMP al, 1
	je SET2
	MOV al, dir3
	CMP al, 1
	je SET3
	MOV al, dir4
	CMP al, 1
	je SET4

	SET1:
	MOV al, auxiliar2
	ADD al, 7
	MOV casillaOrigen, al
	MOV bl, 0
	MOV di, 0
	MOV auxiliar2,0
	JMP TURNS

	SET2:
	MOV al, auxiliar2
	ADD al, 9
	MOV casillaOrigen, al
	MOV bl, 0
	MOV di, 0
	MOV auxiliar2,0
	JMP TURNS

	SET3:
	MOV al, auxiliar2
	SUB al, 7
	MOV casillaOrigen, al
	MOV bl, 0
	MOV di, 0
	MOV auxiliar2,0
	JMP TURNS

	SET4:
	MOV al, auxiliar2
	SUB al, 9
	MOV casillaOrigen, al
	MOV bl, 0
	MOV di, 0
	MOV auxiliar2,0
	JMP TURNS


	NO_VAL:
	print msgRan2
	print salt
	MOV di, 0
	MOV auxiliar2,0
	MOV dir1,0
	MOV dir2,0
	MOV dir3,0
	MOV dir4,0
	MOV tot, 0
	JMP TURN_NO_VALIDO

	SALIDA:
	print msgSalir
	print salt
	print salt
	MOV al, 31h
	MOV turnos, al
	JMP Menu

	FINTURNO:
	MOV al, valido
	CMP al, 01h
	je TURN_NO_VALIDO
	JMP TURN_VALIDO

	TURN_VALIDO:
	print msgPos1
	print salt
	MOV auxiliar,0
	MOV auxiliar2,0
	MOV auxiliar2,0
	MOV dir1,0
	MOV dir2,0
	MOV dir3,0
	MOV dir4,0
	MOV tot, 0
	MOV al, turnos
	CMP al, 31h
	je T_NEGRO
	CMP al, 32h
	je T_BLANCO
	
	T_NEGRO:
	INC al
	MOV turnos, al
	JMP FIN

	T_BLANCO:
	DEC al
	MOV turnos, al
	JMP FIN

	TURN_NO_VALIDO:
	MOV al, valido
	MOV al, 0
	MOV valido, 0
	MOV auxiliar,0
	MOV auxiliar2,0
	MOV dir1,0
	MOV dir2,0
	MOV dir3,0
	MOV dir4,0
	MOV tot, 0
	FIN:
endm

CasillaSet macro columna, fila, casilla
 	MOV ah, fila
	SUB ah, 49
	MOV fila, ah
	MOV al, fila
	MOV bl, 8
	mul bl
	MOV fila, al
	MOV ah, columna
	SUB ah, 65
	MOV columna, ah
	MOV ah, columna
	MOV al, fila
	ADD ah, al
	MOV casilla, ah
endm

LimpiarTablero macro arreglo
	MOV arreglo[24],0
	MOV arreglo[26],0
	MOV arreglo[28],0
	MOV arreglo[30],0
	MOV arreglo[33],0
	MOV arreglo[35],0
	MOV arreglo[37],0
	MOV arreglo[39],0
endm

ObtenerRuta macro buffer
	LOCAL ObtenerChar, FinDT
	MOV si,10
	ObtenerChar:
	getChar
	cmp al, 0dh
	je FinDT
	mov buffer[si],al
	inc si
	jmp ObtenerChar
	FinDT:
	mov al, 00h
	mov buffer[si],al
endm

RutaDefinida macro buffer
 MOV buffer[0],99
 MOV buffer[1],58
 MOV buffer[2],92
 MOV buffer[3],74
 MOV buffer[4],85
 MOV buffer[5],69
 MOV buffer[6],71
 MOV buffer[7],79
 MOV buffer[8],83
 MOV buffer[9],92
endm

cmpExit macro comando
	LOCAL FIN
	mov cx,4
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, comando1
	repe cmpsb
	jne FIN
	print msgSalir
	print salt
	Mov al, 31h
	Mov turnos, al
	jmp Menu
	FIN:
endm

cmpSave macro comando
	LOCAL FIN
	
	mov cx,4
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, comando2
	repe cmpsb
	jne FIN
	LimpiarEntrada entrada
	print msgSave
	RutaDefinida entrada
	ObtenerRuta entrada
	PasarInfo
	Crear entrada, handlerentrada
	Escribir handlerentrada, informacion
	Cerrar handlerentrada
	JMP TURN_NO_VALIDO
	FIN:
endm


cmpShow macro comando
	LOCAL FIN
	mov cx,4
	mov ax,ds
	mov es,ax
	Lea si, comando
	Lea di, comando3
	repe cmpsb
	jne FIN
	print msgShow
	CrearReporte 
	JMP TURN_NO_VALIDO
	FIN:
endm


Abrir macro buffer,handler
 LOCAL ERROR
	mov ah, 3dh
	mov al, 02h
	lea dx, buffer
	int 21h
	jc ERROR
	mov handler, ax
	Imprimir msgAbrir
	JMP FIN
	ERROR:
	print salt
	print errAbrir 
	print salt
	jmp Menu
	FIN:
endm

Cerrar macro handler
 LOCAL FIN
	mov ah, 3eh
	mov bx, handler
	int 21h
	jnc FIN
	print salt
	print errCerrar 
	print salt
	FIN:
endm

Leer macro handler, buffer
 LOCAL ERROR, FIN
	mov ah, 3Fh
	mov bx, handler
	mov cx, 67
	lea dx, buffer
	int 21h
	jc ERROR
	print salt
	Imprimir msgLeer
	print salt
	JMP FIN
	ERROR:
	print salt
	Imprimir errLeer
	print salt
	jmp Menu
	FIN:
endm

Crear macro buffer, handler
 LOCAL FIN, ERROR
	mov ah, 3ch
	mov cx, 00h
	lea dx, buffer
	int 21h 
	jc ERROR
	mov handler, ax
	JMP FIN
	ERROR:
	print salt
	print errSave 
	print salt
	FIN:
endm

Escribir macro handler, buffer
 LOCAL FIN, ERROR
	mov ah, 40h
	mov bx, handler
	mov cx, 65
	lea dx, buffer
	int 21h 
	jc ERROR
	print msgWard
	JMP FIN
	ERROR:
	print salt
	print errEsc 
	print salt
	FIN:
endm

CrearReporte macro
 LOCAL REPETIR, IMPAR, PAR, VALORES, BLANCA, RBLANCA, NEGRA, RNEGRA, SINVAL, NUEVA, INCREMENTO, FIN
	LimpiarEntrada repo
	RutaDefinida repo
	MOV repo[10],84
	MOV repo[11],97
	MOV repo[12],98
	MOV repo[13],108
	MOV repo[14],101
	MOV repo[15],114
	MOV repo[16],111
	MOV repo[17],46
	MOV repo[18],104
	MOV repo[19],116
	MOV repo[20],109
	MOV repo[21],108
	MOV repo[22],00
	Imprimir salt
	ObtenerHora
	Crear repo, handlerentrada	
	EscribirReporte handlerentrada, html1, SIZEOF html1 
	EscribirReporte handlerentrada, hora, SIZEOF hora-1
	EscribirReporte handlerentrada, html2, SIZEOF html2 
	EscribirReporte handlerentrada, html_tab, SIZEOF html_tab-1
	

	MOV si,0
	MOV di,0
	MOV al,0
	MOV cl,1

	REPETIR:
	CMP si,3Fh
	je FIN

	MOV ah, auxr
	TEST ah, 1
	jnz IMPAR
	jz PAR

	IMPAR:
	EscribirReporte handlerentrada, html_t1, SIZEOF html_t1-1
	ObtenerDato tablero, si
	EscribirReporte handlerentrada, dato, SIZEOF dato-1
	EscribirReporte handlerentrada, html_c, SIZEOF html_c-1
	JMP INCREMENTO

	PAR:
	EscribirReporte handlerentrada, html_t2, SIZEOF html_t2-1
	ObtenerDato tablero, si
	EscribirReporte handlerentrada, dato, SIZEOF dato-1
	EscribirReporte handlerentrada, html_c, SIZEOF html_c-1
	JMP INCREMENTO
	
	INCREMENTO:
	inc si
	inc di
	ADD al,1
	ADD auxr,1
	ADD conr,1
	CMP conr,8
	je NUEVA
	JMP REPETIR

	NUEVA:
	EscribirReporte handlerentrada, html_tabc, SIZEOF html_tabc-1
	EscribirReporte handlerentrada, html_tab, SIZEOF html_tab-1
	MOV conr,0
	SUB auxr,1
	JMP REPETIR

	FIN:
	EscribirReporte handlerentrada, html_tabb, SIZEOF html_tabb-1
	MOV auxr,0
	MOV conr,0
	Cerrar handlerentrada

endm

EscribirReporte macro handler, buffer, numbytes
 LOCAL FIN, ERROR
	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h 
	jc ERROR
	JMP FIN
	ERROR:
	print salt
	print errEsc 
	print salt
	FIN:
endm

MovBlanco macro
 LOCAL RECORRIDO_ORIGEN, RECORRIDO_LLEGADA, LEERVALOR, NO_VALIDO, PARED_DERECHA, PARED_IZQUIERDA, FIN, COMIDA
	RECORRIDO_ORIGEN:
	MOV al, casillaOrigen
	MOV bl, auxiliar
	cmp al, auxiliar
	je RECORRIDO_LLEGADA
	MOV bl, auxiliar
	INC si
	INC bl
	MOV auxiliar, bl
	JMP RECORRIDO_ORIGEN

	RECORRIDO_LLEGADA:
	MOV al, casillaDestino
	MOV bl, auxiliar2
	cmp al, auxiliar2
	je LEERVALOR
	MOV bl, auxiliar2
	INC di
	INC bl
	MOV auxiliar2, bl
	JMP RECORRIDO_LLEGADA

	LEERVALOR:
	MOV bl, tablero[si]
	CMP bl,62h
	je SALT_NORMAL
	MOV bl, tablero[si]
	CMP bl,42h
	je SALT_REINA


	SALT_NORMAL:
	;VALIDACIONES DEL MOVIMIENTO
	MOV bl, tablero[di]
	CMP bl, 00h
	jne NO_VALIDO

	MOV bl, auxiliar
	CMP bl,08
	je PARED_IZQUIERDA
	CMP bl,24
	je PARED_IZQUIERDA
	CMP bl,40
	je PARED_IZQUIERDA
	CMP bl,07
	je PARED_DERECHA
	CMP bl,23
	je PARED_DERECHA
	CMP bl,39
	je PARED_DERECHA
	CMP bl,55
	je PARED_DERECHA
	JMP NORMAL

	SALT_REINA:
	print bug
	MOV bl, tablero[di]
	CMP bl,00h
	jne NO_VALIDO
	MOV bl, auxiliar
	CMP bl,08
	je PARED_IZQUIERDA_R
	CMP bl,24
	je PARED_IZQUIERDA_R
	CMP bl,40
	je PARED_IZQUIERDA_R
	CMP bl,07
	je PARED_DERECHA_R
	CMP bl,23
	je PARED_DERECHA_R
	CMP bl,39
	je PARED_DERECHA_R
	CMP bl,55
	je PARED_DERECHA_R
	JMP NORMAL_R


	PARED_IZQUIERDA:
	MOV cl, auxiliar
	MOV dl, auxiliar2
	ADD cl, 9
	CMP cl, auxiliar2
	je PINTADO
	ADD cl, 9
	CMP cl, auxiliar2
	je COMIDA
	JMP NO_VALIDO

	PARED_DERECHA:
	MOV cl, auxiliar
	MOV dl, auxiliar2
	ADD cl, 7
	CMP cl, auxiliar2
	je PINTADO
	ADD cl, 7
	CMP cl, auxiliar2
	je COMIDA
	JMP NO_VALIDO

	NORMAL:
	mov cl, auxiliar
	mov dl, auxiliar2
	add cl, 7
	CMP cl, auxiliar2
	je PINTADO
	add cl, 2
	CMP cl, auxiliar2
	je PINTADO
	ADD cl, 7
	CMP cl, auxiliar2
	je COMIDA
	add cl, 2
	CMP cl, auxiliar2
	je COMIDA

	PARED_IZQUIERDA_R:
	MOV cl, auxiliar
	MOV dl, auxiliar2
	ADD cl, 9
	CMP cl, auxiliar2
	je PINTADO
	ADD cl, 9
	CMP cl, auxiliar2
	je COMIDA_R
	MOV cl, auxiliar
	MOV dl, auxiliar2
	SUB cl, 9
	CMP cl, auxiliar2
	je PINTADO
	SUB cl, 9
	CMP cl, auxiliar2
	je COMIDA_R


	JMP NO_VALIDO

	PARED_DERECHA_R:
	MOV cl, auxiliar
	MOV dl, auxiliar2
	ADD cl, 7
	CMP cl, auxiliar2
	je PINTADO
	ADD cl, 7
	CMP cl, auxiliar2
	je COMIDA_R
	MOV cl, auxiliar
	MOV dl, auxiliar2
	SUB cl, 7
	CMP cl, auxiliar2
	je PINTADO
	SUB cl, 7
	CMP cl, auxiliar2
	je COMIDA_R
	JMP NO_VALIDO

	NORMAL_R:
	mov cl, auxiliar
	mov dl, auxiliar2
	add cl, 7
	CMP cl, auxiliar2
	je PINTADO
	add cl, 2
	CMP cl, auxiliar2
	je PINTADO
	ADD cl, 7
	CMP cl, auxiliar2
	je COMIDA_R
	add cl, 2
	CMP cl, auxiliar2
	je COMIDA_R
	mov cl, auxiliar
	mov dl, auxiliar2
	sub cl, 7
	CMP cl, auxiliar2
	je PINTADO
	sub cl, 2
	CMP cl, auxiliar2
	je PINTADO
	sub cl, 7
	CMP cl, auxiliar2
	je COMIDA_R
	sub cl, 2
	CMP cl, auxiliar2
	je COMIDA_R

	COMIDA:
	MOV al, tablero[si+7]
	CMP al, 6Eh
	je VAL_COM_1
	CMP al, 4Eh
	je VAL_COM_1
	MOV al, tablero[si+9]
	CMP al, 6Eh
	je VAL_COM_2
	CMP al, 4Eh
	je VAL_COM_2
	jne NO_VALIDO

	COMIDA_R:
	MOV al, tablero[si+7]
	CMP al, 6Eh
	je VAL_COM_1
	CMP al, 4Eh
	je VAL_COM_1
	MOV al, tablero[si+9]
	CMP al, 6Eh
	je VAL_COM_2
	CMP al, 4Eh
	je VAL_COM_2
	MOV al, tablero[si - 7]
	CMP al, 6Eh
	je VAL_COM_3
	CMP al, 4Eh
	je VAL_COM_3
	MOV al, tablero[si - 9]
	CMP al, 6Eh
	je VAL_COM_4
	CMP al, 4Eh
	je VAL_COM_4
	jne NO_VALIDO

	VAL_COM_1:
	MOV tablero[si+7], 0
	SUB fichN, 1
	JMP PINTADO 

	VAL_COM_2:
	MOV tablero[si+9], 0
	SUB fichN, 1
	JMP PINTADO 

	VAL_COM_3:
	MOV tablero[si - 7], 0
	SUB fichN, 1
	JMP PINTADO 

	VAL_COM_4:
    MOV tablero[si - 9], 0
	SUB fichN, 1
	JMP PINTADO 

	

	PINTADO:
	MOV bl, auxiliar2
	CMP bl,56
	je CONV_REINA
	CMP bl,58
	je CONV_REINA
	CMP bl,60
	je CONV_REINA
	CMP bl,62
	je CONV_REINA



	MOV al, tablero[si]
	MOV bl, tablero[di]
	MOV tablero[di], al
	MOV tablero[si], bl
	JMP FIN

	CONV_REINA:
	MOV al, tablero[si]
	MOV bl, tablero[di]
	MOV tablero[di], 42h
	MOV tablero[si], bl
	JMP FIN




	NO_VALIDO:
	print msgPos
	print salt
	MOV al, valido
	MOV al, 01h
	MOV valido, al

 	FIN:
endm

MovNegro macro
 LOCAL RECORRIDO_ORIGEN, RECORRIDO_LLEGADA, LEERVALOR, NO_VALIDO, FIN, NORMAL, PINTADO, PARED_IZQUIERDA, PARED_DERECHA, VAL_COM_1, VAL_COM_2, CONV_REINA
	RECORRIDO_ORIGEN:
	MOV al, casillaOrigen
	MOV bl, auxiliar
	cmp al, auxiliar
	je RECORRIDO_LLEGADA
	MOV bl, auxiliar
	INC si
	INC bl
	MOV auxiliar, bl
	JMP RECORRIDO_ORIGEN

	RECORRIDO_LLEGADA:
	MOV al, casillaDestino
	MOV bl, auxiliar2
	cmp al, auxiliar2
	je LEERVALOR
	MOV bl, auxiliar2
	INC di
	INC bl
	MOV auxiliar2, bl
	JMP RECORRIDO_LLEGADA

	LEERVALOR:
	MOV bl, tablero[si]
	CMP bl,6Eh
	jne NO_VALIDO
	MOV bl, tablero[di]
	CMP bl,00h
	jne NO_VALIDO


	;VALIDACIONES DEL MOVIMIENTO
	MOV bl, auxiliar
	CMP bl,08
	je PARED_IZQUIERDA
	CMP bl,24
	je PARED_IZQUIERDA
	CMP bl,40
	je PARED_IZQUIERDA
	CMP bl,56
	je PARED_IZQUIERDA
	CMP bl,23
	je PARED_DERECHA
	CMP bl,39
	je PARED_DERECHA
	CMP bl,55
	je PARED_DERECHA

	JMP NORMAL

	PARED_IZQUIERDA:
	MOV al, tablero[si]
	MOV bl, tablero[di]
	MOV cl, auxiliar
	MOV dl, auxiliar2
	SUB cl, 7
	CMP cl, auxiliar2
	je PINTADO
	SUB cl, 7
	CMP cl, auxiliar2
	je COMIDA
	JMP NO_VALIDO

	PARED_DERECHA:
	MOV al, tablero[si]
	MOV bl, tablero[di]
	MOV cl, auxiliar
	MOV dl, auxiliar2
	SUB cl, 9
	CMP cl, auxiliar2
	je PINTADO
	SUB cl, 9
	CMP cl, auxiliar2
	je COMIDA
	JMP NO_VALIDO

	NORMAL:
	mov cl, auxiliar
	mov dl, auxiliar2
	sub cl, 7
	CMP cl, auxiliar2
	je PINTADO
	sub cl, 2
	CMP cl, auxiliar2
	je PINTADO
	sub cl, 7
	CMP cl, auxiliar2
	je COMIDA
	sub cl, 2
	CMP cl, auxiliar2
	je COMIDA

	COMIDA:
	MOV al, tablero[si - 7]
	CMP al, 62h
	je VAL_COM_1
	CMP al, 42h
	je VAL_COM_1
	MOV al, tablero[si - 9]
	CMP al, 62h
	je VAL_COM_2
	CMP al, 42h
	je VAL_COM_2
	jne NO_VALIDO

	VAL_COM_1:
	MOV tablero[si - 7], 0
	SUB fichB, 1
	JMP PINTADO 

	VAL_COM_2:
	MOV tablero[si - 9], 0
	SUB fichB, 1
	JMP PINTADO 


	PINTADO:
	MOV bl, auxiliar2
	CMP bl,01
	je CONV_REINA
	CMP bl,03
	je CONV_REINA
	CMP bl,05
	je CONV_REINA
	CMP bl,07
	je CONV_REINA

	MOV al, tablero[si]
	MOV bl, tablero[di]
	MOV tablero[di], al
	MOV tablero[si], bl

	JMP FIN


	CONV_REINA:
	MOV al, tablero[si]
	MOV bl, tablero[di]
	MOV tablero[di], 4Eh
	MOV tablero[si], bl
	JMP FIN

	NO_VALIDO:
	print msgPos
	print salt
	MOV al, valido
	MOV al, 01h
	MOV valido, al
 	FIN:
endm


LlenarTablero macro
	LOCAL INICIO, T_BLANCO,T_NEGRO,FIN, ESPACIO, INCREMENTO
	MOV si,0
	INICIO:
	MOV al, informacion[si]
	CMP al, 20h
	je ESPACIO
	MOV tablero[si], al
	JMP INCREMENTO
	ESPACIO:
	MOV tablero[si], 00h
	INCREMENTO:
	INC si
	CMP si, 42h
	jne INICIO
	MOV al, tablero[64]
	CMP al, 32h
	je T_NEGRO
	CMP al, 31h
	je T_BLANCO
	T_BLANCO:
	MOV al, 31h
	MOV turnos, al
	JMP FIN
	T_NEGRO:
	MOV al, 32h
	MOV turnos, al
	JMP FIN
	FIN:
	MOV si,0
endm

LimpiarInformacion macro buffer
	LOCAL REPETIR
	MOV si,0
	MOV cx,0
	MOV cx, 65
	REPETIR:
	mov buffer[si],0
	inc si
	loop REPETIR
endm

LimpiarEntrada macro buffer
	LOCAL REPETIR
	MOV si,0
	MOV cx,0
	MOV cx,50
	REPETIR:
	mov buffer[si],0
	inc si
	loop REPETIR
endm

ObtenerHora macro
	MOV si, 0
	MOV AH,2CH
	INT 21H
	div10 CH
	mov hora[si] , ':'
	inc si
	div10 CL
	print hora
	;CH   CL    DH   DL
endm

div10 macro n
	mov dx, 0
	mov ah, 0
	mov al, n
	mov bl, 10d
	div bl 
	add al , 48
	add ah , 48
	mov hora[si] , al
	inc si
	mov hora[si] , ah
	inc si
endm

PasarInfo macro
 LOCAL INICIO, ESPACIO, INCREMENTO, FIN	
	MOV si, 0
	INICIO:
	MOV al, tablero[si]
	CMP al, 00h
	je ESPACIO
	MOV informacion[si], al
	JMP INCREMENTO
	ESPACIO:
	MOV informacion[si], 20h
	INCREMENTO:
	INC si
	CMP si, 43h
	jne INICIO
	FIN:
	MOV si,0
	MOV al, turnos
	MOV informacion[64], al
endm