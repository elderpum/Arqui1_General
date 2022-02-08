imprimir macro cadena
    mov ax, @data ;Moviendo el segmento de data al registro de proposito general
    mov ds, ax ;Moviendo el registro de proposito general al "data segment"

    mov ah, 09h ;Tipo de operacion de 21h muestra caracteres, basicamente print
    lea dx, cadena ; mostrando la cadena
    int 21h ;interrupcion de DOS
endm

leerHastaEnter macro entrada
    local salto, fin

    xor bx, bx ; limpiando el registro

    salto:
        mov ah, 01h
        int 21h
        cmp al, 0dh ;verificando si se tecleo un salto de linea
        je fin
        mov entrada[bx], al
        inc bx
        jmp salto

    fin:
        mov al, 24h
        mov entrada[bx], al ;agregando un $ para delimitar la cadena ingresada
endm

leerPath macro entrada
    local salto, fin

    xor bx, bx ; limpiando el registro

    salto:
        mov ah, 01h
        int 21h
        cmp al, 0dh
        je fin
        mov entrada[bx], al
        inc bx
        jmp salto
    fin:
        mov al, 00h ;agregando el caracter nulo, para delimitar el final de la ruta
        mov entrada[bx], al
endm

limpiarTerminal macro 
    mov ax, 03h 
    int 10h
endm

menuArchivo macro
    local continuacion, fin

    imprimir mensajePath
    leerPath bufferTeclado
    abrirArchivo bufferTeclado, handle

    cmp banderaMenuArchivo, 0
    jz continuacion
    jnz fin

    continuacion:
        limpiarBuffer bufferArchivo
        leerArchivo handle, sizeof bufferArchivo, bufferArchivo
        cmp banderaMenuLectura, 1
        jz fin
        analizadorLexico bufferArchivo
        imprimir mensajeExitoArchivo
        imprimir enterContinue
        leerHastaEnter bufferTeclado
        limpiarTerminal
    fin:
        
endm

abrirArchivo macro buffer, handler
    local error, fin, busquedaInicioExtension, obtenerExtension, verificarExtension, invalida
    
    mov ax, @data
    mov ds, ax

    mov ah, 3dh
    mov al, 10b ;Abriendo el archivo en lectura/escritura
    lea dx, buffer
    int 21h
    mov handler, ax
    jc error ;mover hacia la etiqueta si se diera un error en la apertura
    
    xor si, si
    xor bx, bx

    ;busca hasta que el caracter nulo que delimita el final de la ruta
    busquedaInicioExtension: 
        cmp buffer[si], "."
        jz obtenerExtension
        inc si
        jnz busquedaInicioExtension

    ;obtiene la extension del archivo, tomando en cuenta que solo es de tres caracteres mas el punto
    obtenerExtension: 
        cmp buffer[si], 00h
        jz verificarExtension
        mov cl, buffer[si]
        mov verificadorExtension[bx], cl ;creando el string auxiliar para verificar la extension
        inc si
        inc bx
        jnz obtenerExtension

    verificarExtension: ;comparacion de strings
        compararCadenas verificadorExtension, extension
        jne invalida
        pop es

    mov banderaMenuArchivo, 0
    jmp fin

    invalida:
        imprimir mensajeExtension
        mov banderaMenuArchivo, 1
        leerHastaEnter buffer
        jmp fin
    error:
        imprimir mensajeError
        mov banderaMenuArchivo, 1
        leerHastaEnter buffer
        mov ax, 1
    fin:
endm

leerArchivo macro handler, numBytes, buffer
    local error, fin

    mov ax, @data
    mov ds, ax
    mov ah, 3fh
    mov bx, handler ;Manejador del archivo
    mov cx, numbytes ;Numero maximo de bytes a leer 
    lea dx, buffer ;Arreglo que almacena el contenido del archivo
    int 21h
    jc error
    mov banderaMenuLectura, 0
    jnc fin
    
    error:
        imprimir mensajeErrorLectura
        mov banderaMenuLectura, 1
        leerHastaEnter bufferTeclado
    fin:
endm

