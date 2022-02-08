#include <Arduino.h>
#line 1 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino"
#include <LiquidCrystal.h>

#define PAUSE 1
#define NOTE_B0  31
#define NOTE_C1  33
#define NOTE_CS1 35
#define NOTE_D1  37
#define NOTE_DS1 39
#define NOTE_E1  41
#define NOTE_F1  44
#define NOTE_FS1 46
#define NOTE_G1  49
#define NOTE_GS1 52
#define NOTE_A1  55
#define NOTE_AS1 58
#define NOTE_B1  62
#define NOTE_C2  65
#define NOTE_CS2 69
#define NOTE_D2  73
#define NOTE_DS2 78
#define NOTE_E2  82
#define NOTE_F2  87
#define NOTE_FS2 93
#define NOTE_G2  98
#define NOTE_GS2 104
#define NOTE_A2  110
#define NOTE_AS2 117
#define NOTE_B2  123
#define NOTE_C3  131
#define NOTE_CS3 139
#define NOTE_D3  147
#define NOTE_DS3 156
#define NOTE_E3  165
#define NOTE_F3  175
#define NOTE_FS3 185
#define NOTE_G3  196
#define NOTE_GS3 208
#define NOTE_A3  220
#define NOTE_AS3 233
#define NOTE_B3  247
#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494
#define NOTE_C5  523
#define NOTE_CS5 554
#define NOTE_D5  587
#define NOTE_DS5 622
#define NOTE_E5  659
#define NOTE_F5  698
#define NOTE_FS5 740
#define NOTE_G5  784
#define NOTE_GS5 831
#define NOTE_A5  880
#define NOTE_AS5 932
#define NOTE_B5  988
#define NOTE_C6  1047
#define NOTE_CS6 1109
#define NOTE_D6  1175
#define NOTE_DS6 1245
#define NOTE_E6  1319
#define NOTE_F6  1397
#define NOTE_FS6 1480
#define NOTE_G6  1568
#define NOTE_GS6 1661
#define NOTE_A6  1760
#define NOTE_AS6 1865
#define NOTE_B6  1976
#define NOTE_C7  2093
#define NOTE_CS7 2217
#define NOTE_D7  2349
#define NOTE_DS7 2489
#define NOTE_E7  2637
#define NOTE_F7  2794
#define NOTE_FS7 2960
#define NOTE_G7  3136
#define NOTE_GS7 3322
#define NOTE_A7  3520
#define NOTE_AS7 3729
#define NOTE_B7  3951
#define NOTE_C8  4186
#define NOTE_CS8 4435
#define NOTE_D8  4699
#define NOTE_DS8 4978

/*

C = DO
D = RE
E = MI
F = FA
G = SOL
A = LA
B = SI
S = Sostenido Ejemplo: NOTE_AS5   --> Corresponde a la nota LA sostenido en la octaba numero 5

*/


LiquidCrystal lcd(2,3,4,5,6,7); // Conexiones (rs, enable, d4, d5, d6, d7)
int s1 = A0;
int s2 = A1;
int valor1;
int valor2;

int paraElisa[] = {
  NOTE_E6, NOTE_DS6, NOTE_E6, NOTE_DS6,
  NOTE_E6, NOTE_B5 ,NOTE_D6, NOTE_C6,
  NOTE_A5,PAUSE,NOTE_C5,NOTE_E5,
  NOTE_A5,NOTE_B5,PAUSE, NOTE_E5, 
  NOTE_GS5,NOTE_B5,NOTE_C6,PAUSE,
  NOTE_E5,NOTE_E6,NOTE_DS6,NOTE_E6,
  NOTE_DS6,NOTE_E6,NOTE_B5,NOTE_D6,
  NOTE_C6, NOTE_A5,PAUSE,NOTE_C5,
  NOTE_E5, NOTE_A5, NOTE_B5,PAUSE,
  NOTE_E5,NOTE_C6,NOTE_B5,NOTE_A5,
  PAUSE,NOTE_B5,NOTE_C6, NOTE_D6,
  NOTE_E6, NOTE_G5, NOTE_F6,NOTE_E6,
  NOTE_D6, NOTE_F5, NOTE_E6, NOTE_D6,
  NOTE_C6, NOTE_E5, NOTE_D6,NOTE_C6,
  NOTE_B5, PAUSE, NOTE_E5,NOTE_E6,
  PAUSE,PAUSE,NOTE_E6,NOTE_E7,
  PAUSE,NOTE_DS6, NOTE_E6, PAUSE,
  NOTE_DS6, NOTE_E6, NOTE_DS6,NOTE_E6,
  NOTE_DS6, NOTE_E6, NOTE_B5, NOTE_D6,
  NOTE_C6, NOTE_A5, PAUSE,NOTE_C5,
  NOTE_E5,NOTE_A5, NOTE_B5,PAUSE,
  NOTE_E5,NOTE_GS5,NOTE_B5,NOTE_C6,
  PAUSE, NOTE_E5,NOTE_E6,NOTE_DS6,
  NOTE_E6,NOTE_DS6,NOTE_E6,NOTE_B5,
  NOTE_D6,NOTE_C6,NOTE_A5,PAUSE,
  NOTE_C5,NOTE_E5,NOTE_A5,NOTE_B5,
  PAUSE,NOTE_E5,NOTE_C6,NOTE_B5,
  NOTE_A5,PAUSE
};



