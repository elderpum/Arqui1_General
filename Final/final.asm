include macros.asm
.model small

;----------------SEGMENTO DE PILA---------------------

.stack

;----------------SEGMENTO DE DATO---------------------
.data
encab db 0ah,0dh, '---------------------------------------------',0ah,0dh,'Universidad de San Carlos de Guatemala', 0ah,0dh,'Facultad de Ingenieria',0ah,0dh,'Ciencias y Sistemas',0ah,0dh,'Arquitectura de Computadores y Ensambladores 1',0ah,0dh,'Nombre: Elder Anibal Pum Rojas',0ah,0dh,'Carnet: 201700761',0ah,0dh,'Seccion: B',0ah,0dh,'--------------------------------------------',0ah,0dh,'$'

saltoLinea db 0Ah,0Dh,"$"
menuprincipal db 0ah,0dh, '----------------------MENU--------------------','$'
mensaje1 db 0ah,0dh, 'Division de Numeros Enteros','$'
ingnum1 db 0ah,0dh, 'Ingrese el primer numero: ','$'
ingnum2 db 0ah,0dh, 'Ingrese el segundo numero: ','$'
textoresultado db 0ah,0dh, 'El resultado es: ','$'
textoresiduo db 0ah,0dh, 'El residuo es: ','$'

;contadores
num1 dw 0
num2 dw 0
resultado dw 0
residuo dw 0
resultadorDivisionDecimal dw 0
resultadorDivisionEntero dw 0

;arrays
arraynum1 db 10 dup('$'),'$'
arraynum2 db 4 dup('$'),'$'
arrayresp db 10 dup('$'),'$'
arrayresd db 5 dup('$'),'$'
arrayaux db 3 dup('$')
punto db '.','$'

;----------------SEGMENTO DE CODIGO---------------------
.code
main proc

    print encab
    print saltoLinea
    print menuprincipal
    print saltoLinea
    print mensaje1
    print saltoLinea

    print ingnum1
    obtenerTexto arraynum1
    print saltoLinea

    print ingnum2
    obtenerTexto arraynum2
    print saltoLinea

    StringToInt arraynum1
    mov num1, ax
    StringToInt arraynum2
    mov num2, ax

    DivisionConDecimal num1, num2
    IntToString resultadorDivisionEntero, arrayresp
    
    print textoresultado
    print arrayresp
    print punto
    print arrayresd
    getChar

    close

main endp
end main	