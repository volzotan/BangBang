// controlP5
import controlP5.*;

// GUI
ControlP5 controlP5;

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
 
// TODO, what is this good for?
float x = 400, y = 225;

// Protected zone (rectangle) around the relative center in which scrolling doesn't happen, 0 = no such zone
int groesseSchutzzoneX = 0, groesseSchutzzoneY = 0;

// dampen mouse movements for brush following
float verfolgungsDaempfungX = 10, verfolgungsDaempfungY = 10;

// automatic scrolling TODO wo besteht der unterschied zwischen diesen 3 (2) variablen?
float scrollGeschwindigkeit = 10;
int autoScrollX = 0, autoScrollY = 0;
// Direction; constant scrolling in any direction without any mouse movements
float xRichtungsFaktor = 10, yRichtungsFaktor = 0;
  
int xPosKoord = copyOffsetX + (int) xRichtungsFaktor;
int yPosKoord = copyOffsetY + (int) yRichtungsFaktor;

// use this with % to execute functions at every nth draw execution
int drawCounter = 0, frameToSkip = 0;

// MiniMap; Initialpositionierung des Viewport-Rechtecks (abhängig von x,y in Z. 17) wird aber sofort bei Programmstart überschrieben  
int miniMapPosX = 0, miniMapPosY = 0;
PImage scaledMiniMap;

// Brush
int angle = 0;

// Variablen zum Effektezeichnen TODO, wozu mousePosX doppelt? mouseX/mouseY sind global verfügbar?!
int mousePosX = 0, mousePosY = 0;
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
  setupGUI();
 
  copyOffsetX = 0;
  copyOffsetY = (buf.height - height) / 2;      // startet am linken äußeren Rand in der Mitte
  copyWidth = width;
  copyHeight = height;
  
  // load and instantiate audio player
  minim = new Minim(this);
  player = minim.loadFile("bangbang.mp3");
  beat = new BeatDetect();
  //player.play();

  scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
  scaledMiniMap.resize(0, 18);                // resize-Wert ist buf.height/50
  
  ps = new ParticleSystem(1, new PVector(width/2,height/2,0));
}

void draw(){
  if(doClear) {
    initCanvas(true);
    doClear = false;
    initialised = false;
    player.pause();
    player.rewind();
  }
  
  moveViewport();
  drawVignette();  

  if(!initialised) {
    drawGUI();
  } else {  
    controlP56.hide()
    beat.detect(player.mix);
     
    x = x + (mouseX-x)/verfolgungsDaempfungX;
    y = y + (mouseY-y)/verfolgungsDaempfungY;
    drawCounter++;
  
    drawMiniMap();
    
    if(player.isPlaying()) {
      buf.beginDraw();
      if (drawCounter % 2 == frameToSkip) {
        BrushOne();      
      }
      if (drawCounter % 3 == 0) {
        mousePosX = copyOffsetX + mouseX;
        mousePosY = copyOffsetY + mouseY;
   
        castEffect();
      }      
      buf.endDraw();
    
      ps.run();
      ps.addParticle(mouseX,mouseY);       
    }
  
    if (drawCounter % 3 == 0) {
      prevOffsetX = copyOffsetX;
      prevOffsetY = copyOffsetY;
    }   
  }

  println(frameRate + " at " + player.position());
}
  
void stop() {                                       // Minim Stop
  player.close();
  minim.stop();
  super.stop();
}
