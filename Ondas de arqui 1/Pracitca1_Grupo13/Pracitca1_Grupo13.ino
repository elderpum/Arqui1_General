#include "LedControl.h"
#include "Serpiente.h"

int i = 2;
int arriba = 10;
int izquierda = 9;
int abajo = 8;
int derecha = 7;
int Direccion = 6;
int Modo = 5;
int Start = 4;
bool ModoJuego = false;
LedControl lc=LedControl(13,11,12,2); // crea objeto (DIN, CS, CLK, NUM)
byte dinamicArray1[8];
byte dinamicArray2[8];
CuerpoSerpiente Serpiente;
byte matrixTemp[48];

byte letrero2[] {
  //O
  B00000000,
  B01111110,
  B11111111,
  B10000001,
  B10000001,
  B10000001,
  B01111110,
  B00000000,

  //1
  B00000000,
  B00100000,
  B01000000,
  B10000000,
  B11111111,
  B11111111,
  B00000000,
  B00000000,

  //2
  B00000000,
  B00000000,
  B00100111,
  B01001111,
  B10001001,
  B10010001,
  B01100001,
  B00000000,

  //3
  B00000000,
  B01000010,
  B10000001,
  B10010001,
  B11111111,
  B01101110,
  B00000000,
  B00000000,

  //4
  B00000000,
  B11111000,
  B00001000,
  B00001000,
  B00001000,
  B11111111,
  B11111111,
  B00000000,

  //5
  B00000000,
  B11110001,
  B11110001,
  B10010001,
  B10010001,
  B10011111,
  B10001110,
  B00000000,
  
  //6
  B00000000,
  B01111110,
  B11111111,
  B10001001,
  B10001001,
  B10001001,
  B10000110,
  B00000000,

  //7
  B00000000,
  B10000000,
  B10000000,
  B10000000,
  B10000000,
  B11111111,
  B11111111,
  B00000000,

  //8
  B00000000,
  B01100110,
  B11111111,
  B10011001,
  B10011001,
  B10011001,
  B01100110,
  B00000000,

  //9
  B00000000,
  B01110001,
  B10001001,
  B10001001,
  B10001001,
  B11111111,
  B01111110,
  B00000000,
};

byte frase[]{
  // *
  B00000000,
  B00010000,
  B01010100,
  B00111000,
  B11111110,
  B00111000,
  B01010100,
  B00010000,

  // T
  B10000000,
  B10000000,
  B10000000,
  B11111111,
  B11111111,
  B10000000,
  B10000000,
  B10000000,

  //P
  B00000000,
  B11111111,
  B11111111,
  B10011000,
  B10011000,
  B10011000,
  B01100000,
  B00000000,

  // 1
  B00000000,
  B00100000,
  B01000000,
  B10000000,
  B11111111,
  B11111111,
  B00000000,
  B00000000,

  //GUION
  B00000000,
  B00000000,
  B00011000,
  B00011000,
  B00011000,
  B00011000,
  B00000000,
  B00000000,

  //G
  B00000000,
  B11111111,
  B11111111,
  B10000001,
  B10001001,
  B10001001,
  B10001111,
  B00000000,

  //R
  B00000000,
  B00000000,
  B11111111,
  B11111111,
  B10011000,
  B10010100,
  B01100011,
  B00000000,

  //U
  B00000000,
  B11111110,
  B11111111,
  B00000001,
  B00000001,
  B00000001,
  B11111110,
  B00000000,

  //P
  B00000000,
  B11111111,
  B11111111,
  B10011000,
  B10011000,
  B10011000,
  B01100000,
  B00000000,

  //O
  B00000000,
  B01111110,
  B11111111,
  B10000001,
  B10000001,
  B10000001,
  B01111110,
  B00000000,

  //Espacio
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,

  //1
  B00000000,
  B00100000,
  B01000000,
  B10000000,
  B11111111,
  B11111111,
  B00000000,
  B00000000,

  //3
  B00000000,
  B01000010,
  B10000001,
  B10010001,
  B10010001,
  B01101110,
  B00000000,
  B00000000,
  
  //GUION
  B00000000,
  B00000000,
  B00011000,
  B00011000,
  B00011000,
  B00011000,
  B00000000,
  B00000000,

  //S
  B00000000,
  B01100001,
  B11110001,
  B10010001,
  B10010001,
  B10011111,
  B10001110,
  B00000000,

  //E
  B00000000,
  B11111111,
  B11111111,
  B10011001,
  B10011001,
  B10000001,
  B10000001,
  B00000000,

  //C
  B00000000,
  B11111111,
  B11111111,
  B10000001,
  B10000001,
  B10000001,
  B10000001,
  B00000000,

  //C
  B00000000,
  B11111111,
  B11111111,
  B10000001,
  B10000001,
  B10000001,
  B10000001,
  B00000000,

  //I
  B00000000,
  B10000001,
  B10000001,
  B11111111,
  B11111111,
  B10000001,
  B10000001,
  B00000000,

  //O
  B00000000,
  B01111110,
  B11111111,
  B10000001,
  B10000001,
  B10000001,
  B01111110,
  B00000000,

  //N
  B00000000,
  B11111111,
  B11000000,
  B00110000,
  B00001100,
  B00000011,
  B11111111,
  B00000000,

  //Espacio
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,

  //A
  B00000000,
  B01111111,
  B11001000,
  B11001000,
  B11001000,
  B11001000,
  B01111111,
  B00000000,

  //*
  B00000000,
  B00010000,
  B01010100,
  B00111000,
  B11111110,
  B00111000,
  B01010100,
  B00010000
};

