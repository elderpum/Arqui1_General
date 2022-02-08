#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Max72xxPanel.h>

#define POT A2

const int MOV = 11;
const int DIR = 12;
const int MODE = 13;
const int pinCS = 10;
const int numeroMatricesHorizontales =2;
const int numeroMatricesVerticales = 1;
const int I0 = 5;
const int I1 = 6;
const int I2 = 7;





Max72xxPanel matriz = Max72xxPanel (pinCS,numeroMatricesHorizontales,numeroMatricesVerticales);
 
const int tiempo = 100; //milisegundos 
const int espacio = 1; //1 columna de espacio entre cada led 
const int ancho = 5 + espacio;  //El ancho de la fuente será de 5 píxeles, cada letra va a ocupar en total 5 columnas 

void setup() {
  matriz.setIntensity(7); 
  matriz.setPosition(0, 0, 0); 
  matriz.setRotation(0,3); 

  pinMode(MOV, INPUT);
  pinMode(DIR, INPUT);
  pinMode(MODE, INPUT);

  pinMode(I0, OUTPUT);
  pinMode(I1, OUTPUT);
  pinMode(I2, OUTPUT);
  

  //pinMode(POT, INPUT);

  Serial.begin(9600);
}

String mensaje;
int incomingByte;
int velocidad =1;


void loop() {
  int mov = digitalRead(MOV);
  int dir = digitalRead(DIR);
  int mode = digitalRead(MODE);


  leerPotenciometro();
  
  if ( mode == 0){
    mensaje = "P1\40\x2D GRUPO1 - SECCION B";
  } else {
    if(Serial.available() > 0){
      Serial.print("Ingrese un mensaje\n");
      mensaje = Serial.readString();
      Serial.print("Su mensaje es: " + mensaje);
    }
  }
  
  if(mov == 0){
    for(int i=0; i< mensaje.length(); i++){
      matriz.drawChar(3,1,mensaje[i],HIGH, LOW, 1);
      matriz.write();

      delay(750);
      matriz.fillScreen(LOW);
    }
  } else {
    // Mostrar moviéndose
    if (dir==0){
      for (int i =ancho * mensaje.length()+ matriz.width() - 1 - espacio ; i >0 ; i-= velocidad){
        matriz.fillScreen(LOW); //Apagamos todos los LED. función dedicada para limpiar la pantalla.   
        //LETRA POR LETRA
        int letra = i/ ancho;
        int x = (matriz.width() -1) - i %ancho;
        int y = (matriz.height() -8) / 2;
        while (x + ancho - espacio >= 0 && letra >= 0) {
          if(letra <  mensaje.length()){
            matriz.drawChar(x,y,mensaje[letra],HIGH, LOW, 1); 
          }
          letra--;
          x -= ancho;
        }
        matriz.write(); 
        delay(tiempo); 
    }
    } else {
      for (int i =0; i < ancho * mensaje.length()+ matriz.width() - 1 - espacio ; i+= velocidad){
        matriz.fillScreen(LOW); //Apagamos todos los LED. función dedicada para limpiar la pantalla.   
        //LETRA POR LETRA
        int letra = i/ ancho;
        int x = (matriz.width() -1) - i %ancho;
        int y = (matriz.height() -8) / 2;
        while (x + ancho - espacio >= 0 && letra >= 0) {
          if(letra <  mensaje.length()){
            matriz.drawChar(x,y,mensaje[letra],HIGH, LOW, 1); 
          }
          letra--;
          x -= ancho;
        }
        matriz.write(); 
        delay(tiempo); 
    }
  }
  
  
  }

}
void leerPotenciometro(){
  float val_pot = analogRead(A0);
  if ( val_pot < 255 && val_pot >= 0 ) {
    velocidad = 1;
    digitalWrite(I0, HIGH);
    digitalWrite(I1, LOW);
    digitalWrite(I2, LOW);
  } else if ( val_pot < 510 && val_pot >= 255 ) {
    velocidad = 2;
    digitalWrite(I0, LOW);
    digitalWrite(I1, HIGH);
    digitalWrite(I2, LOW);
  } else if ( val_pot < 765 && val_pot >= 510 ) {
    velocidad = 3;
    digitalWrite(I0, HIGH);
    digitalWrite(I1, HIGH);
    digitalWrite(I2, LOW);
  } else if ( val_pot < 1020 && val_pot >= 765 ) {
    velocidad = 4;
    digitalWrite(I0, LOW);
    digitalWrite(I1, LOW);
    digitalWrite(I2, HIGH);
  } else if ( val_pot >= 1020 ) {
    velocidad = 5;
    digitalWrite(I0, HIGH);
    digitalWrite(I1, LOW);
    digitalWrite(I2, HIGH);
  }
}
