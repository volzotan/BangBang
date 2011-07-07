// controlP5
import controlP5.*;

// GUI
ControlP5 controlP5;
PImage playImage, pauseImage;
PShape klecks;

// Minim
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*; 
 
// Audio Player, Beat detection
Minim minim;
AudioPlayer player;
BeatDetect beat;

// Canvas setup 
PImage bufSlice;
PGraphics buf;
int copyOffsetX, copyOffsetY, copyWidth, copyHeight, prevOffsetX = 0, prevOffsetY = 0;

// Vignette / Background image 
PImage vignette, bgCanvas;
 
// Viewport-Initialisierung / Viewport-Bewegungsvariablen
float x = 400;
float y = 225;          // Legt Position des Viewports bei Initialisierung fest

// Protected zone (rectangle) around the relative center in which scrolling doesn't happen, 0 = no such zone
int groesseSchutzzoneX = 0; 
int groesseSchutzzoneY = 0;

// dampen mouse movements for brush following
float verfolgungsDaempfungX = 10;
float verfolgungsDaempfungY = 10;

// Global auto-scrolling value
float scrollGeschwindigkeit = 10;
int autoScrollX = 0;
int autoScrollY = 0;
// Direction; constant scrolling in any direction without any mouse movements
float xRichtungsFaktor = 10, yRichtungsFaktor = 0;
  
int xPosKoord = copyOffsetX + (int) xRichtungsFaktor;
int yPosKoord = copyOffsetY + (int) yRichtungsFaktor;

// use this with % to execute functions at every nth draw execution
int drawCounter = 0;

// MiniMap; Initialpositionierung des Viewport-Rechtecks (abhängig von x,y in Z. 17) wird aber sofort bei Programmstart überschrieben  
int miniMapPosX = 0, miniMapPosY = 0;
PImage scaledMiniMap;

// Brush
int angle = 0;

// Variablen zur Kontrolle des Brushes
int deltaMouseX = 0;
int deltaMouseY = 450;
int[] lastMousePosX = new int[30], lastMousePosY = new int[30];

// Particle System
ParticleSystem ps;

// setup
boolean initialised = false, doClear = false;

void setup(){
  size(800, 450, JAVA2D);
  frameRate(30);

  initCanvas(true);
  initVignette();
  initImages();
  setupGUI();
 
  copyOffsetX = 0;
  copyOffsetY = (buf.height - height) / 2;      // startet am linken äußeren Rand in der Mitte
  copyWidth = width;
  copyHeight = height;
  
  // load and instantiate audio player
  minim = new Minim(this);
  player = minim.loadFile("bangbang.mp3");
  beat = new BeatDetect();

  scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
  scaledMiniMap.resize(0, 18);                // resize-Wert ist buf.height/50
  
  ps = new ParticleSystem(1, new PVector(width/2,height/2,0));
  
  deltaMouseX = 470;
  deltaMouseY = 450;
}

void draw(){
  if(doClear) {
    initCanvas(true);
    doClear = false;
    initialised = false;
    player.pause();
    player.rewind();
  }
  
  if(!initialised) {
    image(getBufSlice(), 0, 0);
    image(playImage, 0, 0);
    drawGUI();
  } else {  
    controlP5.hide();
    beat.detect(player.mix);
     
    x = x + (mouseX-x)/verfolgungsDaempfungX;
    y = y + (mouseY-y)/verfolgungsDaempfungY;
    drawCounter++;
      
    if(player.isPlaying()) {
      moveViewport();
      buf.beginDraw();
      if (drawCounter % 1 == 0) {
        brushThree();      
      }
      if (drawCounter % 3 == 0) {
   
        castEffect();
      }      
      buf.endDraw();
    
      ps.run();
      ps.addParticle(mouseX,mouseY);
      drawVignette();
      drawMiniMap();      
    } else {
      image(getBufSlice(), 0, 0);
      image(pauseImage, 0, 0);      
    }  
  
    if (drawCounter % 3 == 0) {
      prevOffsetX = copyOffsetX;
      prevOffsetY = copyOffsetY;
    }   
  }

  // Mittelpunkt des Pinsels abgreifen zur Verwendung für Effekte
  if(drawCounter % 1 == 0) {                              
    lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
    lastMousePosY[drawCounter%30] = (int) y + copyOffsetY;
  }
  println(frameRate + " at " + player.position());
}
  
void stop() {                                       // Minim Stop
  player.close();
  minim.stop();
  super.stop();
}
