#include <stdlib.h>
#include <time.h>
#include "LedControl.h"

using namespace std;

struct Cuerpo{
    int X;
    int Y;
    bool Activo;
    int Direccion; //2 arriba, 1 izquierda, 0 abajo, 3 derecha
};

struct Bolita{
    int X;
    int Y;
};

byte Spts[] {
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

byte Sletrero2[]  {
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

  byte SmatrixTemp[48];
  byte SdinamicArray1[8];
  byte SdinamicArray2[8];

class CuerpoSerpiente{
  
  public:
        Cuerpo cuerpo[120];
        Bolita bolita;
        int Puntos = 0;
        int arriba = 10;
        int izquierda = 9;
        int abajo = 8;
        int derecha = 7;
        int Start = 4;

      CuerpoSerpiente(){
          //Posicion inicial
          int Col = ColumnaInicio();
          int fil = FilaInicio();
        for (int n=0; n<120; n++){
          if (n==0 || n==1){
            cuerpo[n].Activo = true;
          } else {
              cuerpo[n].Activo = false;
          }
          cuerpo[n].Y = fil;
          if (Col == 15){
              cuerpo[n].X = Col + n;
              cuerpo[n].Direccion = 1;
          } else {
              cuerpo[n].X = Col - n;
              cuerpo[n].Direccion = 3;
          }
          
          
        }
        
        GenerarBolita();
      }
      
      int PosicionX(int posicion){
            if (posicion>=0 && posicion<=119){
                return (cuerpo[posicion].X);
            }
            return (999999);
      }
        int PosicionY(int posicion){
            if (posicion>=0 && posicion<=119){
                return (cuerpo[posicion].Y);
            }
            return (999999);
        }
        void Desplazamiento(){
            for (int n = 119; n>=0; n--){
                if(n==0){
                    DireccionDesp(0);
                } else {
                    cuerpo[n].X = cuerpo[n-1].X;
                    cuerpo[n].Y = cuerpo[n-1].Y;
                    cuerpo[n].Direccion = cuerpo[n-1].Direccion;
                }
            }
        }
        
        void DireccionDesp(int posicion){
            //Direccion 0 = arriba
            if (cuerpo[posicion].Direccion == 0){
                cuerpo[posicion].Y = cuerpo[posicion].Y + 1;
                //Direccion 1 = izquierda
            } else if (cuerpo[posicion].Direccion == 1){
                cuerpo[posicion].X = cuerpo[posicion].X - 1;
                //Direccion 2 = abajo
            } else if (cuerpo[posicion].Direccion == 2){
                cuerpo[posicion].Y = cuerpo[posicion].Y - 1;
                //Direccion 3 = derecha
            } else {
                cuerpo[posicion].X = cuerpo[posicion].X + 1;
            }
        }
        
        void CambiarDireccion(int direccion){
            if (cuerpo[0].Direccion - direccion != -2 && cuerpo[0].Direccion - direccion != 2){
                cuerpo[0].Direccion = direccion;
            }
            //Si esta condicion no se cumple, quiere decir que intento hacer un movimiento totalmente opuesto
            //a la dirección que ya llevaba, por lo tanto no se cambia.
        }
        
        bool Colision(){
            //vamos a ver si X se sale del margen
            if (cuerpo[0].X > 15 || cuerpo[0].X < 0){
                return true;
            }
            //vamos a ver si Y se sale del margen
            if (cuerpo[0].Y > 7 || cuerpo[0].Y < 0){
                return true;
            }
            //Ahora revisamos si se colisiona con su cola.
            for (int n = 1; n<120; n++){
                //Si la cabeza está sobre la posición de alguna parte de su cola
                if (cuerpo[n].Y == cuerpo[0].Y && cuerpo[n].X == cuerpo[0].X){
                    //Y además esa parte de la cola está activa es colisión
                    if (cuerpo[n].Activo){
                        //cout<<"Chocaste con la cola bobo";
                        return true;
                    }
                }
            }
            //Si llegamos aquí quiere decir que no hay colisión
            return false;
        }
        
        void GenerarBolita(){
            int Xgenerico;
            int Ygenerico;
            bool bandera;
            while (true){
                bandera = true;
                //srand(time(NULL));
                Xgenerico = random(16);
                Ygenerico = random(8);
                //Verificamos que no esté en la cola o cabeza de la Serpiente
                for (int n=0; n<120; n++){
                    if (cuerpo[n].X == Xgenerico && cuerpo[n].Y == Ygenerico){
                        if (cuerpo[n].Activo){
                            bandera = false;
                            n=120;
                        }
                    }
                }
                if (bandera){
                    break;
                }
            }
            bolita.X = Xgenerico;
            bolita.Y = Ygenerico;
        }
        
        int InfoPelotaX(){
            return (bolita.X);
        }
        
        int InfoPelotaY(){
            return (bolita.Y);
        }
        
        bool ComerPelota(){
            if (bolita.X == cuerpo[0].X && bolita.Y == cuerpo[0].Y){
                return true;
            }
            return false;
        }
        
        void CrecerSerpiente(){
            for (int n=0; n<120; n++){
                if (!cuerpo[n].Activo){
                    Puntos = Puntos + 1;
                    cuerpo[n].Activo = true;
                    break;
                }
            }
        }
        
        void VerificarPelota(){
            if (ComerPelota()){
                //cout<<"PELOTA COMIDA";
                CrecerSerpiente();
                GenerarBolita();
            }
        }
        
        bool ExistePunto(int x, int y){
            for (int j = 0; j<120; j++){
                    if (cuerpo[j].X == x && cuerpo[j].Y == y && cuerpo[j].Activo){
                        return(true);
                }
            }
            return(false);
        }
        
        int ColumnaInicio(){
            srand(time(NULL));
            int inicioColumna = random(160);
            if (inicioColumna%2 == 0){
                //inicia izquierda
                return (0);
            } else {
                //inicia derecha
                return (15);
            }
        }
        
        int FilaInicio(){
            srand(time(NULL));
            int inicioFila = random(8);
            return inicioFila;
        }

        int Entrada(CuerpoSerpiente Serpiente){
          if (digitalRead(arriba) == HIGH){
            return 2;
          }
          if (digitalRead(abajo) == HIGH){
            return 0;
          }
          if (digitalRead(derecha) == HIGH){
            return 3;
          }
          if (digitalRead(izquierda) == HIGH){
            return 1;
          }
          return Serpiente.cuerpo[0].Direccion;
        }

        int FlujoJuego(CuerpoSerpiente Serpiente, LedControl lc){
            //Solicitud de velocidad para el juego
            int FracSpeed=0;
              FracSpeed = velocidadSerpiente(arriba, abajo, derecha, lc);
            //Juego iniciado
            while (true){
                Serpiente.Desplazamiento();
                if (Serpiente.Colision()){
                    return (Serpiente.Puntos);
                }
                Serpiente.VerificarPelota();
                Serpiente.DibujarSerpiente(lc);
                int pausa = CambioJuegoMensaje();
                if (pausa == 1){
                  bool modoPausa = true;
                  while(modoPausa){
                    //MostrarMensaje
                    modoPausa = punteo(Serpiente.Puntos, lc);
                    delay(400);
                  }
                } else if (pausa == 2){
                  return (Serpiente.Puntos);
                }
                int entrada = Entrada(Serpiente);
                Serpiente.CambiarDireccion(entrada);
                int velocidad = 1000/FracSpeed -5*Serpiente.Puntos;
                delay(velocidad);
                entrada = Entrada(Serpiente);
            }
        }

        int CambioJuegoMensaje(){
          if (digitalRead(Start) == HIGH){
            delay(1000);
            if (digitalRead(Start) == HIGH){
              delay(1000);
              if (digitalRead(Start) == HIGH){
                delay(1000);
                if (digitalRead(Start) == HIGH){
                  return 2;
                }
                return 1;
              }
              return 1;
            }
            return 1;
          }
          return 0;
        }
        
        void DibujarSerpiente(LedControl lc){
          for(int columna = 0; columna < 16; columna++){ //for de columna
            for(int fila = 0; fila < 8; fila++){
              if(ExistePunto(columna, fila)){
                if(columna < 8){
                  lc.setLed(1, fila, columna, true);
                  delay(5);
                }
                else{
                  lc.setLed(0, fila, columna-8, true);
                  delay(5);
                }
              }
              else if(bolita.X == columna && bolita.Y == fila){
                    if(columna < 8){
                      lc.setLed(1, fila, columna, true);
                      delay(5);
                    }
                    else{
                      lc.setLed(0, fila, columna-8, true);
                      delay(5);      
                   }
              } 
              else{
                     if(columna < 8){
                      lc.setLed(1, fila, columna, false);
                      delay(5);
                    }
                    else{
                      lc.setLed(0, fila, columna-8, false);
                      delay(5);    
                   }
                               
                }
              }
            }
        }

        int velocidadSerpiente(int arriba, int abajo, int derecha, LedControl lc){
          int velocidad = 1;
          int retardo = 500;
          byte cero[8] = {
            B00000000,
            B00011000,
            B00100100,
            B00100100,
            B00100100,
            B00100100,
            B00011000,
            B00000000
          };

          byte uno[8] = {
            B00000000,
            B00011000,
            B00001000,
            B00001000,
            B00001000,
            B00001000,
            B00011100,
            B00000000
          };

          byte dos[8] = {
            B00000000,
            B00111100,
            B00000010,
            B00011100,
            B00100000,
            B00111110,
            B00000000,
            B00000000
          };

          byte tres[8] = {
            B00000000,
            B00111100,
            B00000010,
            B00001100,
            B00000010,
            B00111100,
            B00000000,
            B00000000
          };
          byte cuatro[8] = {
            B00000000,
            B00001100,
            B00010100,
            B00100100,
            B00111100,
            B00000100,
            B00000000,
            B00000000
          };
          
          for(int fila=0;fila<8;fila++) {
            lc.setRow(0,fila,uno[fila]);
            lc.setRow(1,fila,cero[fila]);
          }

          int velocidadOk = digitalRead(derecha);

          while(velocidadOk == LOW){
            if(HIGH == digitalRead(arriba)){
              if(velocidad < 4){
                velocidad++;
                delay(retardo);
              }
            }

            if(HIGH == digitalRead(abajo)){
              if(velocidad >= 2){
                velocidad--;
                delay(retardo);
              }
            }

            if(HIGH == digitalRead(derecha)){
              velocidadOk = HIGH;
              delay(retardo);
            }

            if(velocidad == 1){
              for(int fila=0;fila<8;fila++) {
                lc.setRow(0,fila,uno[fila]);
                lc.setRow(1,fila,cero[fila]);
               }
            
            }
            if(velocidad == 2){
              for(int fila=0;fila<8;fila++) {
                lc.setRow(0,fila,dos[fila]);
                lc.setRow(1,fila,cero[fila]);
               
              }
              
            }

            if(velocidad == 3){
              for(int fila=0;fila<8;fila++) {
                lc.setRow(0,fila,tres[fila]);
                lc.setRow(1,fila,cero[fila]);
              }
              
            }

            if(velocidad == 4){
              for(int fila=0;fila<8;fila++) {
                lc.setRow(0,fila,cuatro[fila]);
                lc.setRow(1,fila,cero[fila]);
              }
              
            }
            Serial.print("Velocidad: ");
            Serial.println(velocidad);
            delay(retardo);
            
          }
          
          lc.clearDisplay(0);
          lc.clearDisplay(1);
          return velocidad;
          delay(1000);
        }

bool punteo(int puntos, LedControl lc){
  for(int i = 0; i< 24;i++){ SmatrixTemp[i] = Spts[i];}
  int centena = puntos / 100;
  int decena = (puntos - centena * 100) / 10;
  int unidad = (puntos - centena * 100 - decena * 10);
  mostrar(centena,24);
  mostrar(decena,32);
  mostrar(unidad,40);
  return (staticFrame1(100,SmatrixTemp,sizeof(SmatrixTemp),true, lc));
}

void mostrar(int numero,int indice){
  if(numero == 0){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i];
    }
  }else if(numero == 1){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i+8];
    }
  }else if(numero == 2){
    for(int i = 0; i<8;i++){
        SmatrixTemp[i+indice] = Sletrero2[i+16];
    }
  }
  else if(numero == 3){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i+24];
    }
  }
  else if(numero == 4){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i+32];
    }
  }
  else if(numero == 5){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i+40];
    }
  }
  else if(numero == 6){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i+48];
    }
  }
  else if(numero == 7){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i+56];
    }
  }
  else if(numero == 8){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i+64];
    }
  }
  else if(numero == 9){
    for(int i = 0; i<8;i++){
      SmatrixTemp[i+indice] = Sletrero2[i+72];
    }
  }
}