byte gameover[]{
  // G
  B00000000,
  B11111111,
  B11111111,
  B10000001,
  B10001001,
  B10001001,
  B10001111,
  B00000000,

  // A
  B00000000,
  B01111111,
  B11001000,
  B11001000,
  B11001000,
  B11001000,
  B01111111,
  B00000000,

  // M
  B11111111,
  B01000000,
  B00100000,
  B00010000,
  B00100000,
  B01000000,
  B11111111,
  B00000000,

  // E
  B00000000,
  B11111111,
  B11111111,
  B10011001,
  B10011001,
  B10000001,
  B10000001,
  B00000000,

  // ESPACIO
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  B00000000,
  
  // O
  B00000000,
  B01111110,
  B11111111,
  B10000001,
  B10000001,
  B10000001,
  B01111110,
  B00000000,

  // V
  B00000000,
  B11000000,
  B00110000,
  B00001100,
  B00000011,
  B00001100,
  B00110000,
  B11000000,
  
  // E
  B00000000,
  B11111111,
  B11111111,
  B10011001,
  B10011001,
  B10000001,
  B10000001,
  B00000000,
  
  // R
  B00000000,
  B00000000,
  B11111111,
  B11111111,
  B10011000,
  B10010100,
  B01100011,
  B00000000
};

byte pts[] {
  //P
  B00000000,
  B11111111,
  B11111111,
  B10011000,
  B10011000,
  B10011000,
  B01100000,
  B00000000,
  
  // T
  B10000000,
  B10000000,
  B10000000,
  B11111111,
  B11111111,
  B10000000,
  B10000000,
  B10000000,

  //S
  B00000000,
  B01100001,
  B11110001,
  B10010001,
  B10010001,
  B10011111,
  B10001110,
  B00000000
};

void setup() {
  //Valores de la nueva forma
  lc.shutdown(0,false);     // enciende la matriz
  lc.setIntensity(0,4);     // establece brillo
  lc.clearDisplay(0);     // blanquea matriz

  lc.shutdown(1,false);     // enciende la matriz
  lc.setIntensity(1,4);     // establece brillo
  lc.clearDisplay(1);     // blanquea matriz
  
  pinMode(arriba, INPUT);
  pinMode(izquierda, INPUT);
  pinMode(abajo, INPUT);
  pinMode(derecha, INPUT);
  pinMode(Direccion, INPUT);
  pinMode(Modo, INPUT);
  pinMode(Start, INPUT);
  /*
  al metodo punteo solo enviale un int
  y al staticFrame los mismo parametro del dinamicFrame
  */
}

