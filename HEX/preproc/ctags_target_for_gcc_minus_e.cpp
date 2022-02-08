# 1 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino"
# 2 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino" 2
# 94 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino"
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
# 108 "C:\\Users\\Elder\\Documents\\USAC\\Semestre 2021\\Arqui 1\\Lab\\Proyecto Clase\\Script\\Script\\Script.ino"
LiquidCrystal lcd(2,3,4,5,6,7); // Conexiones (rs, enable, d4, d5, d6, d7)
int s1 = A0;
int s2 = A1;
int valor1;
int valor2;

int paraElisa[] = {
  1319, 1245, 1319, 1245,
  1319, 988 ,1175, 1047,
  880,1,523,659,
  880,988,1, 659,
  831,988,1047,1,
  659,1319,1245,1319,
  1245,1319,988,1175,
  1047, 880,1,523,
  659, 880, 988,1,
  659,1047,988,880,
  1,988,1047, 1175,
  1319, 784, 1397,1319,
  1175, 698, 1319, 1175,
  1047, 659, 1175,1047,
  988, 1, 659,1319,
  1,1,1319,2637,
  1,1245, 1319, 1,
  1245, 1319, 1245,1319,
  1245, 1319, 988, 1175,
  1047, 880, 1,523,
  659,880, 988,1,
  659,831,988,1047,
  1, 659,1319,1245,
  1319,1245,1319,988,
  1175,1047,880,1,
  523,659,880,988,
  1,659,1047,988,
  880,1
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
  294, 1, 330, 349, 349,
  330, 294, 262, 1,
  294, 262, 1,
  349, 392, 3520, 440, 1, 440, 3951,
  349, 330, 330, 1, 1,
  349, 330, 349, 392, 1, 1, 330, 294
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
  262, 523, 220, 440,
  233, 466, 1,
  1,
  262, 523, 220, 440,
  233, 466, 1,
  1,
  175, 349, 147, 294,
  156, 311, 1,
  1,
  175, 349, 147, 294,
  156, 311, 1,
  1, 311, 277, 294,
  277, 311,
  311, 208,
  196, 277,
  262, 370, 349, 165, 466, 440,
  415, 311, 247,
  233, 220, 208,
  1, 1, 1
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
  pinMode(s1,0x0);
  pinMode(s2, 0x0);
  pinMode(12, 0x1);
  pinMode(13, 0x1);
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
