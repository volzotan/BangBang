// ---- Timer and event scheduling ----
import java.util.Timer;
import java.util.TimerTask;
// timer
Timer timer;
int elapsedTime = 0;

// ---- import GUI ----
import controlP5.*;
// GUI
ControlP5 controlP5;
ControllerSprite spriteSmall, spritePause, spritePlay,
                 spriteDemo, spriteInteractive,
                 spriteRestart, spriteMinimap,
                 spriteMouseDampening0, spriteMouseDampening1, spriteMouseDampening2,
                 spriteMousePointer0, spriteMousePointer1, spriteMousePointer2,
                 spriteFilter0, spriteFilter1, spriteFilter2, spriteFilter3;
controlP5.Button demo;
controlP5.Button interactive;
controlP5.Button minimap;
controlP5.Button mouseDampening;
controlP5.Button mousePointer;
controlP5.Button overlayFilter;
controlP5.Button play;
//controlP5.Button quit;
controlP5.Button replay;
controlP5.Button screenshot;
// Button, Menu background, cursor images
PImage buttonHoverImage, buttonHoverBigImage, buttonReplayImage, buttonInteractiveImage, 
       buttonReplayBigImage, buttonPlayImage, buttonDemoImage, buttonPauseImage, 
       buttonSaveImage, buttonMapImage, 
       savingImage, overlayImage, tempMenuBG,
       cursorImage_blank, cursorImage_circle, cursorImage_nyancat,
       flowerSmall, flowerMedium, flowerLarge;
PImage flowersSmall[] = new PImage[4];       
// minimap, cursor, screenshot status flags
boolean minimapEnabled = false, cursorEnabled = true, useNyancat = false, emptyMenuBG; // emptyMenuBG = still photo flag
// switch Cursor: 1 = pfeil, 2 = leer, 3 = custom, else do nothing; menu: current menu layout
int switchCursor, menu, doFilter = 0;

// ---- Robot Class for Demo ----
import java.awt.AWTException;
import java.awt.Robot;
RoboMouse robo;
Bot bot;
float roboTempX = 0;
float roboTempY = 0;
float roboSpringSpeed = .002;
float roboDamping = .985;
boolean isDemo = false;

// ---- import Audio player ----
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
// ---- Audio player & beat detection ----
Minim minim;
AudioPlayer player;
BeatDetect beat;

// ---- Canvas setup ----
PGraphics bg;
int copyOffsetX, copyOffsetY, copyWidth, copyHeight, prevOffsetX = 0, prevOffsetY = 0;
// Vignette / Background image 
PImage vignette, bgCanvas, bgTransparent, bgCanvasAlt;
int switchBGImage = 1;
// Viewport-Initialisierung / Viewport-Movement variables
float x = 400; // these two describe
float y = 225; // describe initial viewport positioning
// ---- Scrolling and Mouse movement ----
// Protected zone (rectangle) around the relative center in which scrolling doesn't happen, 0 = no such zone
int scrollProtectionX = 0; 
int scrollProtectionY = 0;
// dampen mouse movements for brush following
float mouseDampeningX = 9;
float mouseDampeningY = 9;
// Global auto-scrolling value
final float scrollSpeed = 6;
float tempScrollSpeed = scrollSpeed;
int autoScrollX = (int) (scrollSpeed/2);
int autoScrollY = 0;
// Direction; constant scrolling in any direction without any mouse movements
float directionFactorX = 10, directionFactorY = 0;
// WHAT DO THESE DO? 
int positionCoordX = copyOffsetX + (int) directionFactorX; // xPosKoord
int positionCoordY = copyOffsetY + (int) directionFactorY; // yPosKoord

// ---- Minimap ----
// MiniMap; Initialpositionierung des Viewport-Rechtecks (abhängig von x,y in Z. 17) wird aber sofort bei Programmstart überschrieben  
int miniMapPosX = 0, miniMapPosY = 0;
PImage scaledMiniMap;

