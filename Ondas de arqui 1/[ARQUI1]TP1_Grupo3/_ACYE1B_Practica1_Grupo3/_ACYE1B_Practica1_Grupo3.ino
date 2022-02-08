#include "LedControl.h"
#include <FrequencyTimer2.h>

#include "letras.h"
#define num (21)

//VARIABLES DE MENSAJE DE ENTRADA
bool tablero[8][16]; //representacion de matriz
byte letrero[num][8][16] = {ASTERISCO, T, P, UNO, LINE, G, R, U, P, O,  TRES, LINE,  S, E, C, C, I, O, N, B, ASTERISCO}; //Mensaje a mostrar
int sumador;        //variable que representa la velPelotita media
int corrimiento;    //variable que acumula el desplazamiento
int retraso;        //variable que guarda la disminucion de velPelotita
int rapidez;        //variable que guarda el aumento de velPelotita
int Cont = 0;       //variable que representa el numero de byte del mensaje
int contFila = 0;   //variable que cuenta el numero de filas
bool derizq = 1;    //variable que fija la direccion, hacia la derecha
int pinDir = 10;    //Pin de cambio de direccion
int pinStart = 7;   //Pin de Start que genera cambio entre juego y letrero
//FIN VARIABLES DE MENSAJE DE ENTRADA


//VARIABLES DE JUEGO
LedControl inputEntrada = LedControl(13, 11, 12, 1);  //Objeto para controlar la matriz a través del MAX7219
byte pnts[5][8][16] = {CERO, UNO, DOS, TRES, CUATRO}; //Mensaje del marcador
int pinIzqUp = 18, pinIzqDown = 19;   //Pines pad izquierda arriba abajo
int pinDerUp = 20, pinDerDown = 21;   //Pines pad derecha arriba abajo
unsigned long Ptiempo = 0;            //Variable que define el tiempo anterior START
unsigned long Ctiempo = 0;            //Variable que define el tiempo actual START
unsigned long Ttiempo = 0;            //Variable que define el tiempo total START
unsigned long P1tiempo = 0;           //Variable que define el tiempo anterior SALIR
unsigned long C1tiempo = 0;           //Variable que define el tiempo actual SALIR
unsigned long T1tiempo = 0;           //Variable que define el tiempo total SALIR
int retardoJuego = 2;                    //Delay del juego
bool banderita;                       //bandera que indica el estado: mensaje o juego
int velPelotita = 5;                  //Velocidad de la pelota
int dirPelota = velPelotita;          //Variable que mueve la pelota
int padIzq = 0;                       //Variable que define el pad izquierdo
int padDer = 0;                       //Variable que define el pad derecha
int x = 4;                            //Posicion de pelota en x
int y = 1;                            //Posicion de pelota en y
int dirx = 0;                         //Direccion en x
int diry = 0;                         //Direccion en y
int puntosIzq = 0;                    //Marcador izquierda
int puntosDer = 0;                    //Marcador derecha
bool banda = 0;                       //Bandera de pausa
//FIN VARIABLES DE JUEGO


void setup() {
  pinMode(pinDir, INPUT);
  pinMode(pinIzqUp, INPUT);
  pinMode(pinIzqDown, INPUT);
  pinMode(pinDerDown, INPUT);
  pinMode(pinDerUp, INPUT);
  pinMode(3, INPUT);
  for (int serial = 22; serial < 52; serial = serial + 2) {
    pinMode(serial, OUTPUT);
    if (serial + 2 < 38) {
      digitalWrite(serial, HIGH);
    }
  }
  sumador = 4;
  corrimiento = 0;
  rapidez = retraso = 4;
  inputEntrada.shutdown(0, false);
  inputEntrada.setIntensity(0, 8);
  inputEntrada.clearDisplay(0);
  borrador();
  Mensaje(Cont);
  pinMode(7, INPUT);


}

//Verifica el boton Start para entrar al juego o a pausa,luego se dirige a juego o a letrero dependiendo de Banderita
void loop() {
  verificarBotonStart();
  switch (banderita) {
    case true:
      jueguito();
      break;
    case false:
      Pantalla();
      break;
  }
}