analizadorLexico macro buffer
    local estado0, estado1, estado2, fin, auxiliar, restaurar, obtenerNumero, intermedio, conversion

    limpiarArreglo arregloOriginal
    limpiarArreglo arregloOrdenado
    xor si, si
    mov numeroAux, 0
    mov posicionArreglo, 0
    mov varAux, 0
    mov si, -1

    estado0:
        obtenerCaracter buffer

        cmp bl, "$"
        jz fin
        
        cmp bl, "<"
        jz auxiliar
        
        cmp bl, ">"
        jz estado0 

        jmp estado0
    auxiliar:
        limpiarBuffer bufferAcumulador
        xor bx, bx
        xor di, di
    estado1:
        obtenerCaracter buffer
        
        cmp bl, ">"
        jz estado2

        mov bufferAcumulador[di], bl
        inc di
        jmp estado1
    estado2:
        mov respaldoSI, si
        
        toLowerCase bufferAcumulador
        
        compararCadenas numerosInicio, bufferAcumulador
        je restaurar

        compararCadenas numeroFin, bufferAcumulador
        je restaurar

        compararCadenas numerosFin, bufferAcumulador
        je restaurar
    
        compararCadenas numeroInicio, bufferAcumulador
        je intermedio
    restaurar:
        xor si, si
        mov si, respaldoSI
        dec si
        jmp estado0
    intermedio:
        limpiarBuffer bufferAcumulador
        xor si, si
        mov si, respaldoSI
        xor bx, bx
        xor di, di
    obtenerNumero:
        obtenerCaracter buffer
        
        cmp bl, "<"
        jz conversion

        mov bufferAcumulador[di], bl
        inc di
        jmp obtenerNumero
    conversion:
        mov respaldoSI, si

        convertirANum bufferAcumulador
        xor cx, cx
        mov cl, numeroAux

        xor si, si
        mov si, posicionArreglo

        mov arregloOriginal[si], cl
        mov arregloOrdenado[si], cl

        inc si
        mov posicionArreglo, si
        mov varAux, si

        xor si, si
        mov si, respaldoSI
        dec si
        jmp estado0
    fin:
endm

obtenerCaracter macro buffer
    inc si
    mov bl, buffer[si]
endm

toLowerCase	macro string 
	local iterar, siguiente, fin

	xor si, si
	mov cx, lengthof string

	iterar:
		cmp string[si], 36
		je fin				
		cmp string[si], 65
		jb siguiente
		cmp string[si], 90
		ja siguiente

		add string[si], 32
		inc si

		loop iterar
	
    jmp fin

	siguiente:
		inc si
		jmp iterar

	fin:
endm

limpiarBuffer macro buffer
    local limpiarOp

    mov cx, lengthof buffer
    xor bx, bx
    limpiarOp:
        mov buffer[bx], "$"
        inc bx
    loop limpiarOp
endm

compararCadenas macro string, string2
    push es
    mov ax, ds
    mov es, ax
    mov cx, lengthof string
    lea si, string
    lea di, string2
    repe cmpsb
    cmp cx, 0
endm

limpiarArreglo macro arreglo
    local limpiar, fin
    
    xor si, si
    xor cx, cx
    mov cl, 0

    limpiar:
        mov arreglo[si], cl
        inc si
        cmp si, 19
        jnz limpiar
        jz fin

    fin:
endm

convertirANum macro buffer
    local fin

    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx

    mov dl, 48

    mov cl, buffer[bx]
    inc bx
    sub cl, dl
    mov numeroAux, cl

    cmp buffer[bx], "$"
    jz fin

    mov cl, buffer[bx]
    sub cl, dl

    xor dl, dl
    mov dl, 10

    mov al, numeroAux
    mul dl

    add al, cl
    mov numeroAux, al
    fin:
endm

