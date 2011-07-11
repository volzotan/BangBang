// controlP5
import controlP5.*;

// GUI
ControlP5 setupP5, breakP5, endP5;
PImage mainButtonImage, menuButtonImage, mapEButtonImage, mapDButtonImage, exitButtonImage, demoButtonImage, saveButtonImage, savingImage, overlayImage, cursorImage;
boolean usePlay = true;
boolean mapEnabled = false;

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

// ---- Colors ----
int cR1 = 100, cR2 = 145, cR3 =   0, cR4 =   0, cR5 =   0;
int cG1 = 100, cG2 = 145, cG3 =   0, cG4 =   0, cG5 =   0;
int cB1 = 100, cB2 = 145, cB3 =   0, cB4 =   0, cB5 =   0;
int cA1 = 255, cA2 = 255, cA3 =   0, cA4 =   0, cA5 =   0;

// direction sensitive drawing
int[] directionArrayX = new int[10];
int[] directionArrayY = new int[10];

// EXPERIMENTAL
boolean drawSaveOverlay = false;
int saveReady = 0;

// setup
boolean initialised = false, doClear = false;
int switchCursor = 0; //1 = blank/hidden, 2 = regular arrow, else do nothing
int wasGUI = 0;

void setup(){
  size(800, 450, JAVA2D);
  frameRate(30);

  if(doClear) {
    player.pause();
    player.rewind();
    doClear = false;
    initialised = false;
    wasGUI = 0;
        
    // reset inkSplatter
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
  }

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
  
  deltaMouseX = 470;
  deltaMouseY = 450;
}

void draw(){  
  if (saveReady == 2) {
    if(initialised) {  
      buf.save(dataPath("shots/"+timestamp() +".png"));   
    } 
    if(initialised && player.position() < 47986 && wasGUI > 0) {
      player.play(); 
    } 
    saveReady = 0;
  }
  
  if(!initialised) {
    switchCursor(2);
    image(getBufSlice(), 0, 0);
    image(overlayImage, 0, 0);
    drawGUI(1);
  } else {  
    closeGUI(1);
    beat.detect(player.mix);
    if(beat.isOnset()) {
       tempBrushValue = 80; 
    }
           
    x = x + (mouseX-x)/verfolgungsDaempfungX;
    y = y + (mouseY-y)/verfolgungsDaempfungY;
    drawCounter++;
    pos = player.position();
      
    if(player.isPlaying() && player.position() < 47986) {
      switchCursor(1);
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
    
      drawVignette(true);
      drawMiniMap(mapEnabled);       
      tempBrushValue *= 0.95;     
    } else {
      switchCursor(2);
      if (player.position() < 47986 && !drawSaveOverlay) {
        image(getBufSlice(), 0, 0);
        image(overlayImage, 0, 0);
        drawGUI(2); 
      } else if (!drawSaveOverlay) {
        image(getBufSlice(), 0, 0);        
        image(overlayImage, 0, 0);
        drawGUI(3);     
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
  
  
  if(drawSaveOverlay){
    image(getBufSlice(), 0, 0);
    image(savingImage, 0, 0);
    
    if (saveReady == 0) {
      saveReady = 1;
    } else if (saveReady == 1) {
      saveReady = 2;
      drawSaveOverlay = false;
    }
  }
 
}
  
void stop() {                                       // Minim Stop
  player.close();
  minim.stop();
  super.stop();
}