void loop() {
  ModoJuego = false;
  while(!ModoJuego){
    if (digitalRead(Direccion) == HIGH){
      if (digitalRead(Modo) == HIGH){
        staticFrame1(400, frase, sizeof(frase), true);
      }else{
        dinamicFrame1(400,frase,sizeof(frase),true);
      }
    } else {
      if (digitalRead(Modo) == HIGH){
        staticFrame1(400, frase, sizeof(frase), false);
      } else {
        dinamicFrame1(400,frase,sizeof(frase),false);
      }
    }
    lc.clearDisplay(0);
    lc.clearDisplay(1);
  }
  CuerpoSerpiente Serpiente;
  int PuntosGameOver = Serpiente.FlujoJuego(Serpiente, lc);
  lc.clearDisplay(0);
  lc.clearDisplay(1);
  punteo(PuntosGameOver);
  lc.clearDisplay(0);
  lc.clearDisplay(1);
}

bool CambioJuegoMensaje(){
  if (digitalRead(Start) == HIGH){
    delay(1000);
    if (digitalRead(Start) == HIGH){
      delay(1000);
      if (digitalRead(Start) == HIGH){
        delay(1000);
        if (digitalRead(Start) == HIGH){
          return true;
        }
        return false;
      }
      return false;
    }
    return false;
  }
  return false;
}


void dinamicFrame1(int dem,byte arrayI[], int t, boolean spean){
    // (demora, arrayByte, sizeArrayByte, direccion)
    bool masRapido = false;
    if(spean){
      for (int j = 0; j < t; j++) 
      {
        // matriz 0 <- [0-7]
        for (int i = 0; i < 8; i++) 
        {
          if(j-i == -1){
            for (int k = j,p = 7; k >= 0 && p >= 0; k--,p--) 
            {
              lc.setColumn(0,p,arrayI[k]);
            }
          }
        }

        // matriz 1 <- [8-15]
        for (int i = 0; i < 8; i++) 
        {
          if(j-i == 7){
            // matriz 0
            // 8
            for (int k = j,p = 7; p >= 0; k--,p--) 
            {
              lc.setColumn(0,p,arrayI[k]);
            }
            // 8-8=0
            for (int k = j-8,p = 7; k >= 0 && p >= 0; k--,p--) 
            {
              lc.setColumn(1,p,arrayI[k]);
            }
          }
        }

        // matriz 1 <- 16<
        if( j >= 16){
          // matriz 0
          //17
          for (int k = j, p = 7; p >= 0; k--,p--) 
          {
            lc.setColumn(0,p,arrayI[k]);
          }
          // matriz 1
          // 17-7 = 10 
          for (int k = j-8,p = 7; k >= 0 && p >= 0; k--,p--) 
          {
            lc.setColumn(1,p,arrayI[k]);
          }
        }
        
        if(j == t-1){
          lc.clearDisplay(0);     // blanquea matriz
          lc.clearDisplay(1);     // blanquea matriz
          delay(10);
        } else {
          if (CambioJuegoMensaje()){
            ModoJuego = true;
            return;
          }
          if (digitalRead(arriba) == HIGH){
            masRapido = true;
          }
          if (digitalRead(abajo) == HIGH){
            masRapido = false;
          }
          if (masRapido){
            delay(200);
          } else {
            delay(400);
          }
        }
      }
    }else {
      // modulador para envio de parametro de posicion de matriz 
      int v = 0, a = 0;
      for (int j = t-1; j >= 0; j--){
        if(v < 8){
          for (int k = 0; k <= v; k++){
            lc.setColumn(1,k,arrayI[j+k]);
          }
        }else{
          for (int k = 0; k <= 7; k++){
            lc.setColumn(1,k,arrayI[j+k]);
          }
          // matriz 0
          if(a < 8){
            for (int k = 0; k <= a; k++){
              lc.setColumn(0,k,arrayI[j+k+8]);
            }
          }else{
            for (int k = 0; k <= 7; k++){
              lc.setColumn(0,k,arrayI[j+k+8]);
            }
          }
          a += 1;
        }
        v += 1;
        if (CambioJuegoMensaje()){
          ModoJuego = true;
          return;
        }
        if (digitalRead(arriba) == HIGH){
          masRapido = true;
        }
        if (digitalRead(abajo) == HIGH){
          masRapido = false;
        }
        if (masRapido){
          delay(200);
        } else {
          delay(400);
        }
        if(j == 0){
          lc.clearDisplay(0);     // blanquea matriz
          lc.clearDisplay(1);     // blanquea matriz
          delay(10);
        }
      }
    }
}