bool staticFrame1(int dem,byte arrayI[], int t, boolean spean, LedControl lc){
  bool chan = true;
  bool masRapido = false;
  if(spean){
    for (int j = 0; j <= t; j++) // <<---
    {
      if(j == 0){
        SdinamicArray1[j]= arrayI[j];
      }else if (j%8 != 0){
        SdinamicArray1[j%8] = arrayI[j];
      }else {
        if(chan){
          for (int k = 0; k < 8; k++)     // bucle itera 8 veces por el array
          {
            lc.setColumn(0,k,SdinamicArray1[k]);
          }
          memcpy(SdinamicArray2,SdinamicArray1,sizeof(SdinamicArray1));
          chan = false;
          SdinamicArray1[0]= arrayI[j];
        }else{
          for (int k = 0; k < 8; k++)     // bucle itera 8 veces por el array
          {
            lc.setColumn(0,k,SdinamicArray1[k]);
            lc.setColumn(1,k,SdinamicArray2[k]);
          }
          memcpy(SdinamicArray2,SdinamicArray1,sizeof(SdinamicArray1));
          SdinamicArray1[0]= arrayI[j];
        }
        if(j == t){
          delay(800);
          lc.clearDisplay(0);     // blanquea matriz
          lc.clearDisplay(1);     // blanquea matriz
        } else {
          int pausa = CambioJuegoMensaje();
          if (pausa != 0){
                return false;
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
        SdinamicArray1[j%8-1] = arrayI[j-1];
        if (j%8 == 1){
          if(chan){
            for (int k = 0; k < 8; k++)     // bucle itera 8 veces por el array
            {
              lc.setColumn(1,k,SdinamicArray1[k]);
            }
            memcpy(SdinamicArray2,SdinamicArray1,sizeof(SdinamicArray1));
            chan = false;
          }else{
            for (int k = 0; k < 8; k++)     // bucle itera 8 veces por el array
            {
              lc.setColumn(1,k,SdinamicArray1[k]);
              lc.setColumn(0,k,SdinamicArray2[k]);
            }
            memcpy(SdinamicArray2,SdinamicArray1,sizeof(SdinamicArray1));
          }
          
          if(j == 1){
            delay(800);
            lc.clearDisplay(0);     // blanquea matriz
            lc.clearDisplay(1);     // blanquea matriz
          } else {
            int pausa = CambioJuegoMensaje();
          if (pausa != 0){
                return false;
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
        SdinamicArray1[7]= arrayI[j-1];
      }
      // COLOCAR CONDICIONES DE CAMBIO DE VELOCIDAD 
          
    }
  }
}

};
