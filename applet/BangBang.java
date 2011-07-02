import processing.core.*; 
import processing.xml.*; 

import ddf.minim.*; 
import ddf.minim.signals.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class BangBang extends PApplet {


// Minim




 
 
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


// Optimierung                        // funktioniert in dem bestimme Operationen nur bei jedem 2.,3.,... draw() ausgef\u00fchrt werden 
int drawCounter = 0;
int frameToSkip = 0;

// Vignette
PShape vignette;

// Richtung

  float xRichtungsFaktor = 10;
  float yRichtungsFaktor = 0;        // ohne Mauseinwirkung konstantes Scrollen nach Rechts
  
  int xPosKoord = copyOffsetX + (int) xRichtungsFaktor;
  int yPosKoord = copyOffsetY + (int) yRichtungsFaktor;


// MiniMap

int miniMapPosX = 0;                // Initialpositionierung des Viewport-Rechtecks (abh\u00e4ngig von x,y in Z. 17)
int miniMapPosY = 0;                // wird aber sofort bei Programmstart \u00fcberschrieben  


// Brush
int angle = 0;


// Experimental
PImage scaledMiniMap;

public void setup(){
  size(800, 450);
  frameRate(24);

  buf = createGraphics(8000, 1350, JAVA2D);
  buf.beginDraw();
    buf.smooth();
    buf.background(240);
  buf.endDraw();
 
  copyOffsetX = 0;
  copyOffsetY = (buf.height - height) / 2;      // startet am linken \u00e4u\u00dferen Rand in der Mitte
  copyWidth = width;
  copyHeight = height;
  
  // load and instantiate audio player
  minim = new Minim(this);
  player = minim.loadFile("bangbang.mp3");
  //beat = new BeatDetect();
  player.play();

  scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
   scaledMiniMap.resize(0, 27);
}

public void draw(){
  //x = x + ((mouseX-x)/verfolgungsDaempfung);
 
 x = x + (mouseX-x)/verfolgungsDaempfungX;
 y = y + (mouseY-y)/verfolgungsDaempfungY;
 drawCounter++;
  
  moveViewport();
  
  drawMiniMap();
  
  buf.beginDraw();
  if (drawCounter % 2 == frameToSkip && player.isPlaying()) {
    //buf.ellipse(x + copyOffsetX, y + copyOffsetY, 5, 5);
    useBrush();
    //drawBrush(3);
  }
  buf.endDraw();
  
  if (drawCounter % 3 == 0) {
    prevOffsetX = copyOffsetX;
    prevOffsetY = copyOffsetY;
  }

  // rect(350,175,100,100); // Schutzzone eingeblendet

}

public void useBrush() {
  angle += 10;
    float val = cos(radians(angle)) * 10.0f;
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

public void moveViewport(){ 
  image(getBufSlice(), 0, 0);

  float xPos = mouseX-width/2;  // xPos,yPos sind Koordinaten relativ zum Mittelpunkt
  float yPos = mouseY-height/2;
  
  if (drawCounter % 2 == 0) {
    if ((abs(xPos) >  groesseSchutzzoneX ) || (abs(yPos) >  groesseSchutzzoneY )) {          // Schutzzone
      
      yPos = yPos * 1.7f;        // "normalisiert" den Richtungsvektor den yPos darstellt
      
      xRichtungsFaktor = (xPos / (abs(xPos) + abs(yPos)));
      yRichtungsFaktor = (yPos / (abs(xPos) + abs(yPos)));
      
    }
  }

  float xBeschleunigungsFaktor = xRichtungsFaktor * scrollGeschwindigkeit + autoScrollX;    // AutoScrolling unabh\u00e4ngig vom Beschleunigungsfaktor
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


public void drawMiniMap(){
 stroke(0,0,0);
 strokeWeight(1);
 fill(255,255,255,255);
 rect(630,10,160,27);
 
 if (drawCounter % 5 == 0) {
   scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
   scaledMiniMap.resize(0, 27);
 }
 image(scaledMiniMap, 630, 10);
 
 if (drawCounter % 3 == 0) {
   miniMapPosX = calcMiniMapPosX() + 630;
   miniMapPosY = calcMiniMapPosY() + 10;
 }
 
 rect(miniMapPosX, miniMapPosY, 16, 9);
}

public int calcMiniMapPosX() {
  float diffX =  (copyOffsetX / (buf.width/100));  // Prozentualer Vorr\u00fcckungsgrad
  
  float verschiebungX = 1.6f * diffX;
  return (int) verschiebungX;
}

public int calcMiniMapPosY() {
  float diffY =  (copyOffsetY / (buf.height/100));  // Prozentualer Vorr\u00fcckungsgrad
  
  float verschiebungY = 0.27f * diffY;
  return (int) verschiebungY;
}

public PImage getBufSlice() {
  return buf.get(copyOffsetX, copyOffsetY, copyWidth, copyHeight);
}


public void stop() {                                       // Minim Stop
  player.close();
  minim.stop();
  super.stop();
}
/**
 * Zu verwendende Parameter
 *   ?
 * Fehlende Implementierungen:
 *
 * Probleme:
 * Alle Zeichenanweisungen die au\u00dferhalb der Methoden unten 
 * stattfinden m\u00fcssen Stroke, Fill, etc wieder auf einen Basiswert zur\u00fccksetzen
 */
 /*
void drawBrush() {
  drawBrush(0); 
}  
 
void drawBrush(int BrushId) {
  switch(BrushId) {
    case 1: BrushOne();   break;  
    case 2: BrushTwo();   break;  
    case 3: BrushThree(); break;  
    case 4: BrushFour();  break;  
    case 5: BrushFive();  break;    
    default: BrushOne();
  }  
}
*/
/** 
 * "Stempel" mit 5 Ellipsen im Pentagram
 */
public void BrushOne() {
  angle += 10;
  float val = cos(radians(angle)) * 10.0f;
  for (int a = 0; a < 360; a += 10) {
    float xoff = cos(radians(a)) * val;
    float yoff = sin(radians(a)) * val;
    fill(0);
    buf.ellipse(x + copyOffsetX + xoff, y + copyOffsetY + yoff + player.left.get(0) * 50, val, val);
  }
  buf.fill(255);
  //buf.ellipse(x + copyOffsetX, y + copyOffsetY, 2 * player.left.get(0) * 50, 2 * player.right.get(0) * 50);
  //buf.ellipse(x + copyOffsetX, y + copyOffsetY + player.left.get(0) * 50, 2 , 2 /* * player.right.get(0) * 50*/ );
}

public void BrushTwo() {
   
}

/**
 * Kontinuierliche Linien
 * TODO Die Linie ist nicht kontinuierlich
 */
public void BrushThree() {
    buf.stroke(0,0,0);
    buf.strokeWeight(10);
    buf.line(mouseX + copyOffsetX, mouseY + copyOffsetY, pmouseX + prevOffsetX, pmouseY + prevOffsetY);    
}

/**
 * http://processing.org/learning/basics/bezierellipse.html
 */
public void BrushFour() {
   
}

/**
 * http://processing.org/learning/topics/softbody.html
 */
public void BrushFive() {
   
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#D4D0C8", "BangBang" });
  }
}