menuOrdenamiento macro
    local opcion1, opcion2, opcion3, fin

    imprimir menuOrdenamientoMensaje
    imprimir menuOrdenamientoOp1
    imprimir menuOrdenamientoOp2
    imprimir menuOrdenamientoOp3
    imprimir menuOrdenamientoFin

    imprimir opcionMenuOrdenamiento
    leerHastaEnter bufferTeclado
    mov cl, bufferTeclado[0]
    mov tipoOrdenamiento[0], cl
    
    imprimir velocidadMensaje
    leerHastaEnter bufferTeclado
    mov cl, bufferTeclado[0]
    mov tipoVelocidad[0], cl

    imprimir ordenamientoMensaje
    leerHastaEnter bufferTeclado
    mov cl, bufferTeclado[0]
    mov tipoAscDesc[0], cl

    copiarArreglo arregloOriginal, arregloOrdenado

    cmp tipoOrdenamiento[0], "1"
    jz opcion1
    
    cmp tipoOrdenamiento[0], "2"
    jz opcion2
    
    cmp tipoOrdenamiento[0], "3"
    jz opcion3

    opcion1:
        xor ax, ax
        mov ax, varAux
        mov posicionArreglo, ax
        xor ax, ax
        iniciarVideo
        call moverDatos
        bubbleSort arregloOrdenado
        leerHastaEnter
        finalizarVideo
        jmp fin
    opcion2:
        xor ax, ax
        mov ax, varAux
        mov posicionArreglo, ax
        xor ax, ax
        iniciarVideo
        call moverDatos
        mov ax, posicionArreglo
        dec ax
        mov alto, ax
        mov bajo, 0
        xor ax, ax
        obtenerTiempo minutosInicio, segundosInicio
        call quicksort
        leerHastaEnter
        finalizarVideo
        jmp fin
    opcion3:
        xor ax, ax
        mov ax, varAux
        mov posicionArreglo, ax
        xor ax, ax
        iniciarVideo
        call moverDatos
        shellSort arregloOrdenado
        leerHastaEnter
        finalizarVideo
    fin:
endm

recorrerArregloAsc macro arreglo
    local print, vacio, noVacio, continue
    
    push si
    push ax

    xor si, si
    print:
        call moverDatos
        xor ax, ax
        mov al, arreglo[si]
        mov bufferVideo[0], "$"
        mov bufferVideo[1], "$"
        conversionAString bufferVideo
        cmp bufferVideo[1], "$"
        jz vacio
        jmp noVacio

    vacio:
        pintarTexto prueba, 22, columna
        pintarTexto bufferVideo[0], 23, columna
        jmp continue
    
    noVacio:
        pintarTexto bufferVideo[0], 22, columna
        pintarTexto bufferVideo[1], 23, columna
        
    continue:
        obtenerColor arreglo[si]
        calcularAltura arreglo[si]
        pintarBarra inicioBarra, finBarra, altura, color
        call moverDatos
        mov respaldoBX, bx
        mov bx, inicioBarra
        add bx, 8d
        mov inicioBarra, bx
        mov bx, finBarra
        add bx, 8d
        mov finBarra, bx
        mov bx, respaldoBX
        inc columna
        pintarTexto prueba2, 22, columna
        definirDelay
        inc si
        cmp si, varAux
        jnz print

    pop ax
    pop si
endm

recorrerArregloDesc macro arreglo
    local print, vacio, noVacio, continue
    
    push si
    push ax

    xor si, si
    mov si, varAux
    dec si

    print:
        call moverDatos
        xor ax, ax
        mov al, arreglo[si]
        mov bufferVideo[0], "$"
        mov bufferVideo[1], "$"
        conversionAString bufferVideo
        cmp bufferVideo[1], "$"
        jz vacio
        jmp noVacio

    vacio:
        pintarTexto prueba, 22, columna
        pintarTexto bufferVideo[0], 23, columna
        jmp continue
    
    noVacio:
        pintarTexto bufferVideo[0], 22, columna
        pintarTexto bufferVideo[1], 23, columna
        
    continue:
        obtenerColor arreglo[si]
        calcularAltura arreglo[si]
        pintarBarra inicioBarra, finBarra, altura, color
        call moverDatos
        mov respaldoBX, bx
        mov bx, inicioBarra
        add bx, 8d
        mov inicioBarra, bx
        mov bx, finBarra
        add bx, 8d
        mov finBarra, bx
        mov bx, respaldoBX
        inc columna
        pintarTexto prueba2, 22, columna
        definirDelay
        dec si
        cmp si, -1
        jnz print

    pop ax
    pop si
endm

