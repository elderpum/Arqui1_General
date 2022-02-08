#include <LiquidCrystal.h>
#include "Wire.h"

//LCD 2 configuracion de pines
LiquidCrystal lcd(2,3,4,5,6,7);   

//Variables utilizadas
int temperatura;  
char c_buffer[8];

void setup() {
  Wire.begin(23);         //NUMERO DE ESCLAVO
  lcd.begin(16,2);        //Inizializar el display 2
  lcd.setCursor(0, 0);    // mover el cursor a la columna 0, fila 0 

  //lcd.print("APAGADO");     // crear condicion para mostrar apafado o la temperatura
  Wire.onReceive(mostrarTemp);  //funcion que escucha al maestro
}

void loop() {
 
}

//Funcion que lee lo que se envia desde el maestro
void mostrarTemp(int numbyte){
  temperatura = Wire.read();
  levelTemp(temperatura);
  lcd.setCursor(0, 0);   
  lcd.print("TEMP: ");
  sprintf(c_buffer, " %02u%cC", temperatura, 223);  //formato de temperatura
  lcd.print(c_buffer);
  
}

//Funcion para mostrar niveles y encender motores
void levelTemp(int temperatura_)
{
 if(temperatura_ <= 18)
 {
  lcd.setCursor(0, 1);  
  lcd.print("NIVEL : 1");
  //no encender  motor
 }else if(temperatura_ > 18 && temperatura_ < 25)
 {
  
  lcd.setCursor(0, 1); 
  lcd.print("NIVEL : 2");
  //encender 1 motor
 }else
 {
  lcd.setCursor(0, 1); 
  lcd.print("NIVEL : 3");
  //encender ambos motores
 }

}