// ---- Brush settings ----
// angle = flower pattern petal repeater angle
int angle = 0, tempBrushValue;
// Variables controlling the brush TODO IN WHAT WAY
int deltaMouseX = 0;
int deltaMouseY = 450;
int[] lastMousePosX = new int[30], lastMousePosY = new int[30];
// Used for the very last effect to create a "triangle"
int mainBrushDeflectionScale = 100;
// use ghost brush?
boolean ghostBrush = false;
// use main brush ?
boolean mainBrushActive;
// mainBrush resources
float verhaeltnisSumme = 0;
float verhaeltnisX = 0;
float verhaeltnisY = 0;  
int oldX, oldDeltaX;
int oldY, oldDeltaY;
boolean firstRun;
int tempX, tempY;  

// ---- Effects ----
// player position in milliseconds
int pos = 0;
// ink splatter array containing the loaded images
PImage inkSplatter[] = new PImage[18];
// last used quadrant: 0 (top right), 1 (top left), 2 (bottom left), 3 (bottom right)
int inkSplatterPos;

PImage combs[] = new PImage[5];

// ---- Nyancat
color nyanColor = color(255,  42,  12);
int tempNyanPos, tempNyanCol;

// direction sensitive drawing
int[] directionArrayX = new int[10];
int[] directionArrayY = new int[10];

// ---- Save Overlay
int saveReady = 0;              // says whether the application may now save the canvas to file
boolean drawSaveOverlay = false;// says whether the overlay should be drawn

// Crescendo - Effect
int invsVar = 1;
int amp = 200;
float xPlus = 0;

// EXPERIMENTAL GhostBrush
float theta = 0.0;
int amplitude = 10;
int deltaHeight = 70;
int deltaWidth = 30;
float newGhostPosX;
float newGhostPosY;
int ghostOldX = 0;
int ghostOldY = 0;

// ---- Generic ----
boolean initialised, doClear = false;
String savePath;
// use this with % to execute functions at every nth draw execution
int drawCounter = 0;

void setup(){
  // Create Applet Window and set maximum frame rate
  size(800, 450, JAVA2D);
  frameRate(30);
  

  // initialize Canvas, Images and GUI
  initImages();
  initCanvas(true);
  setupGUI();  
  
  
  // create Timer and Events
  initEventArrays();
  elapsedTime = 0;
  inkSplatterPos = 0;
  timer = new Timer(); // (re)set Timer
  
  
  // Brush initialization
  mainBrushActive = true;
  tempNyanPos = 0;
  switchCursor = 0; // cursor kind
  
  
  // GUI/Menu settings
  emptyMenuBG = true;  
  menu = 0;
  // make sure start up GUI window is shown
  initialised = false;
  // clear/set save image path  
  savePath = "";
  doFilter = 0;
  
  
  // TODO CREATE COMMENTS
  oldX = 400;
  oldY = 225;
  amp = 200;
  xPlus = 0;
  firstRun = true;
  tempScrollSpeed = scrollSpeed;
  // start on the far left in the middle of the canvas
  copyOffsetX = 0;
  copyOffsetY = (bg.height - height) / 2;
  // TODO copy applet width and height what for?
  copyWidth = width;
  copyHeight = height; 
  deltaMouseX = 470;
  deltaMouseY = 450;  
  
  
  // Restart: make song start from very beginning
  if(doClear) {
    player.pause();
    player.rewind();
    doClear = false;        
  }
  

  // load and instantiate audio player
  minim = new Minim(this);
  player = minim.loadFile("BettyChungBangBang.mp3");
  beat = new BeatDetect();


  // create minimap
  // force correct minimap button behavior
  minimap(0);
  minimap(0);
  scaledMiniMap = bg.get(0, 0, bg.width, bg.height);
  // resize value is bg.height/50 || where else would this need to be changed in case of canvas size changes?
  scaledMiniMap.resize(0, 18);
}