bubbleSort macro arreglo
    local externo, interno, fin, mayor, validacionInterno, validacionExterno, ascendente, descendente, continue, vacio, noVacio, continue2

    mov si, posicionArreglo
    dec si
    mov posicionArreglo, si
    mov numeroAux, 0
    xor bx, bx

    obtenerTiempo minutosInicio, segundosInicio

    externo:
        xor si, si
        jmp interno
        
    interno:
        xor ax, ax
        mov al, arreglo[si]
        mov ah, arreglo[si+1]
        cmp al, ah
        ja mayor
        jmp validacionInterno
    
    mayor:
        ; aux = arreglo[j]
        xor ax, ax
        mov al, arreglo[si]
        mov numeroAux, al

        ;arreglo[j] = arreglo[j+1]
        xor ax, ax
        mov al, arreglo[si+1]
        mov arreglo[si], al

        ;arreglo[j+1] = aux
        xor ax, ax
        mov al, numeroAux
        mov arreglo[si+1], al

        call moverDatos
        pintarTexto bubble, 3, 0
        pintarTexto velocidad, 3, 12
        pintarTexto tipoVelocidad[0], 3, 23
        pintarTexto tiempo, 3, 26
        obtenerTiempo minutosActual, segundosActual
        calcularTiempo minutosBubble, 60d, minutosActual, minutosInicio   
        push ax
        xor ax, ax
        mov al, minutosBubble
        conversionAString bufferVideo
        pop ax
        cmp bufferVideo[1], "$"
        jz vacio
        jmp noVacio

        vacio:
            pintarTexto prueba, 3, 34
            pintarTexto bufferVideo[0], 3, 35
            jmp continue2
        
        noVacio:
            pintarTexto bufferVideo[0], 3, 34
            pintarTexto bufferVideo[1], 3, 35
        
        continue2:
            calcularTiempo segundosBubble, 60d, segundosActual, segundosInicio 
            push ax
            xor ax, ax
            mov al, segundosBubble
            conversionAString bufferVideo
            pop ax
            pintarTexto dosPuntos, 3, 36
            pintarTexto bufferVideo[0], 3, 37
            pintarTexto bufferVideo[1], 3, 38
            call moverVideo
            pintarMarco 5d, 315d, 60d, 195d
            call moverDatos
            mov columna, 9d
            mov inicioBarra, 72d 
            mov finBarra, 79d
            pintarBarra 72d, 231d, 66d, 0d
            cmp tipoAscDesc[0], "a"
            jz ascendente
            jmp descendente

        ascendente:
            recorrerArregloAsc arreglo
            jmp continue

        descendente:
            recorrerArregloDesc arreglo

        continue:
            jmp validacionInterno

    validacionInterno:
        inc si        
        cmp si, posicionArreglo
        jnz interno
    
    validacionExterno:
        inc bx
        cmp bx, posicionArreglo
        jz fin
        jnz externo
    
    fin:
endm

definirDelay macro
    local op0, op1, op2, op3, op4, op5, op6, op7, op8, op9, fin

    cmp tipoVelocidad[0], "0"
    jz op0

    cmp tipoVelocidad[0], "1"
    jz op1

    cmp tipoVelocidad[0], "2"
    jz op2

    cmp tipoVelocidad[0], "3"
    jz op3

    cmp tipoVelocidad[0], "4"
    jz op4

    cmp tipoVelocidad[0], "5"
    jz op5

    cmp tipoVelocidad[0], "6"
    jz op6

    cmp tipoVelocidad[0], "7"
    jz op7

    cmp tipoVelocidad[0], "8"
    jz op8

    cmp tipoVelocidad[0], "9"
    jz op9

    op0:
        delay 50
        jmp fin
    op1:
    delay 50
        jmp fin
    op2:
        delay 70
        jmp fin
    op3:
        delay 90
        jmp fin
    op4:
        delay 100
        jmp fin
    op5:
        delay 120
        jmp fin
    op6:
        delay 140
        jmp fin
    op7:
        delay 160
        jmp fin
    op8:
        delay 180
        jmp fin
    op9:
        delay 190
        jmp fin
    fin:
endm

