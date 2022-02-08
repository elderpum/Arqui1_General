#include <LiquidCrystal.h>
#include <Wire.h>
#define I2C_TERM 0x48
const byte I2C_MAESTRO = 1;

const int motor1 = 12;
const int motor2 = 13;

int valorp; //valor del potenciómetro leído del arduino maestro
int escala;

const int rs = 5, en = 4, d4 = 3, d5 =2, d6 = 7, d7 = 6;

LiquidCrystal lcd(rs,en,d4,d5,d6,d7);

void setup() {

  pinMode(motor2, OUTPUT);
  pinMode(motor1, OUTPUT);
  
  // la pantalla
  lcd.begin(16,2);
  Serial.begin(9600);
  
   print_text_lcd("Apagado",0);

  // I2c
  Wire.begin(I2C_MAESTRO); //Acá decimos que el esclavo se va a identificar con el # 1
  Wire.onReceive(lectura); 
}


void lectura(){
  valorp= Wire.read();

  if(valorp ==0){
    lcd.clear();
    print_text_lcd("Apagado",0);
  } else {
    activarMotores(valorp);
    Serial.println(valorp);//imprimimos en el monitor serial del esclavo
  }
}

void loop() {
  delay(100);
  lcd.setCursor(0,0);
}


char cBuffer[8];

void activarMotores(int temperaturaC){
  if (temperaturaC <= 18){
    if (temperaturaC < 0) {
      temperaturaC = abs(temperaturaC);
      sprintf(cBuffer, "-%02u.%1u%cC", temperaturaC, temperaturaC % 10, 223);
    }
    else {
      temperaturaC = abs(temperaturaC);
      sprintf(cBuffer, "%02u.%1u%cC", temperaturaC, temperaturaC % 10, 223);
    }
    digitalWrite(motor1, LOW);
    digitalWrite(motor2, LOW);
    
    print_text_lcd("LVL: 1", 1);
  }
  else if (temperaturaC >= 18 && temperaturaC <= 25){
    temperaturaC = abs(temperaturaC);
    sprintf(cBuffer, "%02u.%1u%cC", temperaturaC, temperaturaC % 10, 223);
    
    digitalWrite(motor1, HIGH);
    digitalWrite(motor2, LOW);
    print_text_lcd("LVL: 2", 1);
  }
  else{
    temperaturaC = abs(temperaturaC);
    sprintf(cBuffer, "%02u.%1u%cC", temperaturaC, temperaturaC % 10, 223);
    digitalWrite(motor1, HIGH);
    digitalWrite(motor2, HIGH);
    
    print_text_lcd("LVL: 3", 1);
  }

  
    print_text_lcd(cBuffer, 0);
}

void print_text_lcd(char text[], int col){
  lcd.setCursor(0,col);
  for(int i = 0; i<strlen(text); i++){
    lcd.print(text[i]);
    lcd.setCursor(i+1,col);
  }
}
