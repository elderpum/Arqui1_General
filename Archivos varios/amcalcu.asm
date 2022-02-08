operar macro buffer, buffer2
    LOCAL INGRESARCARACTER,FINAL,INGRESARSUM,INGRESARREST,INGRESARDIV,INGRESARMUL
    LOCAL INGRESARPOT,INGRESARMOD,INGRESARFACT,INGRESARPUNT,INGRESARNUMERO,LIMPIAR
    xor si,si
    xor bx,bx
    mov cx,50
    LIMPIAR:
        mov buffer2[bx],'$'
        inc bx
        loop LIMPIAR
    xor bx,bx
    INGRESARCARACTER:
    cmp buffer[si],24h
    je FINAL
    cmp buffer[si],43;+
    je INGRESARSUM
    cmp buffer[si],45;-
    je INGRESARREST
    cmp buffer[si],33;!
    je INGRESARFACT
    cmp buffer[si],37;%
    je INGRESARMOD
    cmp buffer[si],47;/
    je INGRESARDIV
    cmp buffer[si],46;.
    je INGRESARPUNT
    cmp buffer[si],42;*
    je INGRESARMUL
    jmp INGRESARNUMERO
    INGRESARSUM:
    mov ax,03e8h
    mov buffer2[bx],ax
    invertir buffer2
    inc si
    add bx,2
    jmp INGRESARCARACTER
    INGRESARREST:
    mov ax,03e9h
    mov buffer2[bx],ax
    invertir buffer2
    inc si
    add bx,2
    jmp INGRESARCARACTER
    INGRESARDIV:
    mov ax,03ebh
    mov buffer2[bx],ax
    invertir buffer2
    inc si
    add bx,2
    jmp INGRESARCARACTER
    INGRESARMOD:
    mov ax,03ech
    mov buffer2[bx],ax
    invertir buffer2
    inc si
    add bx,2
    jmp INGRESARCARACTER
    INGRESARFACT:
    mov ax,03eeh
    mov buffer2[bx],ax
    invertir buffer2
    inc si
    add bx,2
    jmp INGRESARCARACTER
    INGRESARPUNT:
    mov ax,03efh;1007
    mov buffer2[bx],ax
    invertir buffer2
    inc si
    add bx,2
    jmp INGRESARCARACTER
    INGRESARMUL:
    inc si
    cmp buffer[si],42;*
    je INGRESARPOT
    mov ax,03eah
    mov buffer2[bx],ax
    invertir buffer2
    add bx,2
    jmp INGRESARCARACTER
    INGRESARPOT:
    mov ax,03edh
    mov buffer2[bx],ax
    invertir buffer2
    inc si
    add bx,2
    jmp INGRESARCARACTER
    INGRESARNUMERO:
    getText buffer,bufferNum1
    dectohex buffer2
    jmp INGRESARCARACTER
    FINAL:    
endm
getText macro buffer1, buffer2
    LOCAL CONTINUE,CONTINUE2,CONTINUE3,FIN
    push bx
    push ax
    xor bx,bx
    CONTINUE:
    cmp buffer1[si],48
    jae CONTINUE2
    jmp FIN
    CONTINUE2:
    cmp buffer1[si],57
    jbe CONTINUE3
    jmp FIN
    CONTINUE3:
    mov al,buffer1[si]
    mov buffer2[bx],al
    inc si
    inc bx
    jmp CONTINUE
    FIN:
    mov al,'$'
    mov buffer2[bx],al
    pop ax
    pop bx 
endm
dectohex macro buffer ;de decimal a ascii
    LOCAL CONVERT,FIN
    xor di,di
    xor ax,ax
    mov buffer[bx],0
    CONVERT:
        mov al,bufferNum1[di]
            xor ah,ah
            sub al,30h
            add buffer[bx],ax
            inc di
        
        cmp bufferNum1[di],'$'
            je FIN
        
        mov ax,buffer[bx]
        push bx
        mov bx,0Ah
        mul bx
        pop bx
        mov buffer[bx],ax
        jmp CONVERT
    FIN:
        invertir buffer
        add bx,2
