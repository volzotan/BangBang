// controlP5
import controlP5.*;

// GUI
ControlP5 controlP5;
PImage playImage, pauseImage, replayImage;
boolean usePlay = true;

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
float scrollGeschwindigkeit = 6;
int autoScrollX = 0;
int autoScrollY = 0;
// Direction; constant scrolling in any direction without any mouse movements
float xRichtungsFaktor = 10, yRichtungsFaktor = 0;
  
int xPosKoord = copyOffsetX + (int) xRichtungsFaktor; // TODO Comment!
int yPosKoord = copyOffsetY + (int) yRichtungsFaktor; // TODO Comment!

// use this with % to execute functions at every nth draw execution
int drawCounter = 0;

// MiniMap; Initialpositionierung des Viewport-Rechtecks (abhängig von x,y in Z. 17) wird aber sofort bei Programmstart überschrieben  
int miniMapPosX = 0, miniMapPosY = 0;
PImage scaledMiniMap;

// Brush
int angle = 0, tempBrushValue;

// Variablen zur Kontrolle des Brushes
int deltaMouseX = 0;
int deltaMouseY = 450;
int[] lastMousePosX = new int[30], lastMousePosY = new int[30];

// ---- Effects ----
// player position
int pos = 0;
// ink splatter array
PImage inkSplatter[] = new PImage[10];
// last used quadrant: 0 (top right), 1 (top left), 2 (bottom left), 3 (bottom right)
int inkSplatterPos = 0;
boolean
  inkSplatter01Used = false,
  inkSplatter02Used = false,
  inkSplatter03Used = false,
  inkSplatter04Used = false,
  inkSplatter05Used = false,
  inkSplatter06Used = false,
  inkSplatter07Used = false,
  inkSplatter08Used = false,
  inkSplatter09Used = false,
  inkSplatter10Used = false;
// Bird flock
Flock flock;

// Particle System
// ParticleSystem ps;

// ---- Colors ----
int cR1 = 100, cR2 = 145, cR3 =   0, cR4 =   0, cR5 =   0;
int cG1 = 100, cG2 = 145, cG3 =   0, cG4 =   0, cG5 =   0;
int cB1 = 100, cB2 = 145, cB3 =   0, cB4 =   0, cB5 =   0;
int cA1 = 255, cA2 = 255, cA3 =   0, cA4 =   0, cA5 =   0;

// EXPERIMENTAL
int[] directionArrayX = new int[10];
int[] directionArrayY = new int[10];

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
  player = minim.loadFile("BettyChungBangBang.mp3");
  beat = new BeatDetect();

  scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
  scaledMiniMap.resize(0, 18);                // resize-Wert ist buf.height/50
  
  //ps = new ParticleSystem(0, new PVector(width/2,height/2,0));
  flock = new Flock();
  boolean initFlock = false;
  
  deltaMouseX = 470;
  deltaMouseY = 450;
}

void draw(){
  if(doClear) {
    initCanvas(true);
    doClear = false;
    initialised = false;
    
    // Reset inkSplatter
    inkSplatter01Used = false;
    inkSplatter02Used = false;
    inkSplatter03Used = false;
    inkSplatter04Used = false;
    inkSplatter05Used = false;
    inkSplatter06Used = false;
    inkSplatter07Used = false;
    inkSplatter08Used = false;
    inkSplatter09Used = false;
    inkSplatter10Used = false;
  
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
    if(beat.isOnset()) {
       tempBrushValue = 80; 
    }
           
    x = x + (mouseX-x)/verfolgungsDaempfungX;
    y = y + (mouseY-y)/verfolgungsDaempfungY;
    drawCounter++;
    pos = player.position();
      
    if(player.isPlaying() && player.position() < 47986) {
      moveViewport();
      buf.beginDraw();
      if (drawCounter % 1 == 0) {        
        brushThree();
      }      
      directionArrayX[drawCounter % 10] = (int) x + copyOffsetX;
      directionArrayY[drawCounter % 10] = (int) y + copyOffsetY;
      
      if (drawCounter % 2 == 0) {
        castEffect();
      }      
      buf.endDraw();
    
      //ps.run();
      flock.run();
      drawVignette();
      drawMiniMap();       
      tempBrushValue *= 0.95;      
    } else {
      if (player.position() < 47986) {
        image(getBufSlice(), 0, 0);
        image(pauseImage, 0, 0);    
      } else {
        //moveViewport();
        //drawVignette();
        //drawMiniMap();
        image(getBufSlice(), 0, 0);        
        image(replayImage, 0, 0);    
        drawGUI();     
      }     
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
  //println(frameRate + " at " + player.position());
}
  
void stop() {                                       // Minim Stop
  player.close();
  minim.stop();
  super.stop();
}
