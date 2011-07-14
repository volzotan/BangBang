// Event Handling Ressources
import java.util.Timer;
import java.util.TimerTask;
// timer
Timer timer = new Timer();
int elapsedTime = 0;

// controlP5
import controlP5.*;
// GUI
ControlP5 setupP5, breakP5, endP5;
PImage mainButtonImage, menuButtonImage, resetButtonImage, mapEButtonImage, mapDButtonImage, exitButtonImage, demoButtonImage, saveButtonImage, savingImage, overlayImage, cursorImage_blank, cursorImage_circle, cursorImage_nyancat;
PImage tempMenuBG, tempBufSlice;
boolean mapEnabled = false, cursorEnabled = true, useNyancat = false, doCapture; // doCapture = still photo flag

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
float verfolgungsDaempfungX = 9;
float verfolgungsDaempfungY = 9;
// Global auto-scrolling value
final float scrollGeschwindigkeit = 6;
float tempScrollGeschwindigkeit = scrollGeschwindigkeit;
int autoScrollX = (int) (scrollGeschwindigkeit/2);
int autoScrollY = 0;
// Direction; constant scrolling in any direction without any mouse movements
float xRichtungsFaktor = 10, yRichtungsFaktor = 0;
// WHAT DO THESE DO? 
int xPosKoord = copyOffsetX + (int) xRichtungsFaktor;
int yPosKoord = copyOffsetY + (int) yRichtungsFaktor;

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
int inkSplatterPos;

// ---- Nyancat
color nyanColor = color(255,  42,  12);
int tempNyanPos, tempNyanCol;

// direction sensitive drawing
int[] directionArrayX = new int[10];
int[] directionArrayY = new int[10];

// ---- Save Overlay
int saveReady = 0;
boolean drawSaveOverlay = false;

int brushThreeSkalierungAusschlag = 100;
int invsVar = 1;
int amp = 200;
float xPlus = 0;
boolean ghostBrush = false;
int oldX, oldDeltaX;
int oldY, oldDeltaY;
boolean firstRun;
boolean mainBrushActive;

int tempX, tempY;

// setup
boolean initialised, doClear = false, doInvert = false;
// switch Cursor: 1 = pfeil, 2 = leer, 3 = custom, else do nothing; wasGUI: previous GUI number
int switchCursor, wasGUI;
String savePath;
// use this with % to execute functions at every nth draw execution
int drawCounter = 0;

void setup(){
  initEventArrays();
  elapsedTime = 0;
  
  mainBrushActive = true;
  tempNyanPos = 0;

  switchCursor = 0;
  
  savePath = "";
  
  doCapture = true;  
  wasGUI = 0;
  
  inkSplatterPos = 0;
  initialised = false;
  
  oldX = 400;
  oldY = 225;
  amp = 200;
  xPlus = 0;
  firstRun = true;
  tempScrollGeschwindigkeit = scrollGeschwindigkeit;
  
  Timer timer = new Timer(); // warum wird hier der globale Timer überschrieben?
  
  size(800, 450, JAVA2D);
  frameRate(30);

  if(doClear) {
    player.pause();
    player.rewind();
    doClear = false;        
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

void draw() {
  if (saveReady == 2) {
    if(initialised) {  
      try {
        buf.save(savePath);    // dataPath("shots/"+timestamp() +".png")
      } catch(Exception e) {
        
      }  
      savePath = "";      
    } 
    if(initialised && player.position() < 47986 && wasGUI == 0) {
      player.play(); 
      startAllScheduledEvents();
      doCapture = true;
    } else {
      wasGUI = 0;
    }
    saveReady = 0;
  }
  
  if(!initialised) {
    switchCursor(1);
    image(getMenuBG(0), 0, 0); 
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
      switchCursor(cursorEnabled ? (useNyancat ? 4 : 3) : 2);
      moveViewport();
      buf.beginDraw();
      if (mainBrushActive) {        
        brushThree();
        if (ghostBrush) {
          ghostBrush();
        }
      }      
      directionArrayX[drawCounter % 10] = (int) x + copyOffsetX;
      directionArrayY[drawCounter % 10] = (int) y + copyOffsetY;
           
      buf.endDraw();
    
      drawVignette(true);
      drawMiniMap(mapEnabled);       
      tempBrushValue *= 0.95;     
    } else {
      switchCursor(1);
      if (player.position() < 47986 && !drawSaveOverlay) {
        image(getMenuBG(2), 0, 0);
        drawGUI(2); 
      } else if (!drawSaveOverlay) {
        pauseAllScheduledEvents();
        image(getMenuBG(2), 0, 0);
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
    image(getMenuBG(2), 0, 0); 
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