endm
invertir macro buffer
    push ax
    push cx
    mov ax,buffer[bx]
    mov ch,al
    mov cl,ah
    mov buffer[bx],cx
    pop cx
    pop ax
endm
postfija macro buffer;3+4*5 ---- 45*3+
    LOCAL ESTADO,INGRESARNUMERO,VERIFICAR,REPETIR,FINAL,INGRESARPILA,SUMARESTA,MULTDIVMOD,POT,IGUALPRECEDENCIA,MENORPRECEDENCIA,FN
    xor bx,bx
    xor si,si
    xor di,di
    ESTADO:
        mov cx,buffer[si]
        mov ah,cl
        inc si 
        mov cx,buffer[si]
        mov al,cl
        mov dl,al
        cmp dl,'$'
        je FINAL
        cmp ax,999
        jbe INGRESARNUMERO
        cmp ax,1006;!
        je INGRESARNUMERO
        cmp ax,1007;.
        je INGRESARNUMERO
        jmp VERIFICAR
    INGRESARNUMERO:
        mov bufferPostfija[bx],ax
        invertir bufferPostfija
        add bx,2
        jmp REPETIR
    VERIFICAR:
        cmp di,0
        je INGRESARPILA
        ;comprobar si son de la misma precedencia
        cmp ax,1000;+
        je SUMARESTA
        cmp ax,1001;-
        je SUMARESTA
        cmp ax,1002;*
        je MULTDIVMOD
        cmp ax,1003;/
        je MULTDIVMOD
        cmp ax,1004;%
        je MULTDIVMOD
        cmp ax,1005;**
        je POT
    SUMARESTA:
        pop cx
        push cx
        cmp cx,1000;+
        je IGUALPRECEDENCIA
        cmp cx,1001;-
        je IGUALPRECEDENCIA
        cmp cx,1002;*
        je MENORPRECEDENCIA
        cmp cx,1003;/
        je MENORPRECEDENCIA
        cmp cx,1004;%
        je MENORPRECEDENCIA
        cmp cx,1005;**
        je MENORPRECEDENCIA
    MULTDIVMOD:
        pop cx
        push cx
        cmp cx,1000;+
        je INGRESARPILA
        cmp cx,1001;-
        je INGRESARPILA
        cmp cx,1002;*
        je IGUALPRECEDENCIA
        cmp cx,1003;/
        je IGUALPRECEDENCIA
        cmp cx,1004;%
        je IGUALPRECEDENCIA
        cmp cx,1005;**
        je MENORPRECEDENCIA
    POT:
        pop cx
        push cx 
        cmp cx,1000;+
        je INGRESARPILA
        cmp cx,1001;-
        je INGRESARPILA
        cmp cx,1002;*
        je INGRESARPILA
        cmp cx,1003;/
        je INGRESARPILA
        cmp cx,1004;%
        je INGRESARPILA
        cmp cx,1005;**
        je IGUALPRECEDENCIA
    MENORPRECEDENCIA:
        cmp di,0
        je INGRESARPILA
        pop dx
        mov bufferPostfija[bx],dx
        invertir bufferPostfija
        add bx,2
        dec di
        jmp MENORPRECEDENCIA
    IGUALPRECEDENCIA:
        pop cx
        mov bufferPostfija[bx],cx
        invertir bufferPostfija
        dec di
        add bx,2
    INGRESARPILA:;MAYORPRECEDENCIA
        push ax
        inc di
    REPETIR:
        inc si
        jmp ESTADO
    FINAL:
        cmp di,0
        je FN
        pop dx
        mov bufferPostfija[bx],dx
        invertir bufferPostfija
        add bx,2
        dec di
        jmp FINAL
    FN:
