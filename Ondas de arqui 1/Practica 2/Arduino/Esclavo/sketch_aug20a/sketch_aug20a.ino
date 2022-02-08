#include <Wire.h>
#include <LiquidCrystal.h>

#define DS1621_ADDRESS 0*48

LiquidCrystal lcd2{2,3,4,5,6,7}; //LCD 2 y su configuracion de pines

void setup() {
  Wire.begin();
  //Inicializando el sensor de temperatura
  Wire.beginTransmission(DS1627_ADDRESS);
  Wire.write(0xAC);
  Wire.beginTransmission(DS1621_ADDRESS);
  Wire.write(0xEE);
  Wire.onReceive(mostrarTemperatura); //Para escuchar al master
  Wire.endTransmission();
}

char cBuffer[8];
int temperatura;

void loop() {
  delay(1000);
  int16_t temperaturaC = get_temperature();
  if (temperaturaC <= 18){
    if (temperaturaC < 0) {
      temperaturaC = abs(temperaturaC);
      sprintf(cBuffer, "-%02u.%1u%cC", temperaturaC / 10, temperaturaC % 10, 223);
      //Igual lo unico aca es para mostrar bien cuando la temperatura este por debajo de 0 grados celsius
      //Sigue sin girar el motor
    }
    else {
      temperaturaC = abs(temperaturaC);
      sprintf(cBuffer, "%02u.%1u%cC", temperaturaC / 10, temperaturaC % 10, 223);
      //Aca la validacion cuando el sensor ande entre los 0 y los 18 grados
      //No se gira ningun motor 
    }
  }
  else if (temperaturaC >= 18 & <= 25){
    temperaturaC = abs(temperaturaC);
    sprintf(cBuffer, "%02u.%1u%cC", temperaturaC / 10, temperaturaC % 10, 223);
    //Aca se gira uno de los dos motores
  }
  else{
    temperaturaC = abs(temperaturaC);
    sprintf(cBuffer, "%02u.%1u%cC", temperaturaC / 10, temperaturaC % 10, 223);
    //Aca ya se giran ambos motores
    //Aca es cuando sea mayor a 25 grados celsius
  }
}

int16_t get_temperature(){
  Wire.beginTransmission(DS1621_ADDRESS);
  Wire.write(0xAA);
  Wire.endTransmission(false);
  Wire.requestFrom(DS1621_ADDRESS, 2);
  uint8_t temperaturaMSB = Wire.read();
  uint8_t temperaturaLSB = Wire.read();

  int16_t rawValue = (int8_t)temperaturaMSB << 1 | temperaturaLSB >> 7;
  rawValue = rawValue * 10/2;
  return rawValue;
}
