include macros.asm ;archivo con los macros a utilizar

.model small
;----------------SEGMENTO DE PILA---------------------
.stack
;----------------SEGMENTO DE DATO---------------------
.data
salt db 0ah,0dh, ' ' , '$'
enc1 db 0ah,0dh, '1.) Graficar' ,  0ah,0dh, '2.) Salir'  , '$'
encab db 0ah,0dh, '---------------------------------------------',0ah,0dh,'Universidad de San Carlos de Guatemala', 0ah,0dh,'Facultad de Ingenieria',0ah,0dh,'Ciencias y Sistemas',0ah,0dh,'Arquitectura de Computadores y Ensambladores 1',0ah,0dh,'Nombre: Elder Anibal Pum Rojas',0ah,0dh,'Carnet: 201700761',0ah,0dh,'Seccion: B',0ah,0dh,'--------------------------------------------',0ah,0dh,'$'
;----------------SEGMENTO DE CODIGO---------------------

.code
main proc 
    print encab
    getChar
    MenuPrincipal:
        print enc1          
        print salt   
        getChar 
        cmp al , '1'
        je Video1         
        cmp al , '2' 
        je Salir  
        jmp MenuPrincipal 

    Video1: 
        ModoVideo 
        pintar_linea 5

        posicionarCursor 20,59
        imprimirVideo 54, 10 

        posicionarCursor 20,60
        imprimirVideo 49, 10 

        getChar
        ModoTexto 
        jmp MenuPrincipal

    Salir: 
        close

main endp
end main