shellSort macro arreglo
    local condicionCiclo, cicloExterno, cicloInterno, primeraCondicion, traslado, segundaCondicion, cuerpoCiclo, ascendente, descendente, continue, vacio, noVacio, continue2
    
    mov incremento, 0
    mov numeroAux, 0
    ;incremento = incremento / 2
    xor ax, ax
    xor bx, bx
    mov ax, posicionArreglo
    mov bl, 2 ;10
    div bl
    xor ah, ah ;como el cociente esta en al limpio ah, porque la variable incremento es de 16 bits
    mov incremento, ax 

    obtenerTiempo minutosInicio, segundosInicio

    cicloExterno:
        mov si, incremento
        dec si ;i = si
        cicloInterno: ;20
            inc si
            mov di, si ;j = i

            ;temp = arreglo[i]
            xor ax, ax
            mov ah, arreglo[si]
            mov numeroAux, ah

            primeraCondicion:
                cmp di, incremento ;30
                jae segundaCondicion
                jmp traslado

            segundaCondicion:
                xor bx, bx
                mov bx, di
                sub bx, incremento

                xor ax, ax
                mov ah, numeroAux ;40
                cmp arreglo[bx], ah
                jb cuerpoCiclo
                jmp traslado

            cuerpoCiclo:
                mov ah, arreglo[bx]
                mov arreglo[di], ah

                call moverDatos
                pintarTexto shell, 3, 0 ;50
                pintarTexto velocidad, 3, 12
                pintarTexto tipoVelocidad[0], 3, 23
                pintarTexto tiempo, 3, 26
                obtenerTiempo minutosActual, segundosActual
                calcularTiempo minutosShell, 60d, minutosActual, minutosInicio   
                push ax
                xor ax, ax
                mov al, minutosShell
                conversionAString bufferVideo
                pop ax ;60
                cmp bufferVideo[1], "$"
                jz vacio
                jmp noVacio

                vacio:
                    pintarTexto prueba, 3, 34
                    pintarTexto bufferVideo[0], 3, 35
                    jmp continue2
        
                noVacio: ;70
                    pintarTexto bufferVideo[0], 3, 34
                    pintarTexto bufferVideo[1], 3, 35
        
                continue2:
                    calcularTiempo segundosShell, 60d, segundosActual, segundosInicio 
                    push ax
                    xor ax, ax
                    mov al, segundosShell
                    conversionAString bufferVideo
                    pop ax ;80
                    pintarTexto dosPuntos, 3, 36
                    pintarTexto bufferVideo[0], 3, 37
                    pintarTexto bufferVideo[1], 3, 38
                    call moverVideo
                    pintarMarco 5d, 315d, 60d, 195d
                    call moverDatos
                    mov columna, 9d
                    mov inicioBarra, 72d 
                    mov finBarra, 79d
                    pintarBarra 72d, 231d, 66d, 0d
                    cmp tipoAscDesc[0], "a" ;90
                    jz ascendente
                    jmp descendente

                ascendente:
                    recorrerArregloDesc arreglo
                    jmp continue

                descendente:
                    recorrerArregloAsc arreglo
                    
                continue:
                    mov di, bx
                    jmp primeraCondicion

            traslado:
                mov ah, numeroAux
                mov arreglo[di], ah 

            condicionCiclo:
                cmp si, posicionArreglo ;validacion i < len(arreglo)
                jb cicloInterno

        xor bx, bx
        xor ax, ax
        mov ax, incremento
        mov bl, 2
        div bl
        xor ah, ah ;como el cociente esta en al limpio ah, porque la variable incremento es de 16 bits
        mov incremento, ax 

        cmp incremento, 0 ;validacion incremento > 0
        ja cicloExterno
endm

copiarArreglo macro arregloOrigen, arregloDestino
    local copiar

    xor si, si

    copiar:
        xor cx, cx
        mov cl, arregloOrigen[si]
        mov arregloDestino[si], cl
        inc si
        cmp si, 19
        jnz copiar
endm

iniciarVideo macro
    mov ax, 0013h
    int 10h
    mov ax, 0a000h
    mov ds, ax
endm

finalizarVideo macro
    mov ax, 0003h
    int 10h
    mov ax, @data
    mov ds, ax
endm

delay macro tiempo
    local retardo, retardo2, fin

    push ax
    push bx
    
    xor ax, ax
    xor bx, bx

    mov ax, tiempo

    retardo2:
        dec ax
        jz fin
        mov bx, tiempo
    retardo:
        dec bx
        jnz retardo
    jmp retardo2

    fin:
        pop bx
        pop ax
endm

;320 ancho 200 alto