int ritmo[] = {
  6,6,6,6,
  6,6,6,6,
  4,6,6,6,
  6,4,6,6,
  6,6,4,6,
  6,6,6,6, 
  6,6,6,6,
  6,4,6,6,
  6,6,4,6,
  6,6,6,4,
  6,6,6,6,
  3,6,6,6,
  3,6,6,6,
  3,6,6,6,
  4,6,6,6,
  6,6,6,6,
  6,6,6,6,
  6,6,6,6,
  6,6,6,6,
  6,4,6,6,
  6,6,4,6,
  6,6,6,4,
  6,6,6,6,
  6,6,6,6,
  6,6,4,6,
  6,6,6,4,
  6,6,6,6,
  2,4
};

int nocheRuinas[] = {
  NOTE_D4, PAUSE, NOTE_E4, NOTE_F4, NOTE_F4,
  NOTE_E4, NOTE_D4, NOTE_C4, PAUSE,
  NOTE_D4, NOTE_C4, PAUSE,
  NOTE_F4, NOTE_G4, NOTE_A7, NOTE_A4, PAUSE, NOTE_A4, NOTE_B7,
  NOTE_F4, NOTE_E4, NOTE_E4, PAUSE, PAUSE,
  NOTE_F4, NOTE_E4, NOTE_F4, NOTE_G4, PAUSE, PAUSE, NOTE_E4, NOTE_D4
};

int nocheRuinasRitmo[] = {
  4, 4, 4, 4, 4,
  4, 4, 4, 4, 
  4, 4, 4, 
  4, 4, 4, 4, 4, 4, 4, 
  4, 4, 4, 4, 4,
  4, 4, 4, 4, 4, 4, 4, 4
};

int Mario[] = {
  NOTE_C4, NOTE_C5, NOTE_A3, NOTE_A4,
  NOTE_AS3, NOTE_AS4, PAUSE,
  PAUSE,
  NOTE_C4, NOTE_C5, NOTE_A3, NOTE_A4,
  NOTE_AS3, NOTE_AS4, PAUSE,
  PAUSE,
  NOTE_F3, NOTE_F4, NOTE_D3, NOTE_D4,
  NOTE_DS3, NOTE_DS4, PAUSE,
  PAUSE,
  NOTE_F3, NOTE_F4, NOTE_D3, NOTE_D4,
  NOTE_DS3, NOTE_DS4, PAUSE,
  PAUSE, NOTE_DS4, NOTE_CS4, NOTE_D4,
  NOTE_CS4, NOTE_DS4,
  NOTE_DS4, NOTE_GS3,
  NOTE_G3, NOTE_CS4,
  NOTE_C4, NOTE_FS4, NOTE_F4, NOTE_E3, NOTE_AS4, NOTE_A4,
  NOTE_GS4, NOTE_DS4, NOTE_B3,
  NOTE_AS3, NOTE_A3, NOTE_GS3,
  PAUSE, PAUSE, PAUSE
};

int MarioR[] = {
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  6, 18, 18, 18,
  6, 6,
  6, 6,
  6, 6,
  18, 18, 18, 18, 18, 18,
  10, 10, 10,
  10, 10, 10,
  3, 3, 3
};

const int pin = 9; 
const int actual = 0;


int cantidad = sizeof(paraElisa)/sizeof(paraElisa[0]);
int cantidadMario = sizeof(Mario)/sizeof(Mario[0]);


#line 248 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino"
void playSong(int pin, int melody[], int rythm[], int size, int tempo);
#line 259 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino"
void setup();
#line 269 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino"
void loop();
#line 248 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino"
void playSong(int pin, int melody[], int rythm[], int size, int tempo) {
  int tempoMillis = 60000 / tempo;
  for (int thisNote = 0; thisNote < size; thisNote++) {
    int noteDuration = tempoMillis / rythm[thisNote];
    tone(pin, melody[thisNote], noteDuration);
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
    noTone(pin);
  }
}

void setup()
{
  lcd.begin(16,2);
  lcd.clear();
  pinMode(s1,INPUT);
  pinMode(s2, INPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);  
}
 
void loop()
{
  delay(500);
  switch(actual)
  valor1 = digitalRead(s1);

  digitalWrite(12,0);
  digitalWrite(13,0);

  lcd.setCursor(0,0);
  lcd.print("Para Elisa");
  lcd.setCursor(0,1);
  lcd.print("Beethoveen");

  valor1 = digitalRead(s1);
  
  playSong(pin, paraElisa, ritmo, cantidad, 50);
}

