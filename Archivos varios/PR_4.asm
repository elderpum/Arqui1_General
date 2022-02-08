;===============SECCION DE MACROS ===========================
include m.asm



;================= DECLARACION TIPO DE EJECUTABLE ============
.model small 
.stack 100h 
.data 
;================ ENCABEZADO ========================

titulo db '================================================',0ah,0dh,
'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0ah, 0dh,
'FACULTAD DE INGENIERIA',0ah, 0dh,
'CIENCIAS Y SISTEMAS',0ah, 0dh,
'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',0ah, 0dh,
'NOMBRE: CARLOS ROBERTO JIMENEZ PEREZ',0ah, 0dh,
'CARNET: 201504143',0ah, 0dh,
'SECCION: B',0ah, 0dh,
          '================================================',0ah,0dh,
 '$'

 ;================ REPORTES ========================
hora db 5 dup('$'),'$'

repo db 65 dup('$'),'$'
html1 db '<html>',0ah,'<head>',0ah,'<title> 251504143 </title>',0ah,'</head>',0ah,
'<body style = ',22h,'background: black',22h,'>',0ah,'<center>',0ah,
'<h1 style = ',22h,'color: white; font-family: Corbel;',22h,'> JUEGO ACTUAL </h1>',0ah,
'<h2 style = ',22h,'color: white; font-family: Corbel;',22h,'> HORA ACTUAL: ' 

html2 db ' - 19/03/19 </h2>',0ah,
'<table style = ',22h,'background: white; align-items: center; border-collapse: separate;',22h,'>',0ah,'$'

html_tab db '<tr>',0ah,'<tbody style=',22h,'background: black;',22h,'>',0ah,'$'

html_t1 db '<td style= ',22h,'margin: 25px; padding: 25px; font-size: 15px; color: white; font-family: Corbel;',22h,'>','$'
html_t2 db '<td style= ',22h,'margin: 25px; padding: 25px; font-size: 15px; color: white; font-family: Corbel; background: white',22h,'>','$'
html_c db '</td>',0ah,'$'

html_tabb db '<td style= ',22h,'margin: 25px; padding: 25px; font-size: 15px; color: white; font-family: Corbel; background: white',22h,'>',0ah,'</tbody>',0ah,'</tr>',0ah,'$'

html_tabc db '</tbody>',0ah,'</tr>',0ah,0ah,'$'

dato db 2 dup('$'),'$'
auxr db 00, '$'
conr db 00, '$'

;================ VARIBLES VARIAS ========================
encab db 0ah,0dh, '1) Iniciar Juego', 0ah,0dh,'2) Cargar Juego',0ah,0dh,'3) Salir',0ah,0dh,'$'
tablero db 64 dup(' '),'$'
entrada db 50 dup('$'),'$'
informacion db 65 dup('$'),'$'
handlerentrada dw ?
msgJuego db 0ah, 0dh, 'INICIANDO JUEGO...','$'
msgBlanco db 0ah, 0dh,0ah, 0dh, 'TURNO BLANCAS: ','$'
msgNegro db 0ah, 0dh,0ah, 0dh, 'TURNO NEGRO: ','$'
comando1 db 'EXIT','$'
comando2 db 'SAVE','$'
comando3 db 'SHOW','$'
mensaje db 10 dup('$'),'$'
actual db 10 dup('$'),'$'	
msgError db 0ah, 0dh, 'NO EXISTE EL COMANDO INGRESADO','$'
msgSalir db 0ah, 0dh, 'SALIENDO DEL JUEGO...','$'
msgAbrir db 0ah, 0dh, 'INGRESE NOMBRE DEL ARCHIVO: ','$'
msgEsc db 0ah, 0dh, 'ARCHIVO ESCRITO CON EXITO','$'
errAbrir db 0ah, 0dh, 'ERROR AL ABRIR EL ARCHIVO','$'
errEsc db 0ah, 0dh, 'ERROR AL ESCRIBIR EL ARCHIVO','$'
msgLeer db 0ah, 0dh, 'ARCHIVO LEIDO: ','$'
errLeer db 0ah, 0dh, 'ERROR AL LEER EL ARCHIVO','$'
errCerrar db 0ah, 0dh, 'ERROR AL CERRAR EL ARCHIVO','$'
msgWard db 0ah, 0dh, 'JUEGO GUARDADO CON EXITO','$'
msgSave db 0ah, 0dh, 'INGRESE NOMBRE PARA GUARDAR: ','$'
errSave db 0ah, 0dh, 'ERROR AL GUARDAR EL ARCHIVO','$' 
msgShow db 0ah, 0dh, 'SE GENERO EL HTML CORRECTAMENTE','$'
msgRand db 0ah, 0dh, 'SUPUESTAMENTE AQUI HARA ALGO','$'
msgPos db 0ah, 0dh, 'POSICION INCORRECTA','$'
msgPos1 db 0ah, 0dh, 'POSICION CORRECTA','$'
bug db 0ah,0dh, 'ENTRAMOS','$'
barrita db 0ah,0dh,32,32,32,32,'-------------------------','$'
sangria db 32,32,32,32,'$'
salt db 0ah,0dh,'$'
var db 0, '$'
cont db 49, '$'
fichB db 0Ch, '$'
fichN db 0Ch, '$'
c1 db 0,'$'
c2 db 0,'$'
casillaDestino db 0,'$'
casillaOrigen db 0,'$'
c3 db 0,'$'
c4 db 0,'$'
c5 db 0,'$'

auxiliar db 00h, '$'
auxiliar2 db 00h, '$'

contr db 00h; '$'

valido db 00h,'$'

turnos db 31h,'$'
.code ;segmento de código

;================== SECCION DE CODIGO ===========================
	main proc 
		Menu:
			print titulo
			print encab
			getChar
			cmp al,49
			je JUEGO
			cmp al,50
			je CARGAR
			cmp al,51
			je SALIR
			jne ERROR
		JUEGO:
			print msgJuego
			print salt
			print salt
			LimpiarTablero tablero
			FichasBlancas tablero
			FichasNegras tablero
		JUGABILIDAD:
			ImpTablero tablero
			Jugando 
			print salt
			MOV al, fichB
			cmp al, 00h
			je SALIR
			MOV al, fichN
			cmp al, 00h
			je SALIR
			JMP JUGABILIDAD
		CARGAR:
			print msgAbrir
			LimpiarEntrada entrada
			RutaDefinida entrada
			ObtenerRuta entrada
			Abrir entrada, handlerentrada

			LimpiarInformacion informacion
			Leer handlerentrada, informacion

		    LlenarTablero

			Cerrar handlerentrada
			print msgJuego
			print salt
			print salt
			JMP JUGABILIDAD
		SALIR: 
			MOV ah,4ch 
			xor al,al
			int 21h
		ERROR:
			print msgError
			print salt
			JMP Menu

	main endp
;================ FIN DE SECCION DE CODIGO ========================
end