obtenerColor macro valor
    local rojo, azul, amarillo, verde, blanco, fin

    cmp valor, 20
    jbe rojo

    cmp valor, 21
    jae azul

    rojo:
        mov color, 4d
        jmp fin

    azul:
        cmp valor, 40
        ja amarillo
        mov color, 1d
        jmp fin

    amarillo:
        cmp valor, 60
        ja verde
        mov color, 14d
        jmp fin
    
    verde:
        cmp valor, 80
        ja blanco
        mov color, 2d
        jmp fin

    blanco:
        mov color, 15d
    fin:
endm

pintarPixel macro posI, posJ, colorPixel
    push ax
    push bx
    push di
    ;320 * i + j
    xor ax, ax
    xor bx, bx
    xor di, di
    mov ax, 320
    mov bx, posI
    mul bx
    add ax, posJ
    mov di, ax
    xor ax, ax
    mov ax, colorPixel
    call moverVideo
    mov [di], ax

    pop di
    pop bx
    pop ax
endm

pintarMarco macro izq, der, arr, aba
    local ciclo, ciclo2

    push si
    push cx
    
    xor cx, cx
    xor si, si
    mov si, izq
    mov cx, 15

    ciclo:
        pintarPixel arr, si, cx
        pintarPixel aba, si, cx
        inc si
        cmp si, der
        jne ciclo

    xor si, si
    mov si, arr

    ciclo2:
        pintarPixel si, der, cx
        pintarPixel si, izq, cx
        inc si
        cmp si, aba
        jne ciclo2

    pop cx
    pop si
endm

pintarBarra macro posIn, posFin, posAlto, colorPixel
    local ciclo, ciclo2

    push cx
    push si

    xor si, si
    mov si, posIn

    ciclo:
        xor cx, cx
        mov cx, posAlto
        ciclo2:
            pintarPixel cx, si, colorPixel
            call moverDatos
            inc cx
            cmp cx, 170d
            jnz ciclo2
        inc si
        cmp si, posFin
        jne ciclo

    pop si
    pop cx
endm

pintarTexto macro texto, fila, columna
    push ax
    push bx
    push dx

    xor ax, ax
    xor bx, bx
    xor dx, dx

    mov ah, 02h
    mov bh, 00h
    mov dh, fila
    mov dl, columna
    int 10h
    imprimir texto

    pop dx
    pop bx
    pop ax
endm

conversionAString macro convertido
    local split, split2, negativo, fin, fin2

    push si
    push cx
    push bx
    push dx

    xor si, si
    xor cx, cx
    xor bx, bx
    xor dx, dx
    mov dl, 0ah
    test ax, 1000000000000000b
    jnz negativo
    jmp split2

    negativo:
        neg ax
        mov convertido[si], 45
        inc si
        jmp split2
    
    split:
        xor ah, ah

    split2:
        div dl
        inc cx
        push ax
        cmp al, 00h
        je fin2
        jmp split

    fin2:
        pop ax
        add ah, 30h
        mov convertido[si], ah
        inc si
        loop fin2
        mov ah, 24h
        mov convertido[si], ah
        inc si
    fin:
        pop dx
        pop bx
        pop cx
        pop si
endm

calcularAltura macro valor
    local ciclo, fin

    push ax
    xor ax, ax
    mov al, 1d
    mov altura, 165d

    cmp valor, al
    jz fin
    jmp ciclo

    ciclo:
        dec altura
        inc al
        cmp valor, al
        jnz ciclo
        jmp fin

    fin:    
        pop ax
endm

obtenerTiempo macro minutos, segundos
    push ax
    push cx
    push dx

    mov ah, 2ch
    int 21h             

    mov horasInicio, ch
    mov minutos, cl
    mov segundos, dh   

    pop dx
    pop cx
    pop ax
endm

calcularTiempo macro retorno, ajuste, actual, anterior   
    local resta
    
    push ax
    push bx

    and ax, 0 
    and bx, 0   
    
    mov al, actual  
    sub ax, prestamo
    mov bl, anterior  
        
    mov prestamo, 0
        
    cmp ax, bx
    jge resta     
            
    add ax, ajuste  
    mov prestamo, 1
        
    resta:
        sub ax, bx  
        mov retorno, al    
        pop bx
        pop ax
endm