endm
operaciones macro buffer,bHandler
    LOCAL ESTADO,NUMERO,FINAL,PUNTO,UNDECIMAL,MULT,NUM,SUMA,RESTA,DIVISION,MODU,POT,FACTORIAL,LOOPPOT,LOOPFACT,CERO,INCFACT,CCC,NEGATIVO
    LOCAL ESCRIBIR100,ESCRIBIR101,ESCRIBIR103,LOOP100,LOOP101,LOOP103,UPOT,UMULT,NUMEROSSEGUIDOS,TRESNUM,REGRESARMUL,CORRECTA
    LOCAL CORRECTA1,CORRECTA2,CORRECTA3,CORRECTA4,CORRECTA5,CORRECTA6,REGRESARPOT,REGRESARSUM,REGRESARREST,REGRESARMOD,REGRESARDIV,REGRESARFACT
    LOCAL CONVSIG,CONVNEG,CONVSIG1,CONVNEG1,NEGATIVO1,CCC1,CONVSIG2,CONVNEG2,NEGATIVO2,CCC2,CONVSIG3,CONVNEG3,NEGATIVO3,CCC3
    LOCAL CONVSIG4,CONVNEG4,NEGATIVO4,CCC4,CONVSIG5,CONVNEG5,NEGATIVO5,CCC5
    call moverPost
    xor bx,bx
    xor ax,ax
    mov buffer,0
    escribirF bHandler, SIZEOF graphviz, graphviz
    escribirF bHandler, SIZEOF espacio, espacio
    mov ax,100
    mov ah,0
    mov punteo2,al ;;ESTO PARA OBTENER EL PUNTAJE
    mov bprec1,0
    mov bprec2,0
    mov verfact,0
    mov contador,0
    mov ultimoValor,0
    mov ultimoValor2,0
    mov haynumero,0
    mov primerNumero,0
    xor bx,bx
    xor si,si
    ESTADO:
        mov esneg,0 
        call copiarPost
        xor bx,bx
        xor dx,dx
        xor ax,ax
        mov ah,0
        mov cx,bufferPostfija[si]
        mov ah,cl
        inc si 
        mov cx,bufferPostfija[si]
        mov contsi,si
        mov al,cl
        push ax
        
        pop ax
        cmp al,24h
        je FINAL
        cmp ax,999
        jbe NUM
        cmp ax,1007;.
        je PUNTO
        cmp ax,1002;*
        je MULT
        cmp ax,1000;+
        je SUMA
        cmp ax,1001;-
        je RESTA
        cmp ax,1003;/
        je DIVISION
        cmp ax,1004;%
        je MODU
        cmp ax,1005;**
        je POT
        cmp ax,1006;!
        je FACTORIAL
    NUM:
        
    NUMERO:
        mov temp,ax;NUMERO EN BX
        push ax;ingresar numero
        inc contador
        escribirF bHandler, SIZEOF lblnum1, lblnum1
        xor ax,ax
        mov al,contador
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF lblnum2, lblnum2
        xor ax,ax
        push si
        mov ax,temp
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF lblnum3, lblnum3
        escribirF bHandler, SIZEOF espacio, espacio
        ;mov cx,ax;
        
        mov si,contsi
        inc si
        
        inc haynumero
        cmp haynumero,2
        je NUMEROSSEGUIDOS
        cmp haynumero,3
        je TRESNUM
        jmp ESTADO
        NUMEROSSEGUIDOS:
        cmp ultimoValor,1
        je UMULT
        cmp ultimoValor,2
        je UMULT
        cmp ultimoValor,3
        je UPOT
        jmp ESTADO
        UMULT:
            mov bprec1,0
            mov bprec2,0
            ;dec haynumero
            jmp ESTADO
        UPOT:
            mov bprec2,0
            ;dec haynumero
            jmp ESTADO
        TRESNUM:
        mov primerNumero,3
        cmp ultimoValor,1
        je UMULT
        cmp ultimoValor,2
        je UMULT
        cmp ultimoValor,3
        je UPOT
        jmp ESTADO
        
    PUNTO:
        xor cx,cx
        inc si
        mov cx,bufferPostfija[si]
        mov dh,cl
        inc si 
        mov cx,bufferPostfija[si]
        mov dl,cl
        ;NUMERO DECIMAL EN DX
        cmp dx,9
        jbe UNDECIMAL
        ;pop eax;SE OBTIENE EL ULTIMO NUMERO DE LA PILA
        ;add eax,edx
        jmp NUMERO
    UNDECIMAL:
        mov bx,0ah;10
        mov ax,dx
        mul bx    
        jmp NUMERO
    MULT:
        mov haynumero,0
        escribirOperador bHandler,2Ah
        pop ax;num2
        mov num2,ax
        pop cx;num1
        mov num1,cx
        mov ax,cx
        push cx
        call hextodec
        pop cx
        mov ah,02h
        mov dl,2Ah
        int 21h
        push ax
        mov ax,num2
        push cx
        call hextodec
        pop cx
        print msgrespuesta
        pop ax       
        mov cx,num1
        mov ax,num2
        mul cx
        push ax
        mov buffer,ax
        ;push si;
        ;hextodec;
        ;pop si;
        push si
            call limpiarBufferNum1
            obtenerTexto bufferNum1
            cmp bufferNum1[0],'-'
            je NEGATIVO2
            jmp CCC2
        NEGATIVO2:
            mov esneg,1
        CCC2:
            call convertir        
            mov cx,bufferRespuesta
            mov ax,buffer
            cmp ax,cx
            je CORRECTA
            print msgincorrecta
            cmp buffer,8000h
            ja CONVNEG2
            jmp CONVSIG2
        CONVNEG2:
            neg buffer
            push ax
            push dx
            mov ah,02h
            mov dl,2Dh
            int 21h
            pop dx
            pop ax
        CONVSIG2:
            mov ax,buffer
            call hextodec
            getChar
            ;print salto
            jmp REGRESARMUL        
    REGRESARMUL:
        pop si
        mov si,contsi
        inc si
        jmp ESTADO
    SUMA:
        mov haynumero,0
        escribirOperador bHandler,2Bh
        
        pop ax;num2
        mov num2,ax
        pop cx;num1
        mov num1,cx
        mov ax,cx
        push cx
        call hextodec
        pop cx
        mov ah,02h
        mov dl,2Bh
        int 21h
        push ax
        mov ax,num2
        push cx
        call hextodec
        pop cx
        print msgrespuesta
        pop ax

        mov cx,num1
        mov ax,num2
        add ax,cx
        push ax
        mov buffer,ax
        ;push si;
        ;hextodec;
        ;pop si;
        push si
            call limpiarBufferNum1
            obtenerTexto bufferNum1
            cmp bufferNum1[0],'-'
            je NEGATIVO1
            jmp CCC1
        NEGATIVO1:
            mov esneg,1
        CCC1:
            call convertir
          
            mov cx,bufferRespuesta
            mov ax,buffer
            cmp ax,cx
            je CORRECTA1
            print msgincorrecta
            cmp buffer,8000h
            ja CONVNEG1
            jmp CONVSIG1
        CONVNEG1:
            neg buffer
            push ax
            push dx
            mov ah,02h
            mov dl,2Dh
            int 21h
            pop dx
            pop ax
        CONVSIG1:
            mov ax,buffer
            call hextodec
            getChar
            jmp REGRESARSUM
          
    REGRESARSUM:
        pop si
        mov si,contsi
        inc si
        jmp ESTADO
    RESTA:
        mov haynumero,0
        escribirOperador bHandler,2Dh
        
        pop ax;num2
        mov num2,ax
        pop cx;num1
        mov num1,cx
        mov ax,cx
        push cx
        call hextodec
        pop cx
        mov ah,02h
        mov dl,2Dh
        int 21h
        push ax
        mov ax,num2
        push cx
        call hextodec
        pop cx
        print msgrespuesta
        pop ax

        mov cx,num2
        mov ax,num1

        sub ax,cx
        push ax
        mov buffer,ax
        ;push si;
        ;hextodec;
        ;pop si;
        push si
            call limpiarBufferNum1
            obtenerTexto bufferNum1
            cmp bufferNum1[0],'-'
            je NEGATIVO
            jmp CCC
        NEGATIVO:
            mov esneg,1
        CCC:
            call convertir
           
            mov cx,bufferRespuesta
            mov ax,buffer
            cmp ax,cx
            je CORRECTA2
            print msgincorrecta
            cmp buffer,8000h
            ja CONVNEG
            jmp CONVSIG
        CONVNEG:
            neg buffer
            push ax
            push dx
            mov ah,02h
            mov dl,2Dh
            int 21h
            pop dx
            pop ax
        CONVSIG:
            mov ax,buffer
            call hextodec
            getChar
            ;print salto
            jmp REGRESARREST
            
    REGRESARREST:
        pop si
        mov si,contsi
        inc si
        jmp ESTADO
    DIVISION:
        mov haynumero,0
        escribirOperador bHandler,2Fh
        
        
        pop ax;num2
        mov num2,ax
        pop cx;num1
        mov num1,cx
        mov ax,cx
        push cx
        call hextodec
        pop cx
        mov ah,02h
        mov dl,2Fh
        int 21h
        push ax
        mov ax,num2
        push cx
        call hextodec
        pop cx
        print msgrespuesta
        pop ax

        mov cx,num2
        mov ax,num1

        div cl
        mov ah,0
        push ax
        mov buffer,ax
        ;push si;
        ;hextodec;
        ;pop si;
        push si
            call limpiarBufferNum1
            obtenerTexto bufferNum1
            cmp bufferNum1[0],'-'
            je NEGATIVO3
            jmp CCC3
        NEGATIVO3:
            mov esneg,1
        CCC3:
            call convertir
            ;mov cx,bufferRespuesta
            ;mov ah,02h;
            ;mov dl,cl;
            ;int 21h;
            ;getChar;
            mov cx,bufferRespuesta
            mov ax,buffer
            cmp ax,cx
            je CORRECTA3
            print msgincorrecta
            cmp buffer,8000h
            ja CONVNEG3
            jmp CONVSIG3
        CONVNEG3:
            neg buffer
            push ax
            push dx
            mov ah,02h
            mov dl,2Dh
            int 21h
            pop dx
            pop ax
        CONVSIG3:
            mov ax,buffer
            call hextodec
            getChar
            ;print salto
            jmp REGRESARDIV
            
    REGRESARDIV:
        pop si
        mov si,contsi
        inc si
        jmp ESTADO
    MODU:
        mov haynumero,0
        escribirOperador bHandler,25h
        
        
        pop ax;num2
        mov num2,ax
        pop cx;num1
        mov num1,cx
        mov ax,cx
        push cx
        call hextodec
        pop cx
        mov ah,02h
        mov dl,25h
        int 21h
        push ax
        mov ax,num2
        push cx
        call hextodec
        pop cx
        print msgrespuesta
        pop ax

        mov cx,num2
        mov ax,num1

        div cl
        mov al,ah
        mov ah,0
        push ax
        mov buffer,ax
        ;push si;
        ;hextodec;
        ;pop si;
        push si
            call limpiarBufferNum1
            obtenerTexto bufferNum1
            cmp bufferNum1[0],'-'
            je NEGATIVO4
            jmp CCC4
        NEGATIVO4:
            mov esneg,1
        CCC4:
            call convertir
            ;mov cx,bufferRespuesta
            ;mov ah,02h;
            ;mov dl,cl;
            ;int 21h;
            ;getChar;
            mov cx,bufferRespuesta
            mov ax,buffer
            cmp ax,cx
            je CORRECTA4
            print msgincorrecta
            cmp buffer,8000h
            ja CONVNEG4
            jmp CONVSIG4
        CONVNEG4:
            neg buffer
            push ax
            push dx
            mov ah,02h
            mov dl,2Dh
            int 21h
            pop dx
            pop ax
        CONVSIG4:
            mov ax,buffer
            call hextodec
            getChar
            ;print salto
            jmp REGRESARMOD
            CORRECTA4:
                print msgcorrecta
                mov ah,0
                mov al,punteo2
                call hextodec
                getChar
                mov cl,puntaje
                mov al,punteo2
                add cl,al
                mov puntaje,cl
    REGRESARMOD:
        pop si
        mov si,contsi
        inc si
        jmp ESTADO
    POT:
        mov haynumero,0
        inc contador
        escribirF bHandler, SIZEOF lblnum1, lblnum1
        xor ax,ax
        mov al,contador
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF lblnum4, lblnum4
        push si
        call limpiarTemp1
        mov temp1[0],'*'
        xor si,si
            LOOP100:
            cmp temp1[si],24h
            je ESCRIBIR100
            inc si
            jmp LOOP100
            ESCRIBIR100:
            escribirF bHandler, si, temp1
        xor si,si
            LOOP101:
            cmp temp1[si],24h
            je ESCRIBIR101
            inc si
            jmp LOOP101
            ESCRIBIR101:
            escribirF bHandler, si, temp1
        pop si
        escribirF bHandler, SIZEOF lblnum5, lblnum5
        escribirF bHandler, SIZEOF espacio, espacio
        escribirF bHandler, SIZEOF lblnum1, lblnum1
        xor ax,ax
        mov al,contador
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF lbldirIzq, lbldirIzq
        xor ax,ax
        mov al,contador
        sub al,2
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF espacio, espacio
        escribirF bHandler, SIZEOF lblnum1, lblnum1
        xor ax,ax
        mov al,contador
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF lbldirDer, lbldirDer
        xor ax,ax
        mov al,contador
        dec al
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF espacio, espacio
        inc bprec1
        inc bprec2
        push bx
        mov bl,ultimoValor
        mov ultimoValor2,bl
        pop bx
        mov ultimoValor,3

        pop ax;num2
        mov num2,ax
        pop cx;num1
        mov num1,cx
        mov ax,cx
        push cx
        call hextodec
        pop cx
        mov ah,02h
        mov dl,2Ah
        int 21h
        mov ah,02h
        mov dl,2Ah
        int 21h
        push ax
        mov ax,num2
        push cx
        call hextodec
        pop cx
        print msgrespuesta
        pop ax

        mov cx,num2
        mov ax,num1

        dec cx
        mov bx,ax
    LOOPPOT:
        mul bx
        loop LOOPPOT
        push ax
        mov buffer,ax
        ;push si;
        ;hextodec;
        ;pop si;

        push si
            call limpiarBufferNum1
            obtenerTexto bufferNum1
            cmp bufferNum1[0],'-'
            je NEGATIVO5
            jmp CCC5
        NEGATIVO5:
            mov esneg,1
        CCC5:
            call convertir
            ;mov cx,bufferRespuesta
            ;mov ah,02h;
            ;mov dl,cl;
            ;int 21h;
            ;getChar;
            mov cx,bufferRespuesta
            mov ax,buffer
            cmp ax,cx
            je CORRECTA5
            print msgincorrecta
            cmp buffer,8000h
            ja CONVNEG5
            jmp CONVSIG5
        CONVNEG5:
            neg buffer
            push ax
            push dx
            mov ah,02h
            mov dl,2Dh
            int 21h
            pop dx
            pop ax
        CONVSIG5:
            mov ax,buffer
            call hextodec
            getChar
            ;print salto
            jmp REGRESARPOT
            CORRECTA5:
                print msgcorrecta
                mov ah,0
                mov al,punteo2
                call hextodec
                getChar
                mov cl,puntaje
                mov al,punteo2
                add cl,al
                mov puntaje,cl
    REGRESARPOT:
        pop si
        mov si,contsi
        inc si
        jmp ESTADO
    FACTORIAL:
        mov haynumero,0
        inc contador
        escribirF bHandler, SIZEOF lblnum1, lblnum1
        xor ax,ax
        mov al,contador
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF lblnum2, lblnum2
        push si
        call limpiarTemp1
        mov temp1[0],'!'
        xor si,si
            LOOP103:
            cmp temp1[si],24h
            je ESCRIBIR103
            inc si
            jmp LOOP103
            ESCRIBIR103:
            escribirF bHandler, si, temp1
        pop si
        escribirF bHandler, SIZEOF lblnum3, lblnum3
        escribirF bHandler, SIZEOF espacio, espacio
        escribirF bHandler, SIZEOF lblnum1, lblnum1
        xor ax,ax
        mov al,contador
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF flechota, flechota
        escribirF bHandler, SIZEOF lblnum1, lblnum1
        xor ax,ax
        mov al,contador
        dec al
        push si
        hextodec3 bHandler
        pop si
        escribirF bHandler, SIZEOF espacio, espacio
        inc verfact


        pop ax;num2
        mov num2,ax
        push cx
        call hextodec
        pop cx
        mov ah,02h
        mov dl,21h
        int 21h
        print msgrespuesta

        mov cx,num2

        cmp cx,0
        je CERO
        mov ax,1;
        dec cx;n-1;4
    LOOPFACT:
        inc cx
        mul cx
        dec cx
        loop LOOPFACT
        push ax
        mov buffer,ax
        jmp INCFACT
    CERO:
        mov cx,1
        push cx
        mov buffer,cx
    INCFACT:
        ;push si;
        ;hextodec;
        ;pop si;
        push si
            call limpiarBufferNum1
            obtenerTexto bufferNum1
            call convertir
            ;mov cx,bufferRespuesta
            ;mov ah,02h;
            ;mov dl,cl;
            ;int 21h;
            ;getChar;
            mov cx,bufferRespuesta
            mov ax,buffer
            cmp ax,cx
            je CORRECTA6
            print msgincorrecta
            mov ax,buffer
            call hextodec
            getChar
            ;print salto
            jmp REGRESARFACT
            CORRECTA6:
                print msgcorrecta
                mov ah,0
                mov al,punteo2
                call hextodec
                getChar
                mov cl,puntaje
                mov al,punteo2
                add cl,al
                mov puntaje,cl
    REGRESARFACT:
        pop si
        mov si,contsi
        inc si
        jmp ESTADO
    FINAL:
        mov ax,buffer
