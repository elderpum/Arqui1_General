#include <Wire.h>
#include <LiquidCrystal_I2C.h>    //Libreria para display lcd por I2C

#define TERMOSTATO 0x48           //Definir puerto a utilizar con el termometro
#define DISPL_1 0x20               //Definir puerto a utilizar con el DISPLAY


void setup() {
  
Wire.begin();                               //inicializa la libreria WIRE
Wire.beginTransmission(TERMOSTATO);         //Inicia la transmision de datos
Wire.write(0xAC);                           //envia comando  de configuracion registro)
Wire.write(0);                              //
Wire.beginTransmission(TERMOSTATO);         //fin de la transmision de datos
Wire.write(0xEE);                           
Wire.endTransmission(); 
}

void loop() { 
delay(500);   
  int c_temp = Temperatura();             //llamo al metodo Temperatura para obtener el valor
  Wire.beginTransmission(23);             //inicio la transmision
  Wire.write(c_temp);                     //envio el valor 
  Wire.endTransmission();                 //cierro la transmision
}

int  Temperatura(){
  int temperatura=0;
  Wire.beginTransmission(TERMOSTATO);     // conectando con sensor DS1621
  Wire.write(0xAA);                       // comando: lectura de temperatura
  Wire.endTransmission(false);            // repetir lectura en caso de que falle
  Wire.requestFrom(TERMOSTATO, 1);        // obtenfo la informacion de la cantidad de bytes
   temperatura = Wire.read();             // leer el registro de temperatura
  return temperatura;                     // retornar valor con la temperatura
}
