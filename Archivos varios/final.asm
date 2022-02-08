include macros3.asm ;archivo con los macros a utilizar

.model small
;----------------SEGMENTO DE PILA---------------------

.stack
;----------------SEGMENTO DE DATO---------------------

.data

numero1 dw 0
numero2 dw 0
resultado dw 0
residuo dw 0
resultadorDivisionEntero dw 0
resultadorDivisionDecimal dw 0

Snumero1 db 3 dup('$'),'$'
Snumero2 db 4 dup('$'),'$'
Respuesta db 10 dup('$'),'$'
SResiduo db 5 dup('$'),'$'
SAuxililar db 3 dup('$')
Punto db '.','$'

ingrese1 db 0ah,0dh, 'Ingrese el primer numero: ','$'
ingrese2 db 0ah,0dh,  'Ingrese el segundo numero: ','$'
msj db 0ah,0dh, 'El resultado es: ','$'
msj2 db 0ah,0dh,'Residuo: ', '$'
;----------------SEGMENTO DE CODIGO---------------------

.code
main proc

    
    print ingrese1
    obtenerTexto Snumero1
    print ingrese2
    obtenerTexto Snumero2

    StringToInt Snumero1
    mov numero1,ax
    StringToInt Snumero2
    mov numero2,ax

    DivisionConDecimal numero1, numero2

    IntToString resultadorDivisionEntero, Respuesta

    print msj
    print Respuesta
    print Punto
    print SResiduo

    getChar

    close

main endp
end main