endm

crearF macro ruta, handle
    mov ah,3ch
    mov cx,00h
    lea dx,ruta
    int 21h
    jc Error4
    mov handle,ax
endm
obtenerRuta macro buffer
    LOCAL LIM, obtenerChar, FinOT
        mov bx,0
        mov cx,50
    LIM:
        mov buffer[bx],'$'
        inc bx
        loop LIM
        xor si,si
    obtenerChar:
        scanner
        cmp al,64
        je obtenerChar
        cmp al,0dh
        je FinOT
        mov buffer[si],al
        inc si
        jmp obtenerChar
    FinOT:
    mov al,00h
    mov buffer[si],al
endm
abrirArchivo macro buffer,handler
    mov ah,3dh
    mov al,02h
    lea dx,buffer
    int 21h
    jc Error1
    mov handler,ax
endm
cerrarArchivo macro handler
    mov ah,3eh
    mov bx,handler
    int 21h
    jc Error2
endm
leerm macro handler,buffer,numbytes
    mov ah,3fh
    mov bx,handler
    mov cx,numbytes
    lea dx,buffer
    int 21h
    jc Error3
endm
print macro mensaje    
    push ax
    push dx
    lea dx, mensaje  ;ubicate en la variable mensaje, muevelo al registro de datos.
    mov ah, 09h;toma la instrucion 09 para mostrar en pantalla y muevela al registro acumulador en la parte alta
    int 21h ;interrumpe al SO para que muestre lo que esta guardado en la variable mensaje.
    pop dx
    pop ax
endm

escribirF macro handle,numbytes,buffer  
    push ax
    push bx
    push cx
    push dx
    mov ah,40h
    mov bx,handle
    mov cx,numbytes
    lea dx,buffer
    int 21h
    jc Error5
    pop dx
    pop cx
    pop bx
    pop ax
endm
scanner macro
    mov ah,01h ;capturar con eco
    int 21h
endm