void staticFrame1(int dem,byte arrayI[], int t, boolean spean){
  bool chan = true;
  bool masRapido = false;
  if(spean){
    for (int j = 0; j <= t; j++) // <<---
    {
      if(j == 0){
        dinamicArray1[j]= arrayI[j];
      }else if (j%8 != 0){
        dinamicArray1[j%8] = arrayI[j];
      }else {
        if(chan){
          for (int k = 0; k < 8; k++)     // bucle itera 8 veces por el array
          {
            lc.setColumn(0,k,dinamicArray1[k]);
          }
          memcpy(dinamicArray2,dinamicArray1,sizeof(dinamicArray1));
          chan = false;
          dinamicArray1[0]= arrayI[j];
        }else{
          for (int k = 0; k < 8; k++)     // bucle itera 8 veces por el array
          {
            lc.setColumn(0,k,dinamicArray1[k]);
            lc.setColumn(1,k,dinamicArray2[k]);
          }
          memcpy(dinamicArray2,dinamicArray1,sizeof(dinamicArray1));
          dinamicArray1[0]= arrayI[j];
        }
        if(j == t){
          delay(800);
          lc.clearDisplay(0);     // blanquea matriz
          lc.clearDisplay(1);     // blanquea matriz
        } else {
          if (CambioJuegoMensaje()){
            ModoJuego = true;
            return;
          }
          if (digitalRead(arriba) == HIGH){
            masRapido = true;
          }
          if (digitalRead(abajo) == HIGH){
            masRapido = false;
          }
          if (masRapido){
            delay(200);
          } else {
            delay(400);
          }
        }
      }     
    }
  }else {
    for (int j = t; j > 0; j--) // iteracion de array bit --->>
    {
      if (j%8 != 0){
        dinamicArray1[j%8-1] = arrayI[j-1];
        if (j%8 == 1){
          if(chan){
            for (int k = 0; k < 8; k++)     // bucle itera 8 veces por el array
            {
              lc.setColumn(1,k,dinamicArray1[k]);
            }
            memcpy(dinamicArray2,dinamicArray1,sizeof(dinamicArray1));
            chan = false;
          }else{
            for (int k = 0; k < 8; k++)     // bucle itera 8 veces por el array
            {
              lc.setColumn(1,k,dinamicArray1[k]);
              lc.setColumn(0,k,dinamicArray2[k]);
            }
            memcpy(dinamicArray2,dinamicArray1,sizeof(dinamicArray1));
          }
          
          if(j == 1){
            delay(800);
            lc.clearDisplay(0);     // blanquea matriz
            lc.clearDisplay(1);     // blanquea matriz
          } else {
            if (CambioJuegoMensaje()){
            ModoJuego = true;
            return;
          }
          if (digitalRead(arriba) == HIGH){
            masRapido = true;
          }
          if (digitalRead(abajo) == HIGH){
            masRapido = false;
          }
          if (masRapido){
            delay(200);
          } else {
            delay(400);
          }
          }
        }
      }else {
        dinamicArray1[7]= arrayI[j-1];
      }
      // COLOCAR CONDICIONES DE CAMBIO DE VELOCIDAD 
      
    }
  }
}



void punteo(int puntos){
  for(int i = 0; i< 24;i++){ matrixTemp[i] = pts[i];}
  int centena = puntos / 100;
  int decena = (puntos - centena * 100) / 10;
  int unidad = (puntos - centena * 100 - decena * 10);
  mostrar(centena,24);
  mostrar(decena,32);
  mostrar(unidad,40);
  dinamicFrame1(400,matrixTemp,sizeof(matrixTemp),true);
}

void mostrar(int numero,int indice){
  if(numero == 0){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i];
    }
  }else if(numero == 1){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i+8];
    }
  }else if(numero == 2){
    for(int i = 0; i<8;i++){
        matrixTemp[i+indice] = letrero2[i+16];
    }
  }
  else if(numero == 3){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i+24];
    }
  }
  else if(numero == 4){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i+32];
    }
  }
  else if(numero == 5){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i+40];
    }
  }
  else if(numero == 6){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i+48];
    }
  }
  else if(numero == 7){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i+56];
    }
  }
  else if(numero == 8){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i+64];
    }
  }
  else if(numero == 9){
    for(int i = 0; i<8;i++){
      matrixTemp[i+indice] = letrero2[i+72];
    }
  }
}
