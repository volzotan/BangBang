/*  Fehler beim Ellipsenzeichen im Zusammenhang mit x + copyOffsetX (Zeichnen über den Rand)
 *  Fehler beim Viewport-Verschieben im oberen linken Quadranten
 *
 *  Schutzzone wirklich sinnvoll bei konstantem Scrollen?
 *
 */
 

// Minim

import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*; 
 
// Audio Player
Minim minim;
AudioPlayer player;
BeatDetect beat;

 
PImage bufSlice;
PGraphics buf;
int copyOffsetX;
int copyOffsetY;
int copyWidth;
int copyHeight;

int prevOffsetX;
int prevOffsetY;
 
float x = 400;
float y = 225;

int groesseSchutzzoneX = 0;            // in Ausdehnung um relativen Nullpunkt in alle Richtungen
int groesseSchutzzoneY = 0;            // 0 = deaktiviert


// Dynamik
float verfolgungsDaempfungX = 10;
float verfolgungsDaempfungY = 10;

float scrollGeschwindigkeit = 10;

int autoScrollX = 0;
int autoScrollY = 0;


// Optimierung                        // funktioniert in dem bestimme Operationen nur bei jedem 2.,3.,... draw() ausgeführt werden 
int drawCounter = 0;
int frameToSkip = 0;

// Vignette
PShape vignette;

// Richtung

  float xRichtungsFaktor = 1;
  float yRichtungsFaktor = 0;        // ohne Mauseinwirkung konstantes Scrollen nach Rechts
  
  int xPosKoord = copyOffsetX + (int) xRichtungsFaktor;
  int yPosKoord = copyOffsetY + (int) yRichtungsFaktor;


// MiniMap

int miniMapPosX = 0;                // Initialpositionierung des Viewport-Rechtecks (abhängig von x,y in Z. 17)
int miniMapPosY = 0;                // wird aber sofort bei Programmstart überschrieben  


// Brush
int angle = 0;


// Experimental

PImage zoomImg;
float val;
boolean zoomAnimation = false;

void setup(){
  size(800, 450);
  frameRate(24);

  buf = createGraphics(8000, 1350, JAVA2D);
  buf.beginDraw();
    buf.smooth();
    buf.background(240);
  buf.endDraw();
 
  copyOffsetX = 0;
  copyOffsetY = (buf.height - height) / 2;      // startet am linken äußeren Rand in der Mitte
  copyWidth = width;
  copyHeight = height;
  
  // load and instantiate audio player
  minim = new Minim(this);
  player = minim.loadFile("bangbang.mp3");
  beat = new BeatDetect();
  player.play();

}

void draw(){
  //x = x + ((mouseX-x)/verfolgungsDaempfung);
 
 if (!zoomAnimation) {
 x = x + (mouseX-x)/verfolgungsDaempfungX;
 y = y + (mouseY-y)/verfolgungsDaempfungY;
 drawCounter++;
  
  moveViewport();
  
  drawMiniMap();
  
  buf.beginDraw();
  if (drawCounter % 2 == frameToSkip && player.isPlaying()) {
    //buf.ellipse(x + copyOffsetX, y + copyOffsetY, 5, 5);
    //useBrush();
    drawBrush(3);
  }
  buf.endDraw();
  
  if (drawCounter % 3 == 0) {
    prevOffsetX = copyOffsetX;
    prevOffsetY = copyOffsetY;
  }
  
  if (keyCode == UP) {
    zoomAnimation = true;
    //val = buf.height;
    val = 1;
  } 
 } else {
  zoomImg = buf.get(0, 0, buf.width, buf.height); // mehrfaches Anwenden von resize auf die gleiche Grafik führt zu Informationsverlust im Bild
  /*val = val - (val - height)/10;                // resize und scale sind genauso langsam
  zoomImg.resize(0,(int) val);
  */
  val = val - (val - 0.5)/10;
  scale(val);
  image(zoomImg, 0 ,0);
 
 
 }
  // rect(350,175,100,100); // Schutzzone eingeblendet
}

void useBrush() {
  angle += 10;
    float val = cos(radians(angle)) * 10.0;
    for (int a = 0; a < 360; a += 10) {
      float xoff = cos(radians(a)) * val;
      float yoff = sin(radians(a)) * val;
      fill(0);
      buf.ellipse(x + copyOffsetX + xoff, y + copyOffsetY + yoff + player.left.get(0) * 50, val, val);
    }
    fill(255);
    //buf.ellipse(x + copyOffsetX, y + copyOffsetY, 2 * player.left.get(0) * 50, 2 * player.right.get(0) * 50);
    buf.ellipse(x + copyOffsetX, y + copyOffsetY + player.left.get(0) * 50, 2 , 2 /* * player.right.get(0) * 50*/ );
}

void moveViewport(){ 
  image(getBufSlice(), 0, 0);
  
  float xPos = mouseX-width/2;  // xPos,yPos sind Koordinaten relativ zum Mittelpunkt
  float yPos = mouseY-height/2;
  
  if (drawCounter % 2 == 0) {
    if ((abs(xPos) >  groesseSchutzzoneX ) || (abs(yPos) >  groesseSchutzzoneY )) {          // Schutzzone
      
      yPos = yPos * 1.7;        // "normalisiert" den Richtungsvektor den yPos darstellt
      
      xRichtungsFaktor = (xPos / (abs(xPos) + abs(yPos)));
      yRichtungsFaktor = (yPos / (abs(xPos) + abs(yPos)));
      
    }
  }

  float xBeschleunigungsFaktor = xRichtungsFaktor * scrollGeschwindigkeit + autoScrollX;    // AutoScrolling unabhängig vom Beschleunigungsfaktor
  float yBeschleunigungsFaktor = yRichtungsFaktor * scrollGeschwindigkeit + autoScrollY;
  
  xPosKoord = copyOffsetX + (int) xBeschleunigungsFaktor;
  yPosKoord = copyOffsetY + (int) yBeschleunigungsFaktor;
  
  if(xPosKoord > buf.width - width) {
      xPosKoord = buf.width - width;
    } else if(xPosKoord < 0) {
      xPosKoord = 0;
   }
  
   if(yPosKoord > buf.height - height) {
      yPosKoord = buf.height - height;
    } else if(yPosKoord < 0) {
      yPosKoord = 0;
   }
  
  
  
  copyOffsetX = xPosKoord;
  copyOffsetY = yPosKoord;
}


void drawMiniMap(){
 stroke(0,0,0);
 strokeWeight(1);
 fill(255,255,255);
 rect(630,10,160,27);
 
 if (drawCounter % 3 == 0) {
   miniMapPosX = calcMiniMapPosX() + 630;
   miniMapPosY = calcMiniMapPosY() + 10;
 }
 
 rect(miniMapPosX, miniMapPosY, 16, 9);
}

int calcMiniMapPosX() {
  float diffX =  (copyOffsetX / (buf.width/100));  // Prozentualer Vorrückungsgrad
  
  float verschiebungX = 1.6 * diffX;
  return (int) verschiebungX;
}

int calcMiniMapPosY() {
  float diffY =  (copyOffsetY / (buf.height/100));  // Prozentualer Vorrückungsgrad
  
  float verschiebungY = 0.27 * diffY;
  return (int) verschiebungY;
}

PImage getBufSlice() {
  return buf.get(copyOffsetX, copyOffsetY, copyWidth, copyHeight);
}


void stop() {                                       // Minim Stop
  player.close();
  minim.stop();
  super.stop();
}