createFile macro buffer
    mov ax, @data
    mov ds, ax
    mov ah, 3ch
    mov cx, 00h
    lea dx, buffer
    int 21h
    mov bx, ax
    mov ah, 3eh
    int 21h
endm

writeFile macro handler, buffer, numbytes
    mov ax, @data
    mov ds, ax
    mov ah, 40h
    mov bx, handler
    mov cx, numbytes
    lea dx, buffer
    int 21h
endm

closeFile macro handler
    mov ax, @data
    mov ds, ax
    mov ah, 3eh
    mov bx, handler
    int 21h
endm

generarReporte macro
    local ciclo, ciclo2, continue, continue2

    createFile path
    abrirArchivo path, handle

    writeFile handle, arquiInicio, sizeof arquiInicio - 1

    writeFile handle, encabezadoInicio, sizeof encabezadoInicio - 1
    writeFile handle, universidadInicio, sizeof universidadInicio - 1
    writeFile handle, universidad, sizeof universidad - 1
    writeFile handle, universidadFin, sizeof universidadFin - 1
    writeFile handle, facultadoInicio, sizeof facultadoInicio - 1
    writeFile handle, facultad, sizeof facultad - 1
    writeFile handle, facultadoFin, sizeof facultadoFin - 1
    writeFile handle, escuelaInicio, sizeof escuelaInicio - 1
    writeFile handle, escuela, sizeof escuela - 1
    writeFile handle, escuelaFin, sizeof escuelaFin - 1
    writeFile handle, cursoInicio, sizeof cursoInicio - 1
    writeFile handle, nombreInicio, sizeof nombreInicio - 1
    writeFile handle, curso, sizeof curso - 1
    writeFile handle, nombreFin, sizeof nombreFin - 1
    writeFile handle, seccionInicio, sizeof seccionInicio - 1
    writeFile handle, seccion, sizeof seccion - 1
    writeFile handle, seccionFin, sizeof seccionFin - 1
    writeFile handle, cursoFin, sizeof cursoFin - 1
    writeFile handle, cicloInicio, sizeof cicloInicio - 1
    writeFile handle, cicloContenido, sizeof cicloContenido - 1
    writeFile handle, cicloFin, sizeof cicloFin - 1
    writeFile handle, fechaInicio, sizeof fechaInicio - 1

    xor ax, ax
    mov ah, 2ah
    int 21h

    mov dia, dl
    mov mes, dh
    mov anio, cx

    xor ax, ax
    mov al, dia
    conversionAString bufferAux
    writeFile handle, diaInicio, sizeof diaInicio - 1
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, diaFin, sizeof diaFin - 1

    xor ax, ax
    mov al, mes
    conversionAString bufferAux
    writeFile handle, mesInicio, sizeof mesInicio - 1
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, mesFin, sizeof mesFin - 1

    xor ax, ax
    mov ax, anio
    conversionAString bufferAnio
    writeFile handle, anioInicio, sizeof anioInicio - 1
    writeFile handle, bufferAnio, sizeof bufferAnio
    writeFile handle, anioFin, sizeof anioFin - 1
    writeFile handle, fechaFin, sizeof fechaFin - 1
    writeFile handle, horaInicio, sizeof horaInicio - 1
    writeFile handle, horaInicio, sizeof horaInicio - 1
    obtenerTiempo minutosActual, segundosActual
    xor ax, ax
    mov al, horasInicio
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, horaFin, sizeof horaFin - 1
    writeFile handle, minutoInicio, sizeof minutoInicio - 1
    xor ax, ax
    mov al, minutosActual
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, minutoFin, sizeof minutoFin - 1
    writeFile handle, segundoInicio, sizeof segundoInicio - 1
    xor ax, ax
    mov al, segundosActual
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, segundoFin, sizeof segundoFin - 1
    writeFile handle, horaFin, sizeof horaFin - 1
    writeFile handle, alumnoInicio, sizeof alumnoInicio - 1
    writeFile handle, nombreInicio, sizeof nombreInicio - 1
    writeFile handle, nombre, sizeof nombre - 1
    writeFile handle, nombreFin, sizeof nombreFin - 1
    writeFile handle, carnetInicio, sizeof carnetInicio - 1
    writeFile handle, carnet, sizeof carnet - 1
    writeFile handle, carnetFin, sizeof carnetFin - 1
    writeFile handle, alumnoFin, sizeof alumnoFin - 1
    writeFile handle, encabezadoFin, sizeof encabezadoFin - 1

    writeFile handle, resultadoInicio, sizeof resultadoInicio - 1
    writeFile handle, listaEntradaInicio, sizeof listaEntradaInicio - 1
    xor si, si
    ciclo:
        xor ax, ax
        mov al, arregloOriginal[si]
        push si
        conversionAString bufferAux
        writeFile handle, bufferAux, sizeof bufferAux
        pop si
        inc si
        cmp varAux, si
        jz continue
        writeFile handle, coma, sizeof coma - 1
        jmp ciclo

    continue:
        writeFile handle, listaEntradaFin, sizeof listaEntradaFin - 1
    
    writeFile handle, listaOrdenadaInicio, sizeof listaOrdenadaInicio - 1

    xor si, si
    ciclo2:
        xor ax, ax
        mov al, arregloOrdenado[si]
        push si
        conversionAString bufferAux
        writeFile handle, bufferAux, sizeof bufferAux
        pop si
        inc si
        cmp varAux, si
        jz continue2
        writeFile handle, coma, sizeof coma - 1
        jmp ciclo2

    continue2:
        writeFile handle, listaOrdenadaFin, sizeof listaOrdenadaFin - 1

    writeFile handle, bubbleInicio, sizeof bubbleInicio - 1
    writeFile handle, velocidadInicio, sizeof velocidadInicio - 1
    writeFile handle, tipoVelocidad, sizeof tipoVelocidad
    writeFile handle, velocidadFin, sizeof velocidadFin - 1
    writeFile handle, tiempoInicio, sizeof tiempoInicio - 1
    writeFile handle, minutoInicio, sizeof minutoInicio - 1
    xor ax, ax
    mov al, minutosBubble
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, minutoFin, sizeof minutoFin - 1
    writeFile handle, segundoInicio, sizeof segundoInicio - 1
    xor ax, ax
    mov al, segundosBubble
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, segundoFin, sizeof segundoFin - 1
    writeFile handle, tiempoFin, sizeof tiempoFin - 1
    writeFile handle, bubbleFin, sizeof bubbleFin - 1

    writeFile handle, quickInicio, sizeof quickInicio - 1
    writeFile handle, velocidadInicio, sizeof velocidadInicio - 1
    writeFile handle, tipoVelocidad, sizeof tipoVelocidad
    writeFile handle, velocidadFin, sizeof velocidadFin - 1
    writeFile handle, tiempoInicio, sizeof tiempoInicio - 1
    writeFile handle, minutoInicio, sizeof minutoInicio - 1
    xor ax, ax
    mov al, minutosQuick
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, minutoFin, sizeof minutoFin - 1
    writeFile handle, segundoInicio, sizeof segundoInicio - 1
    xor ax, ax
    mov al, segundosQuick
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, segundoFin, sizeof segundoFin - 1
    writeFile handle, tiempoFin, sizeof tiempoFin - 1
    writeFile handle, quickFin, sizeof quickFin - 1

    writeFile handle, shellInicio, sizeof shellInicio - 1
    writeFile handle, velocidadInicio, sizeof velocidadInicio - 1
    writeFile handle, tipoVelocidad, sizeof tipoVelocidad
    writeFile handle, velocidadFin, sizeof velocidadFin - 1
    writeFile handle, tiempoInicio, sizeof tiempoInicio - 1
    writeFile handle, minutoInicio, sizeof minutoInicio - 1
    xor ax, ax
    mov al, minutosShell
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, minutoFin, sizeof minutoFin - 1
    writeFile handle, segundoInicio, sizeof segundoInicio - 1
    xor ax, ax
    mov al, segundosShell
    conversionAString bufferAux
    writeFile handle, bufferAux, sizeof bufferAux
    writeFile handle, segundoFin, sizeof segundoFin - 1
    writeFile handle, tiempoFin, sizeof tiempoFin - 1
    writeFile handle, shellFin, sizeof shellFin - 1

    writeFile handle, resultadoFin, sizeof resultadoFin - 1

    writeFile handle, arquiFin, sizeof arquiFin - 1

    closeFile handle
    imprimir generado

    imprimir enterContinue

    leerHastaEnter bufferTeclado
endm