//Sirve para verificar el tiempo de presionado del boton para acceder al juego o no.
void verificarBotonStart() {
  if (digitalRead(7) == HIGH) {
    Ctiempo = millis();
    while (digitalRead(7) == HIGH) {
      Ptiempo = millis();
      digitalRead(7);
    }
    Ttiempo = Ptiempo - Ctiempo;
    if (Ttiempo >= 3000) {//Si es mayor a 3 sec entra al juego
      banderita = 1;
      jueguito();
    }
    else                  //sino entra al mensaje
    {
      Pantalla();
    }
  }
}

//Sirve para verificar el tiempo de presionado del boton para acceder a la pausa.
void verificarBotonStart2() {//verifica si son 3 sec para salir
  if (digitalRead(7) == HIGH) {
    C1tiempo = millis();
    while (digitalRead(7) == HIGH) {
      P1tiempo = millis();
      digitalRead(7);
    }
    T1tiempo = P1tiempo - C1tiempo;
    if (T1tiempo >= 300) {//si es mayor a 3 sale
      banderita = 0;
    } else {              //sino solo quita la pausa
      banderita = 1;
    }
  }
}

//Controlador del juego e indicador decisiones del pong
void jueguito() {
  //primero limpiamos matriz
  puntosDer = puntosIzq = 0;
  borrador();
  Imprimir();
  while (banderita) {
    if (digitalRead(7) == HIGH && banda == 0) {
      banda = 1;
      delay(2);
    } else if (banda && digitalRead(7) == HIGH) {
      banda = 0;
      delay(2);
    }
    verificarBotonStart2();//verifica si en algun momento se ha pulsado 3 sec
    if (puntosDer == 4 || puntosIzq == 4) {
      mostrarPuntosTablero();
      delay(300);
      banderita = 0;
      break;
    } else if (banda) {
      mostrarPuntosTableroSinDel();
    } else {
      repetirJuego();
    }
  }
}

//Metodo que tienen las instrucciones de direccionamiento para el juego
void repetirJuego() {
  borrador();
  if (dirPelota == 0) {
    pelotita();
    dirPelota = velPelotita;
  } else {
    --dirPelota;
  }
  movJugadorIzq();
  movJugadorDer();
  tablero[padIzq][0] = tablero[padIzq + 1][0] = tablero[padIzq + 2][0] = 1;
  tablero[padDer][15] = tablero[padDer + 1][15] = tablero[padDer + 2][15] = 1;
  tablero[y][x] = 1;
  Imprimir();
  delay(retardoJuego);
}

//Metodo que cambio los bytes de las letras para mostrarlas
void Pivote() {
  if (++contFila == 8) {
    Cont = ++Cont % num;
    contFila = 0;
  }
}

//Metodo que maneja la velocidad y el direccionamiento del mensaje
void Pantalla() {
  int aumentaVelocidad = digitalRead(8);
  int disminuyeVelocidad = digitalRead(9);
  if (aumentaVelocidad)sumador = sumador + 2;
  if (disminuyeVelocidad)sumador = sumador - 2;
  switch (sumador) {
    case 0:
      rapidez = 0;
      break;
    case 2:
      rapidez = 2;
      break;
    case 4:
      rapidez = 4;
      break;
    case 6:
      rapidez = 6;
      break;
    case 8:
      rapidez = 8;
      break;
  }

  if (retraso >= rapidez) {
    Mensaje(Cont);  /*MENSAJE DONDE SE MANDA COMO PARAMETRO EL CONTADOR PARA HACER EL CAMBIO DE BYTES*/
  }
  else {
    retraso++;
  }
  Imprimir();


  int bandera = digitalRead(10);
  if (bandera) {
    if (derizq == 1) derizq = 0;
    else derizq = 1;
  }
}

//metodo que muestra y desplaza el mensaje
void Mensaje(int num1)  { /*el parametro num1 es el contador que recibe mas arriba y num1 es el primer corchete del letrero definido mas arriba que es numero de byte*/
  for (int fila = 0; fila < 8; fila++) {
    int limite = 0;
    for (int columna = 0; columna < 16; columna++) {
      if (columna + corrimiento < 16 ) {
        tablero[fila][columna] = letrero[num1][fila][columna + corrimiento];
      } else {
        tablero[fila][columna] = letrero[num1][fila][limite++];
      }
    }
  }

  if (derizq) {
    if (corrimiento < 16) corrimiento++;
    else corrimiento = 0;
  } else {
    if (corrimiento > 0) corrimiento--;
    else corrimiento = 16;
  }
  retraso = 0;
}


