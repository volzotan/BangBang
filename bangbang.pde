
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

int prevOffsetX = 0;
int prevOffsetY = 0;
 
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

// Vignette / Hintergrund
PImage vignette;
PImage bgCanvas;


// Richtung

float xRichtungsFaktor = 10;
float yRichtungsFaktor = 0;        // ohne Mauseinwirkung konstantes Scrollen nach Rechts
  
int xPosKoord = copyOffsetX + (int) xRichtungsFaktor;
int yPosKoord = copyOffsetY + (int) yRichtungsFaktor;


// MiniMap

int miniMapPosX = 0;                // Initialpositionierung des Viewport-Rechtecks (abhängig von x,y in Z. 17)
int miniMapPosY = 0;                // wird aber sofort bei Programmstart überschrieben  


// Brush
int angle = 0;


// Experimental
PImage scaledMiniMap;

// Variablen zum Effektezeichnen

int mousePosX = 0;
int mousePosY = 0;
int[] lastMousePosX = new int[30];
int[] lastMousePosY = new int[30];


void setup(){
  size(800, 450);
  frameRate(30);

  bgCanvas = loadImage("bg_leinwand.jpg");

  buf = createGraphics(8000, 900, JAVA2D);
  buf.beginDraw();
  buf.smooth();
  buf.background(bgCanvas);
  buf.endDraw();
 
  copyOffsetX = 0;
  copyOffsetY = (buf.height - height) / 2;      // startet am linken äußeren Rand in der Mitte
  copyWidth = width;
  copyHeight = height;
  
  // load and instantiate audio player
  minim = new Minim(this);
  player = minim.loadFile("bangbang.mp3");
  //beat = new BeatDetect();
  player.play();

  scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
  scaledMiniMap.resize(0, 18);                // resize-Wert ist buf.height/50
}

void draw(){
  //x = x + ((mouseX-x)/verfolgungsDaempfung);
 
 x = x + (mouseX-x)/verfolgungsDaempfungX;
 y = y + (mouseY-y)/verfolgungsDaempfungY;
 drawCounter++;
  
 moveViewport();
  
 drawVignette();  
 drawMiniMap();
  
 buf.beginDraw();
 if (drawCounter % 2 == frameToSkip && player.isPlaying()) {
   //buf.ellipse(x + copyOffsetX, y + copyOffsetY, 5, 5);
   BrushOne();
   //println(player.position());
 }
 buf.endDraw();
  
 if (drawCounter % 3 == 0) {
   prevOffsetX = copyOffsetX;
   prevOffsetY = copyOffsetY;
 }

 if (drawCounter % 3 == 0 && player.isPlaying()) {
   mousePosX = copyOffsetX + mouseX;
   mousePosY = copyOffsetY + mouseY;
   
   castEffect();
 }

 println(frameRate);
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

boolean testOnCanvasX(int xPosCoord) {
    if(xPosKoord > buf.width - width) {
      return false;
    } else if(xPosKoord < 0) {
      return false;
   }
   
   return true;
}

boolean testOnCanvasY(int yPosCoord) {
    if(yPosKoord > buf.height - height) {
      return false;
    } else if(yPosKoord < 0) {
      return false;
   }
   
   return true;
}

void drawVignette(){
  vignette = loadImage("vignette.png");
  image(vignette, 0, 0);
}

void drawMiniMap(){
 // rgb stroke black
 stroke(0,0,0,90);
 // stroke width 1 pixel
 strokeWeight(1);
 // rgb fill fully transparent
 fill(0,0,0,50);
 // minimap window position
 rect(629,9,161,19);                              // breite und höhe sind buf.width/50+2 bzw. buf.height/50+2
 
 if (drawCounter % 5 == 0) {
   scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
   scaledMiniMap.resize(0, 18);                   // resize-Wert ist buf.height/50
 }
 image(scaledMiniMap, 630, 10);                    
 
 if (drawCounter % 3 == 0) {
   miniMapPosX = calcMiniMapPosX() + 630;
   miniMapPosY = calcMiniMapPosY() + 10;
 }
 
  // rgb stroke black
 stroke(0,0,0,0);
 
 rect(miniMapPosX, miniMapPosY, 16, 9);
}

int calcMiniMapPosX() {
  float diffX =  (copyOffsetX / (buf.width/100));  // Prozentualer Vorrückungsgrad
  
  float verschiebungX = 1.6 * diffX;                // Konstante ist buf.width/50/100
  return (int) verschiebungX;
}

int calcMiniMapPosY() {
  float diffY =  (copyOffsetY / (buf.height/100));  // Prozentualer Vorrückungsgrad
  
  float verschiebungY = 0.18 * diffY;              // Konstante ist buf.width/50/100
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

