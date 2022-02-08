#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Max72xxPanel.h>
//Din - Mosi (Pin 11)
//Cs - SS (Pin 10)
//CLK - Sck (Pin 13)

const int pinCS = 10;
const int numeroMatricesHorizontales =2;
const int numeroMatricesVerticales = 1;
/* Para crear  un nuevo controlador necesitamos los 
    * Parámetros:
    * Pin CS
    * El número de pantallas horizontalmente
    * El número de pantallas verticalmente
     */
Max72xxPanel matriz = Max72xxPanel (pinCS,numeroMatricesHorizontales,numeroMatricesVerticales);
String mensaje = "P1 – GRUPO 1 - SECCION B"; 
const int tiempo = 100; //milisegundos 
const int espacio = 1; //1 columna de espacio entre cada led 
const int ancho = 5 + espacio;  //El ancho de la fuente será de 5 píxeles, cada letra va a ocupar en total 5 columnas 

void setup() {
  matriz.setIntensity(7); 
  matriz.setPosition(0, 0, 0); 
  matriz.setRotation(0,3); 
}

void loop() {
  for (int i =0; i < ancho * mensaje.length()+ matriz.width() - 1- espacio ; i++){
    matriz.fillScreen(LOW); //Apagamos todos los LED. función dedicada para limpiar la pantalla.   
    //LETRA POR LETRA
    int letra = i/ ancho;
    int x = (matriz.width() -1) - i %ancho;
    int y = (matriz.height() -8) / 2; //sirve para centrar el texto verticalmente.
    while (x + ancho - espacio >= 0 && letra >= 0) {
      if(letra <  mensaje.length()){
        matriz.drawChar(x,y,mensaje[letra],HIGH, LOW, 1); //llenamos el búfer de mapa de bits con la imagen, de la letra 
      }
      letra--;
      x -= ancho;
    }
    matriz.write(); // Enviar mapa de bits para mostrar
  /*
    * Una vez que haya terminado de llenar el búfer de mapa de bits con su imagen,
    * enviarlo a la pantalla (s).
    */ 
    delay(tiempo); //espera 100 milisegundos
  }

}