//Metodo que muestra la matriz
void Imprimir() {
  Pivote();

  for (int x = 0; x < 8; x++) {
    for (int y = 8; y < 16; y++) {
      if (tablero[x][y] == 1){
        inputEntrada.setLed(0, x, y - 8, true);
      }else{
        inputEntrada.setLed(0, x, y - 8, false);
      }
    }
  }
  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
      int par = y * 2;
      if (tablero[x][y] == 1)  digitalWrite(38 + par , HIGH);
      else digitalWrite(38 + par, LOW);
    }
    int par2 = x * 2;
    digitalWrite(22 + par2, LOW);
    delay(2);
    digitalWrite(22 + par2, HIGH);
  }

  inputEntrada.clearDisplay(0);
  for (int serial = 38; serial < 53; serial = serial + 2){
    digitalWrite(serial, LOW);
  }
}

//Metodo para el moviemiento de jugador izquierdo
void movJugadorIzq() {
  int lector = digitalRead(pinIzqUp);
  if (lector) {
    if (padIzq != 5) {

      padIzq++;
    }
  }
  int lector1 = digitalRead(pinIzqDown);
  if (lector1) {
    if (padIzq != 0) {
      padIzq--;
    }
  }
}

//Metodo para el moviemiento de jugador derecho
void movJugadorDer() {
  int lector = digitalRead(pinDerUp);
  if (lector) {
    if (padDer != 5) {
      padDer++;
    }
  }
  int lector1 = digitalRead(pinDerDown);
  if (lector1) {
    if (padDer != 0) {
      padDer--;
    }
  }
}


//Metodo que sirve para limpiar la matriz
void borrador() {
  for (int i = 0; i < 8; ++i)
  {
    for (int j = 0; j < 16; ++j)
    {
      tablero[i][j] = 0;
    }
  }
}

//Metodo para cambiar la direccion de la pelota
void pelotita() {
  if (dirx == 0)
  {
    x++;
  } else {
    x--;
  }

  if (diry == 0)
  {
    y++;
  } else {
    y--;
  }
  verificador();
  metaDerecha();
  metaIzquierda();
}

//Metodo que verifica los limites de la matriz
void verificador() {
  if (y == 7) {
    diry = 1;
  }
  if (x == 15) {
    dirx = 1;
  }
  if (y == 0) {
    diry = 0;
  }
  if (x == 0) {
    dirx = 0;
  }
}

//Puntajes derecho, izquierdo y mostrar tablero en pantalla
void metaDerecha() {
  if (x == 15 && !(y == padDer || y == padDer + 1 || y == padDer + 2)) {
    ++puntosIzq;
    mostrarPuntosTablero();
  }
}

void metaIzquierda() {
  if (x == 0 && !(y == padIzq || y == padIzq + 1 || y == padDer + 2)) {
    ++puntosDer;
    mostrarPuntosTablero();
  }
}

void mostrarPuntosTablero() {
  borrador();
  for (int i = 0; i < 8; ++i){
    for (int j = 0; j < 8; ++j){
      tablero[i][j] = pnts[puntosIzq][i][j];
    }
  }

  for (int i = 0; i < 8; ++i){
    for (int j = 8; j < 16; ++j){
      tablero[i][j] = pnts[puntosDer][i][j - 8];
    }
  }

  int temporal = 25;
  while (true) {
    Imprimir();
    --temporal;
    if (temporal == 0) {
      break;
    }
  }
}


void mostrarPuntosTableroSinDel() {
  borrador();
  for (int i = 0; i < 8; ++i){
    for (int j = 0; j < 8; ++j){
      tablero[i][j] = pnts[puntosIzq][i][j];
    }
  }
  for (int i = 0; i < 8; ++i){
    for (int j = 8; j < 16; ++j){
      tablero[i][j] = pnts[puntosDer][i][j - 8];
    }
  }
  Imprimir();
}