void draw() {  
  if(!initialised) {
    // draw regular OS cursor
    switchCursor(1);
    // get static background image
    image(getMenuBG(0, 1), 0, 0);  
  } else {
    // part two of screenshot phase
    if(2 == saveReady) {
      savePath = selectOutput("Save Canvas to:");
      if(savePath != null && savePath != "") {
        if(!savePath.endsWith(".png") && !savePath.endsWith(".jpg") && 
           !savePath.endsWith(".jpeg") && !savePath.endsWith(".tif") && 
           !savePath.endsWith(".tga") && !savePath.endsWith(".tiff")) 
        {
          savePath += ".jpg";
        }
        try {
          bg.save(savePath);    // dataPath("shots/"+timestamp() +".png")
        } catch(Exception e) {
          // TODO make work accordingly ? can't seem to catch any exception here
        }
      }
      if(player.position() < 47986 && menu == 1) {
        player.play(); 
        startAllScheduledEvents();
        emptyMenuBG = true;
      }
      saveReady = 0;
    }
    
    // play/pause/finished states
    if(!drawSaveOverlay) { 
      // is playing  
      if(player.isPlaying() && player.position() < 47986) {
        // get dampened mouse position       
        if(isDemo) {
          robo.move();
          robo.checkBoundaries();
          
          bot.create();
          bot.move();
          bot.checkBoundaries();          
          float dx = (bot.x+8-robo.x)*roboSpringSpeed;
          float dy = (bot.y+8-robo.y)*roboSpringSpeed;
          roboTempX += dx;
          roboTempY += dy;
          robo.x += roboTempX;
          robo.y += roboTempY;
          roboTempX *= roboDamping;
          roboTempY *= roboDamping;          
        }  
        x = x + (mouseX-x)/mouseDampeningX;
        y = y + (mouseY-y)/mouseDampeningY;

        // TODO should this really happen in here?
        drawCounter = (drawCounter+1) % 30;
      
        // get current song position
        pos = player.position();
        // get beat from playing song
        beat.detect(player.mix);
        // set brush modifier based on beat
        if(beat.isOnset()) { tempBrushValue = 80; }
        
        // move the canvas
        moveViewport();
        
        // draw main and support brush
        if (mainBrushActive) {        
          mainBrush();
          //brushFive();
          //if (ghostBrush) { ghostBrush(); }
        }
        
        // TODO what does this do?
        directionArrayX[drawCounter % 10] = (int) x + copyOffsetX;
        directionArrayY[drawCounter % 10] = (int) y + copyOffsetY;
        
        drawVignette(true);
        drawMiniMap(minimapEnabled);       
        tempBrushValue *= 0.95;
      
        // Grab mouse position for use in effects and brushes
        if(drawCounter % 1 == 0) {                              
          lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
          lastMousePosY[drawCounter%30] = (int) y + copyOffsetY;
        }
        
        if (drawCounter % 3 == 0) {
          prevOffsetX = copyOffsetX;
          prevOffsetY = copyOffsetY;
        }
        // draw correct cursor
        switchCursor(cursorEnabled ? (useNyancat ? 4 : 3) : 2);        
      // pause / finished  
      } else {
        // draw regular OS cursor
        switchCursor(1);
        image(getMenuBG(2, 1), 0, 0);
        // finished, load correct menu
        if(47986 <= player.position() && 2 != menu)
          menu = 2;
      }
    // phase one of screenshot phase        
    } else {
      image(getMenuBG(2, 2), 0, 0); 
      switch(saveReady) {
        case 0: saveReady++; break;
        case 1: saveReady++;
            drawSaveOverlay = false;
            emptyMenuBG = true;
      }    
    }    
  }
  // drawGUI (assuming it is visible)
  if(!drawSaveOverlay && 0 == saveReady) { drawGUI(); }  
  // ---- Debug Info ----
  // println(frameRate + " at " + player.position());  
}
  
void stop() {
  player.close();
  minim.stop();
  super.stop();
}
