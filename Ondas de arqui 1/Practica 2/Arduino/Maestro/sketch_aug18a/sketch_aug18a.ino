#include <Keypad.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>


LiquidCrystal_I2C lcd(0x27, 20, 4);

const byte FILA = 4;
const byte COLS = 4;

char hexaKeys[FILA][COLS] = {
    {'1','2','3','A'}, 
    {'4','5','6','B'}, 
    {'7','8','9','C'}, 
    {'*','0','#','D'},  
};

char contracomp[6] = "202101";
char contraKEY[6] ; 
int contadorcontra = 0;

byte colPins[COLS] = {9,8,7,6};
byte rowPins[FILA] = {13,12,11,10};

Keypad tecladitoRico = Keypad (makeKeymap(hexaKeys), rowPins, colPins, FILA, COLS);

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();
  
  lcd.setCursor(1,0); 
  lcd.print("CASA ACYE1"); 
  lcd.setCursor(1,1);
  lcd.print("B-G01-S2"); 

}


void loop() {
  char teclitaRica = tecladitoRico.getKey();

  
   if(teclitaRica == '*'){
    if(compararCONTRA()){
      lcd.clear();
      print_text_lcd("BIENVENIDO ",0);
      print_text_lcd("A CASA ", 1);
    }else{
      lcd.clear();
      print_text_lcd("ERROR EN ",0);
      print_text_lcd("CONTRASENIA : ",1);
      delay(3000);
      lcd.clear();
      print_text_lcd(contraKEY,1);
    }
  }else if(teclitaRica!=NULL){       
    contraKEY[contadorcontra] = teclitaRica;        
      contadorcontra++; 
      if (contadorcontra==6){
        BorrarContra();
        contadorcontra=0;
      }
  }
  

}

void print_text_lcd(char text[], int col){
  lcd.setCursor(0,col);
  for(int i = 0; i<strlen(text); i++){
    lcd.print(text[i]);
    lcd.setCursor(i+1,col);
  }
}

bool compararCONTRA(){
    for(int i=0; i< 6;i++){
      
      if (contracomp[i]!=contraKEY[i]){
        return false;
      }     
    }
    return true;
}

void BorrarContra(){
  for(int i=0;i<6;i++){
    contraKEY[contadorcontra] = NULL;
  }
}
