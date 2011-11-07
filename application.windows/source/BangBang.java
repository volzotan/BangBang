import processing.core.*; 
import processing.xml.*; 

import java.util.Timer; 
import java.util.TimerTask; 
import controlP5.*; 
import java.awt.AWTException; 
import java.awt.Robot; 
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

// ---- Timer and event scheduling ----


// timer
Timer timer;
int elapsedTime = 0;

// ---- import GUI ----

// GUI
ControlP5 controlP5;
ControllerSprite spriteSmall, spritePause, spritePlay,
                 spriteDemo, spriteInteractive, spriteReplay,
                 spriteRestart, spriteMinimap, spriteSave,
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
PImage buttonHoverBigDemo, buttonHoverBigInteractive, buttonHoverBigReplay, buttonHoverBigPlay, buttonMaskBig,
       buttonSave, buttonReplay, buttonMap, buttonMaskSmall,
       savingImage, overlayImage, tempMenuBG,
       cursorImage_blank, cursorImage_circle, cursorImage_nyancat,
       flowerSmall, flowerMedium, flowerLarge;
PImage flowersSmall[] = new PImage[4];       
// minimap, cursor, screenshot status flags
boolean minimapEnabled = false, cursorEnabled = true, useNyancat = false, emptyMenuBG; // emptyMenuBG = still photo flag
// switch Cursor: 1 = pfeil, 2 = leer, 3 = custom, else do nothing; menu: current menu layout
int switchCursor, menu, doFilter = 0;

// ---- Robot Class for Demo ----


Robot robot;
//RoboMouse robo;
//Bot bot;
float roboTempX = 0;
float roboTempY = 0;
float roboSpringSpeed = .002f;
float roboDamping = .985f;
boolean isDemo = false;

// ---- import Audio player ----




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
// MiniMap; Initialpositionierung des Viewport-Rechtecks (abh\u00e4ngig von x,y in Z. 17) wird aber sofort bei Programmstart \u00fcberschrieben  
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
int oldX, oldDeltaX, roboX;
int oldY, oldDeltaY, roboY;
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
int nyanColor = color(255,  42,  12);
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
float theta = 0.0f;
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

public void setup(){
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
  roboX = 0;
  roboY = 0;
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
  if(isDemo) { cursorEnabled = true; }
  
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

public void draw() {  
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
        if(isDemo) {
          moveMouse();
          /*robo.checkBoundaries();
          
          bot.move();
          bot.checkBoundaries();
          
          float dx = (bot.x+8-robo.x)*roboSpringSpeed;
          float dy = (bot.y+8-robo.y)*roboSpringSpeed;
          roboTempX += dx;
          roboTempY += dy;
          robo.x += roboTempX;
          robo.y += roboTempY;
          roboTempX *= roboDamping;
          roboTempY *= roboDamping;      */    
        }  
        // get dampened mouse position        
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
        tempBrushValue *= 0.95f;
      
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
  
public void stop() {
  player.close();
  minim.stop();
  super.stop();
}
// COLORS (in rgb)
// blue/green:     5, 136, 138
// white/yellow: 240, 236, 202
// light orange: 227, 168,  47
// dark orange:  213,  77,  27  
// brown:         81,  61,  46

/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
public /*synchronized*/ void brushOne(boolean useOffset, int drawSize) {
  float extraOffsetY = 0;  float extraOffsetX = 0;
  int rand = 0, rand2 = 0;  
  PImage flower;
  // depending on the draw Size (2 = large, 1 = medium, 0 = small
  // a random offset in Y (and X) direction is calculated
  if(useOffset) {
    switch(drawSize) {
      case 1 : 
        extraOffsetY = (random(1) < 0.5f) ? -74+60*random(-1,1)+30*random(-1,1) : 47+70*random(-1,1)+30*random(-1,1);
        extraOffsetX = (random(1) < 0.5f) ? -37+60*random(-1,1) : 52+70*random(-1,1);      
        break;
      case 2 : 
        extraOffsetY = random(-40,40);    
        break;        
      default:
        extraOffsetY = (random(1) < 0.5f) ? -84+40*player.left.get(1)*random(-1,1)+30*random(-1,1) : 97+60*player.right.get(1)*random(-1,1)+30*random(-1,1);
        extraOffsetX = (random(1) < 0.5f) ? -37+60*player.left.get(1)*random(-1,1) : 52+70*player.right.get(1)*random(-1,1);      
    }  
  }  
  
  float val = cos(radians(angle)) * 10.0f + 4;
  angle = (angle > 360) ? 0 : angle + 10;
  float size1 = 45, size2 = random(8,20), spacing = 1.1f;
  int alpha2 = 255;
  int r = 81, g = 61, b = 46, o = 150; // brown
  if(2 == drawSize) { // large
    size1 = 275;
    size2 = 230;
    spacing = 32;
    //alpha2 = 60;
    val = (val > 9.5f || val < 5) ? random(6,9) : val;
    flower = flowerLarge;
  //  r = 240; g = 236; b = 202; o = 160; // white/yellow 
  } else if (1 == drawSize) { // medium
    size1 = 95;
    size2 = 85;
    spacing = 13;
    //alpha2 = 60;
    val = (val > 8 || val < 5) ? random(5,7.5f) : val;
//    r = 213; g = 77; b = 27; o = 100; // dark orange
    rand = 1;
    flower = flowerMedium;
  } else {          // small
    val = random(10,22);
    rand = (int) floor(random(2.0f,4.1f));
    rand2 = (int) floor(random(0,2.1f)) + 2;
   
    if(rand2 == rand) { rand2--; } 
    flower = flowersSmall[(int) random(0,flowersSmall.length-0.5f)];
  }  
  
  bg.beginDraw();
//    bg.noStroke();
//    bg.fill(r,g,b);
    for (int a = 0; a < 360; a += 72) { // += als parameter f\u00fcr Pinselmuster
      float offX = cos(radians(a)) * val * spacing;
      float offY = sin(radians(a)) * val * spacing;          
  //    bg.ellipse(x + copyOffsetX + offX + extraOffsetX, y + copyOffsetY + offY + player.left.get(0) * 50 + extraOffsetY, val + player.left.get(0) * 20 + size1, val + player.left.get(0) * 20 + size1);
        bg.image(flower, x + copyOffsetX + offX + extraOffsetX, y + copyOffsetY + offY + player.left.get(0) * 50 + extraOffsetY, val + player.left.get(0) * 20 + size1, val + player.left.get(0) * 20 + size1);     
        if(0 == drawSize) { break; }
    }
//    if(0 == drawSize) {
//      bg.fill(0,0,0,alpha2);    
//      bg.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + player.left.get(0) * 50 + extraOffsetY, 2 + size2 , 2 + size2);
//      bg.image(flowerSmall, x + copyOffsetX + extraOffsetX,  y + copyOffsetY + player.left.get(0) * 50 + extraOffsetY, 2 + size2, 2 + size2);  
//    }
  bg.endDraw();  

  // Grab mouse position for use in effects and brushes
  // TODO WHAT DOES THIS DO HERE? IT IS CALLED IN DRAW() WITHOUT THE + X in Y coordinate
//  if(drawCounter % 1 == 0) {                              
//    lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
//    lastMousePosY[drawCounter%30] = (int) y + copyOffsetY + (int) (player.left.get(0) * 50);
//  }
}

// continuous line
/*synchronized*/ public void mainBrush() {
  int c = color(145,145,145);
  int w = 5;
  // 10,5 - 11,8 :: General Pause  
  if(!useNyancat) {
    if(pos < 10500 || pos > 11800) {
      c = color(100-tempBrushValue,100-tempBrushValue,100-tempBrushValue);
      w += tempBrushValue*0.13f;
    } else {
      w -= 1;
    }
  } else {  
    /*if(tempNyanPos+250 < pos) {
      switch(tempNyanCol) {
        case 0 : nyanColor = color(255,  42,  12); tempNyanCol++; break; // Red
        case 1 : nyanColor = color(255, 164,   9); tempNyanCol++; break; // Orange
        case 2 : nyanColor = color(255, 246,   0); tempNyanCol++; break; // Yellow
        case 3 : nyanColor = color( 50, 233,   3); tempNyanCol++; break; // Green
        case 4 : nyanColor = color(  2, 162, 255); tempNyanCol++; break; // Blue
        case 5 : nyanColor = color(119,  85, 255); tempNyanCol=0; break; // Purple
      }        
      tempNyanPos = pos;
    }
    c = nyanColor; */
    w += tempBrushValue*0.13f;
  }
  
  verhaeltnisSumme = abs(x + copyOffsetX - directionArrayX[drawCounter%10]) + abs(y + copyOffsetY - directionArrayY[drawCounter%10]);
  verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
  verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;  
  
  oldX = (int) (x + copyOffsetX + verhaeltnisY * (player.left.get(0) * mainBrushDeflectionScale));
  oldY = (int) (y + copyOffsetY + verhaeltnisX * (player.left.get(0) * 100));
  
  bg.beginDraw();
    if(useNyancat) {
      bg.stroke(color(255,  42,  12));
      bg.strokeWeight(w);
      bg.line(oldX-100, oldY, deltaMouseX-100, deltaMouseY); // -100 = no paint border to the right
      bg.stroke(color(255, 164,   9));
      bg.line(oldX-100, oldY+w, deltaMouseX-100, deltaMouseY+w); // -100 = no paint border to the right
      bg.stroke(color(255, 246,   0));
      bg.line(oldX-100, oldY+w*2, deltaMouseX-100, deltaMouseY+w*2); // -100 = no paint border to the right
      bg.stroke(color( 50, 233,   3));
      bg.line(oldX-100, oldY+w*3, deltaMouseX-100, deltaMouseY+w*3); // -100 = no paint border to the right
      bg.stroke(color(  2, 162, 255));
      bg.line(oldX-100, oldY+w*4, deltaMouseX-100, deltaMouseY+w*4); // -100 = no paint border to the right
      bg.stroke(color(119,  85, 255));
      bg.line(oldX-100, oldY+w*5, deltaMouseX-100, deltaMouseY+w*5); // -100 = no paint border to the right      
    } else {
      bg.stroke(c);
      bg.strokeWeight(w);
      bg.line(oldX-100, oldY, deltaMouseX-100, deltaMouseY); // -100 = no paint border to the right
      bg.strokeWeight(w*1.3f);      
      bg.line(oldX-100, oldY+w*0.7f, deltaMouseX-100, deltaMouseY+w*0.7f); // -100 = no paint border to the right      
//      bg.line(oldX-100, oldY+w*1.7, deltaMouseX-100, deltaMouseY+w*1.7); // -100 = no paint border to the right            
//      bg.line(oldX-100, oldY+w*2.7, deltaMouseX-100, deltaMouseY+w*2.7); // -100 = no paint border to the right            
    }  
  bg.endDraw();
  
  deltaMouseX = oldX;
  deltaMouseY = oldY;
}

public void startGhostBrush() {
  ghostOldX = (int) directionArrayX[drawCounter%10] - deltaWidth;
  ghostOldY = (int) directionArrayY[drawCounter%10] ;
  ghostBrush = true;
}

public void ghostBrush() {
  bg.beginDraw();
  
    int c = color(145,145,145);
    switch(tempNyanCol) {
        case 0 : nyanColor = color(255,  42,  12); tempNyanCol++; break; // Red
        case 1 : nyanColor = color(255, 164,   9); tempNyanCol++; break; // Orange
        case 2 : nyanColor = color(255, 246,   0); tempNyanCol++; break; // Yellow
        case 3 : nyanColor = color( 50, 233,   3); tempNyanCol++; break; // Green
        case 4 : nyanColor = color(  2, 162, 255); tempNyanCol++; break; // Blue
        case 5 : nyanColor = color(119,  85, 255); tempNyanCol=0; break; // Purple
      }        
      tempNyanPos = pos;
  
      c = nyanColor;
    
    bg.stroke(c);
    bg.strokeWeight(5);
    /*
    newGhostPosX = x + copyOffsetX - deltaWidth;
    newGhostPosY = y + copyOffsetY - deltaHeight + sin(theta) * amplitude;
    */
    newGhostPosX = directionArrayX[drawCounter%10] - deltaWidth;
    newGhostPosY = directionArrayY[drawCounter%10] - deltaHeight + sin(theta) * amplitude;
    
    bg.line(ghostOldX, ghostOldY,  newGhostPosX, newGhostPosY);
  bg.endDraw();

  ghostOldX = (int) ( newGhostPosX );
  ghostOldY = (int) ( newGhostPosY );
  
  deltaHeight = (int) ( (y - 225) );
  deltaWidth = (int) ( (x - 400) );
  theta += 0.2f;
  
}

// random circles and dots
public void brushFour(int minAmount, int maxAmount) {
  int amount = floor(random(minAmount,maxAmount));
  if(random(1) < 0.5f) { amount *= -1; }
  int c = color(0,0,0);
      
  float extraOffsetX = 0, extraOffsetY = 0;  
  
  for(int i = 0; i < amount; i++) {  
    int size = floor(random(2,4));
    
    extraOffsetX = (random(1) < 0.5f) ? - 6+48*player.left.get(0)+ 8*random(-10,50) : 15+30*player.right.get(0)+3*random(-10,50);
    extraOffsetY = (random(1) < 0.5f) ? -44+48*player.left.get(0)+10*random(-50, 0) : 47+30*player.right.get(0)+5*random(  0,50);
    
    if(random(0,1) < 0.6f) {
      c = color(81, 61, 46);
    } else {
      float rand = random(0,1);      
      if(rand < 0.3f) {
        c = color(5,136,138);
      } else if(rand > 0.6f) {
        c = color(240,236,202);
      } else {
        c = color(213,77,27);
      }  
    }  
    
    bg.beginDraw();
      bg.fill(c);
      bg.stroke(c);
      bg.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + extraOffsetY,size,size);  
    bg.endDraw();
  }  
}

// splatters around main brush
public void brushFive() {
  int amount = floor(random(0, 3));

  for(int i = 0; i < amount; i++) {
    int splatterRadius = floor(random(6,12));
    
    float colorPicker = random(0,1);
    int c = color(5,136,138);
    if(colorPicker <= 0.1f) {
      c = color(5,136,138);
    } else if(0.2f < colorPicker && colorPicker <= 0.4f) {
      c = color(227,168,47);    
    } else if(0.4f < colorPicker && colorPicker <= 0.6f) {
      c = color(213,77,27);   
    } else if(0.6f < colorPicker && colorPicker <= 0.8f) {
      c = color(81,61,46);   
    }
    
    bg.beginDraw();
    if(random(0,1) < 0.5f) {
      bg.noStroke();      
      bg.fill(c);      
    } else {
      bg.noFill();
      bg.stroke(c);     
    }   
      bg.ellipse(x + copyOffsetX + random(-20,20), y + copyOffsetY + random(-90,90), splatterRadius, splatterRadius);  
    bg.endDraw();    
    
  }  
  
}  
 /*  Variablen zum Effektezeichnen
  * + mousePosX, mousePosY geben die Mausposition an
  * + boolean testOnCanvasX(int zuTestendeKoordinate) gibt an ob 
  *   eine Koordinate die vollgezeichnet werden soll sich auf der Zeichenflaeche befindet
  * + lastMousePosX[0-29] gibt vorherige absolute Mausposition aus
  *
  */  
  
// EFFECT RANGES
//
// Gro\u00dfe Blume     @ 10.300 sec
// Mittlere Blume  @ 25.350 sec
// Mittlere Blume  @ 28.200 sec
// Mittlere Blume  @ 31.050 sec
// Mittlere Blume  @ 39.850 sec
// Mittlere Blume  @ 42.120 sec
//
// Kleine Blumen   @  2.340 sec -  2.930 sec ( 2.340,  2.460,  2.520,  2.625,  2.690)
// Kleine Blumen   @  5.200 sec -  5.800 sec ( 5.200,  5.330,  5.410,  5.480,  5.580)
// Kleine Blumen   @  8.100 sec -  8.680 sec ( 8.100,  8.180,  8.270,  8.330,  8.440)
// Kleine Blumen   @ 33.200 sec - 34.035 sec (33.200, 33.430, 33.830, 34.035)
// Kleine Blumen   @ 36.860 sec - 37.400 sec (36.860, 37.030, 37.170, 37.210, 37.330)

// INK SPLATTERS
int[][] splatterEventArray  = new int[10][2];  // 0 = delay, 1 = size
// FLOWER EFFECT
int[][] brushOneEventArray  = new int[30][3];  // 0 = delay, 1 = size Flag, 2 = Repeat Intervall[ms]
// SPREAD EFFECT
int[][] brushFourEventArray = new int[ 3][3];  // 0 = delay, 1 = do repeat, 2 = Repeat Intervall[ms]
// circles and dots
int[][] brushFiveEventArray = new int[ 1][3];  // 0 = delay, 1 = do repeat, 2 = Repeat Intervall[ms]
// CRESCENDO EFFECT
int[][] crescendoEventArray = new int[ 1][3];  // 0 = delay, 1 = do repeat, 2 = Repeat Intervall[ms]

// brush for circle amounts
final int MAXAMOUNT =  4; 
final int MINAMOUNT = 50;

public void initEventArrays() {
  
  splatterEventArray[0][0]  = 24240;  splatterEventArray[0][1]  = 3;
  splatterEventArray[1][0]  = 24628;  splatterEventArray[1][1]  = 1;
  splatterEventArray[2][0]  = 27000;  splatterEventArray[2][1]  = 4;
  splatterEventArray[3][0]  = 27450;  splatterEventArray[3][1]  = 3;
  splatterEventArray[4][0]  = 29890;  splatterEventArray[4][1]  = 2;
  splatterEventArray[5][0]  = 30280;  splatterEventArray[5][1]  = 4;
  splatterEventArray[6][0]  = 32770;  splatterEventArray[6][1]  = 2;
  splatterEventArray[7][0]  = 33200;  splatterEventArray[7][1]  = 3;
  splatterEventArray[8][0]  = 38690;  splatterEventArray[8][1]  = 4;
  splatterEventArray[9][0]  = 39050;  splatterEventArray[9][1]  = 5;
  
  crescendoEventArray[0][0] = 43300;  crescendoEventArray[0][1] = 1;  crescendoEventArray[0][2] = 100;
 
  // little flowers 1. sequenze
  brushOneEventArray[0][0]  =  2340;  brushOneEventArray[0][1]  = 0;  brushOneEventArray[0][2]  = 0;
  brushOneEventArray[1][0]  =  2460;  brushOneEventArray[1][1]  = 0;  brushOneEventArray[1][2]  = 0;
  brushOneEventArray[2][0]  =  2520;  brushOneEventArray[2][1]  = 0;  brushOneEventArray[2][2]  = 0;
  brushOneEventArray[3][0]  =  2625;  brushOneEventArray[3][1]  = 0;  brushOneEventArray[3][2]  = 0;
  brushOneEventArray[4][0]  =  2690;  brushOneEventArray[4][1]  = 0;  brushOneEventArray[4][2]  = 0;
  
  // little flowers 2. sequenze
  brushOneEventArray[5][0]  =  5200;  brushOneEventArray[5][1]  = 0;  brushOneEventArray[5][2]  = 0;
  brushOneEventArray[6][0]  =  5330;  brushOneEventArray[6][1]  = 0;  brushOneEventArray[6][2]  = 0;
  brushOneEventArray[7][0]  =  5410;  brushOneEventArray[7][1]  = 0;  brushOneEventArray[7][2]  = 0;
  brushOneEventArray[8][0]  =  5480;  brushOneEventArray[8][1]  = 0;  brushOneEventArray[8][2]  = 0;
  brushOneEventArray[9][0]  =  5580;  brushOneEventArray[9][1]  = 0;  brushOneEventArray[9][2]  = 0;
  
  // little flowers 3. sequenze
  brushOneEventArray[10][0] =  8100;  brushOneEventArray[10][1] = 0;  brushOneEventArray[10][2] = 0;
  brushOneEventArray[11][0] =  8180;  brushOneEventArray[11][1] = 0;  brushOneEventArray[11][2] = 0;
  brushOneEventArray[12][0] =  8270;  brushOneEventArray[12][1] = 0;  brushOneEventArray[12][2] = 0;
  brushOneEventArray[13][0] =  8330;  brushOneEventArray[13][1] = 0;  brushOneEventArray[13][2] = 0;
  brushOneEventArray[14][0] =  8440;  brushOneEventArray[14][1] = 0;  brushOneEventArray[14][2] = 0;
  
  // little flowers 4. sequenze
  brushOneEventArray[15][0] = 33200;  brushOneEventArray[15][1] = 0;  brushOneEventArray[15][2] = 0;
  brushOneEventArray[16][0] = 33430;  brushOneEventArray[16][1] = 0;  brushOneEventArray[16][2] = 0;
  brushOneEventArray[17][0] = 33830;  brushOneEventArray[17][1] = 0;  brushOneEventArray[17][2] = 0;
  brushOneEventArray[18][0] = 34035;  brushOneEventArray[18][1] = 0;  brushOneEventArray[18][2] = 0;
  
  // little flowers 5. sequenze 36.860, 37.030, 37.170, 37.210, 37.330
  brushOneEventArray[19][0] = 36860;  brushOneEventArray[19][1] = 0;  brushOneEventArray[19][2] = 0;
  brushOneEventArray[20][0] = 37030;  brushOneEventArray[20][1] = 0;  brushOneEventArray[20][2] = 0;
  brushOneEventArray[21][0] = 37170;  brushOneEventArray[21][1] = 0;  brushOneEventArray[21][2] = 0;
  brushOneEventArray[22][0] = 37210;  brushOneEventArray[22][1] = 0;  brushOneEventArray[22][2] = 0;
  brushOneEventArray[23][0] = 37330;  brushOneEventArray[23][1] = 0;  brushOneEventArray[23][2] = 0;
  
  // middle flowers
  brushOneEventArray[24][0] = 25350;  brushOneEventArray[24][1] = 1;  brushOneEventArray[24][2] = 0;
  brushOneEventArray[25][0] = 28200;  brushOneEventArray[25][1] = 1;  brushOneEventArray[25][2] = 0;
  brushOneEventArray[26][0] = 31050;  brushOneEventArray[26][1] = 1;  brushOneEventArray[26][2] = 0;
  brushOneEventArray[27][0] = 39850;  brushOneEventArray[27][1] = 1;  brushOneEventArray[27][2] = 0;
  brushOneEventArray[28][0] = 42120;  brushOneEventArray[28][1] = 1;  brushOneEventArray[28][2] = 0;
  
  // big flower
  brushOneEventArray[29][0] = 10300;  brushOneEventArray[29][1] = 2;  brushOneEventArray[29][2] = 0;
  
  brushFourEventArray[0][0] = 43300;  brushFourEventArray[0][1] = 1;  brushFourEventArray[0][2] = 100;

  brushFiveEventArray[0][0] = 13245;  brushFiveEventArray[0][1] = 1;  brushFiveEventArray[0][2] = 200;   
}

public void savePauseTime() {
  elapsedTime = player.position();
}

public void killAllScheduledEvents() {
  timer.cancel();                      
}

public void pauseAllScheduledEvents() {
  savePauseTime();
  killAllScheduledEvents();
  timer = new Timer();
}

public void startAllScheduledEvents() {
  scheduleBrushOneEvents();
  //scheduleBrushFourEvents();
  scheduleBrushFiveEvents();
  scheduleCrescendoEvent();
  scheduleSplatterEvents();  
  
  scheduleKillEvent();
  
  scheduleGhostBrush();
}

public void scheduleKillEvent() {
  
  /* KILL brushFiveEventArray[0] */
  
  int killTime = 37000;
  if (killTime - elapsedTime >= 0) {
    timer.schedule(new TimerTask() {
      public void run() {
        brushFiveEventArray[0][2] = 0;
        pauseAllScheduledEvents();
        startAllScheduledEvents();
      }
    }, killTime - elapsedTime);
  }
  
}

public void scheduleBrushOneEvents() {
  for (int i=0; i < brushOneEventArray.length; i++) {
    if (brushOneEventArray[i][0] - elapsedTime >= 0) {      
      if (brushOneEventArray[i][1] == 1) {       // medium flower
        timer.schedule(new TimerTask() {
          public void run() {
            brushOne(true, 1);
          }
        }, brushOneEventArray[i][0] - elapsedTime);
      } else if (brushOneEventArray[i][1] == 2) { // large flower
        timer.schedule(new TimerTask() {
          public void run() {
            brushOne(true, 2);
          }
        }, brushOneEventArray[i][0] - elapsedTime);
      } else {                                   // regular/small flower
        // TODO STOP AFTER SET INTERVAL
        timer.schedule(new TimerTask() {
          public void run() {
            brushOne(true, 0);
          }
        }, brushOneEventArray[i][0] - elapsedTime);
      }
    }
  }
}

public void scheduleBrushFourEvents() {
  for (int i=0; i < brushFourEventArray.length; i++) {
    if (brushFourEventArray[i][0] - elapsedTime >= 0 && brushFourEventArray[i][3] == 1) {      
      if (brushFourEventArray[i][1] == 0) {
        timer.schedule(new TimerTask() {
          public void run() {
            brushFour(MINAMOUNT, MAXAMOUNT);
          }
        }, brushFourEventArray[i][0] - elapsedTime);
      } else {
        timer.schedule(new TimerTask() {
          public void run() {
            brushFour(MINAMOUNT, MAXAMOUNT);
          }
        }, brushFourEventArray[i][0] - elapsedTime, brushFourEventArray[i][2]);
      }
    }
  }
}

public void scheduleBrushFiveEvents() {
  for (int i=0; i < brushFiveEventArray.length; i++) {
    if (brushFiveEventArray[i][0] - elapsedTime >= 0) {      
      if (brushFiveEventArray[i][1] == 0) {
        timer.schedule(new TimerTask() {
          public void run() {
            brushFive();
          }
        }, brushFiveEventArray[i][0] - elapsedTime);
      } else {
        timer.schedule(new TimerTask() {
          public void run() {
            brushFive();
          }
        }, brushFiveEventArray[i][0] - elapsedTime, brushFiveEventArray[i][2]);
      }
    }
  }
}

public void scheduleCrescendoEvent() {
  for (int i=0; i < crescendoEventArray.length; i++) {
    if (crescendoEventArray[i][0] - elapsedTime >= 0) { 
      timer.schedule(new TimerTask() {
        public void run() {
          crescendo();
        }
      }, crescendoEventArray[i][0] - elapsedTime, crescendoEventArray[i][1]);
    }
  }
}

public void scheduleGhostBrush() {
  timer.schedule(new TimerTask() {
    public void run() {
      startGhostBrush();
    }
  }, 2500);  // GhostBrush Start time
}

public void scheduleSingleSplatterEvent(int delay, int size) {
  switch(size) {
    case 1: 
      timer.schedule(new TimerTask() {
        public void run() {
          tintenklecks(8);
        }
      }, delay);
      break;
    case 2: 
      timer.schedule(new TimerTask() {
        public void run() {
          tintenklecks(9);
        }
      }, delay);        
      break;
    case 3: 
      timer.schedule(new TimerTask() {
        public void run() {
          tintenklecks(10);
        }
      }, delay);        
      break;
    case 4: 
      timer.schedule(new TimerTask() {
        public void run() {
          tintenklecks(12);
        }
      }, delay);        
      break;
    case 5: 
      timer.schedule(new TimerTask() {
        public void run() {
          tintenklecks(14);
        }
      }, delay);        
      break;
  }
}

public void scheduleSplatterEvents() {
  for (int i=0; i < splatterEventArray.length; i++) {
    if (splatterEventArray[i][0] - elapsedTime >= 0) {      
      scheduleSingleSplatterEvent(splatterEventArray[i][0] - elapsedTime, splatterEventArray[i][1]);
    }
  }
}

public void crescendo() {
  if (firstRun) {
    oldDeltaX = oldX-100; // -100 = no paint border to the right fix
    oldDeltaY = oldY;
              
    tempScrollSpeed = 13;
              
    mainBrushActive = false;
    firstRun = false;
  }
                        
  tempX = (int) (deltaMouseX + xPlus + random(-1,1) * 8);
  tempY = (int) (deltaMouseY + random(-1,1) * 15 + invsVar * (-1) * abs(amp));
  
  tempX = tempX - 95;
  
  bg.beginDraw();
  bg.stroke(100-tempBrushValue,100-tempBrushValue,100-tempBrushValue);
  bg.strokeWeight(5+tempBrushValue*0.13f);  
  bg.line(oldDeltaX, oldDeltaY, tempX, tempY);
  bg.endDraw();
        
  oldDeltaX = tempX;
  oldDeltaY = tempY;
            
  amp = amp + (0 - amp)/15;
  xPlus = xPlus + 6;
  invsVar = invsVar * (-1);
  
  tempScrollSpeed = tempScrollSpeed + (0 - tempScrollSpeed)/18;
}

public void tintenklecks(float size) {
  int r = floor(random(0,inkSplatter.length-0.5f));
  float splatterSize = 25*size;  
  float posX = copyOffsetX +  width/2 + random(-50,50) * random(-2  ,+2  ), 
      posY = copyOffsetY + height/3 + random(-50,50) * random(-1.5f,+1.5f);    

  // left side :: x position
  if(1 == inkSplatterPos || 2 == inkSplatterPos) {
    if(!(posX >= copyOffsetX && posX <= (copyOffsetX+width/2-splatterSize))) {
      posX = copyOffsetX + width/3 + random(-width/6,width/6);
    }          
  }  

  // right side :: x position
  if(0 == inkSplatterPos || 3 == inkSplatterPos) {        
    if(!(posX >= (copyOffsetX+width/2) && posX <= (copyOffsetX+width-splatterSize))) {
      posX = copyOffsetX + (width*2)/3 + random(-width/6,width/6);
    }
  } 
    
  // top side :: y position
  if(1 == inkSplatterPos || 0 == inkSplatterPos) {       
    if(!(posY >= copyOffsetY && posY <= (copyOffsetY+height/2-splatterSize))) {
      posY = copyOffsetY + height/5 + random(-height/9,height/9) - random(0,40);
      if(posY < copyOffsetY) { posY = copyOffsetY - random(10,30); }
      if(posY > (copyOffsetY+height/2)) { posY = copyOffsetY + height/2 - random(20,60); }
    }       
  }  
  
  // bottom side :: y position
  if(2 == inkSplatterPos || 3 == inkSplatterPos) {              
    if(!(posY >= (copyOffsetY+height/2) && posY <= (copyOffsetY+height-splatterSize))) {
      posY = copyOffsetY + (height*3)/4 + random(-height/8,height/8) - random(0,40) - splatterSize/2;
      if(posY < (copyOffsetY+height/2)) { posY = copyOffsetY + height/2 - random(0,splatterSize/5); }
      if(posY > (copyOffsetY+height)) { posY = copyOffsetY + height - random(splatterSize/2,splatterSize); }
    }      
  }
  
  //println(posX+"\t+\t"+posY + "\t| InkSplatterPos:"+inkSplatterPos);
  bg.beginDraw();
  bg.image(inkSplatter[r], posX, posY, splatterSize, splatterSize);
  bg.endDraw();
  inkSplatterPos = (inkSplatterPos+1) % 4;
} 
public void setupGUI(){
  controlP5 = new ControlP5(this);
  
  // sprites
  /*
  spritePause   = new ControllerSprite(controlP5,buttonHoverBigPlay,175,175,3);
  spritePause.setMask(buttonMaskBig);
  spritePause.enableMask();
  */  
  
  spritePlay    = new ControllerSprite(controlP5,buttonHoverBigPlay,175,175,3);
  spritePlay.setMask(buttonMaskBig);
  spritePlay.enableMask();  
  
  spriteRestart = new ControllerSprite(controlP5,buttonHoverBigReplay,175,175,3);
  spriteRestart.setMask(buttonMaskBig);
  spriteRestart.enableMask();
    
  spriteMinimap = new ControllerSprite(controlP5,buttonMap,110,110,3);
  spriteMinimap.setMask(buttonMaskSmall);
  spriteMinimap.enableMask(); 
  
  // demo button
  // used in: start
  spriteDemo    = new ControllerSprite(controlP5,buttonHoverBigDemo,175,175,3);
  spriteDemo.setMask(buttonMaskBig);
  spriteDemo.enableMask();
  demo = controlP5.addButton("demo",0,425,80,175,175);
  demo.setSprite(spriteDemo);

  // interactive button
  // used in: start
  spriteInteractive    = new ControllerSprite(controlP5,buttonHoverBigInteractive,175,175,3);  
  spriteInteractive.setMask(buttonMaskBig);
  spriteInteractive.enableMask();
  interactive = controlP5.addButton("interactive",0, 200,80,175,175);
  interactive.setSprite(spriteInteractive);   
  
  // minimap button
  // used in: start; playing/paused;   
  minimap = controlP5.addButton("minimap",0,345,290,110,110);
  minimap.setSprite(spriteMinimap);   
   
  // mouse dampening button
  // used in: settings
//  mouseDampening = controlP5.addButton("mouseDampening",0,535,(int) height/2-50,100,100); // TODO POS
//  mouseDampening.setSprite(spriteMouseDampening0); 
  
  // mouse dampening button
  // used in: settings
//  mousePointer = controlP5.addButton("mousePointer",0,535,(int) height/2-50,100,100); // TODO POS
//  mousePointer.setSprite(spriteMousePointer0);   

  // filter button
  // used in: settings   
//  overlayFilter = controlP5.addButton("overlayFilter",0,535,(int) height/2-50,100,100); // TODO POS
//  overlayFilter.setSprite(spriteFilter0);   
   
  // play button (doubles as pause and large restart button)
  // used in: start (play); playing/paused (pause/play); finished (restart)
  play = controlP5.addButton("play",0,312,80,175,175);
  play.setSprite(spritePlay);
 
  // exit button
  // used in: start; playing/paused; finished
//  spriteSmall.setMask(buttonExitImage);
//  spriteSmall.enableMask();
//  quit = controlP5.addButton("quit",0,30,30,50,50);
//  quit.setSprite(spriteSmall.clone()); 

  // replay button
  // used in: playing/paused; finished
  spriteReplay   = new ControllerSprite(controlP5,buttonReplay,110,110,3);
  spriteReplay.setMask(buttonMaskSmall);
  spriteReplay.enableMask();
  replay = controlP5.addButton("replay",0,480,290,110,110);
  replay.setSprite(spriteReplay); 

  // save button
  // used in: playing/paused; finished
  spriteSave = new ControllerSprite(controlP5,buttonSave,110,110,3);
  spriteSave.setMask(buttonMaskSmall);
  spriteSave.enableMask();
  screenshot = controlP5.addButton("screenshot",0,210,290,110,110);
  screenshot.setSprite(spriteSave);
}

// DRAW GUI
public void drawGUI() {
  // position buttons on the screen
  switch(menu) {
    // start 535
    case 0:
      demo.show();
      interactive.show();
      minimap.show();
      // make sure correct play sprite is set
      // play.setSprite(spritePlay);
      play.hide();
      replay.hide();
      screenshot.hide();
      break;    
    // playing
    case 1: 
      demo.hide();
      interactive.hide();
      minimap.show();
      // alternate between play/pause if the button is highlighted
      play.show(); 
      replay.show();
      screenshot.setPosition(210,290);
      screenshot.show();
      break;
    // finished
    case 2: 
      demo.hide();
      interactive.hide();
      minimap.hide();
      // set replay sprite
      play.setSprite(spriteRestart);
      play.show();
      replay.hide();
      screenshot.setPosition(345,290);
      screenshot.show();
      if(!drawSaveOverlay) { controlP5.show(); }
      else { controlP5.hide(); }
  }  
}

public PImage getMenuBG(int b, int m) {
  if(emptyMenuBG || (!emptyMenuBG && drawSaveOverlay)) {
    emptyMenuBG = false;
    tempMenuBG = getBufSlice();
    tempMenuBG.filter(BLUR, b);
    switch(m) {
      case 1 : tempMenuBG.blend(overlayImage, 0, 0, width, height,   0,   0, width, height, BLEND); break;
      case 2 : tempMenuBG.blend(overlayImage, 0, 0, width, height,   0,   0, width, height, BLEND);
               tempMenuBG.blend(savingImage , 0, 0, width, height, 312,  80,   175,    175, BLEND); break;
    }
  }
  return tempMenuBG;
}

public void demo(int theValue) {
  isDemo = true;
  if(isDemo) {
    try { 
      robot = new Robot();
      roboX = frame.getLocation().x + 400;
      roboY = frame.getLocation().y + 225;      
    } 
    catch (AWTException e) {
      e.printStackTrace(); 
    }
    //  robo = new RoboMouse(frame.getLocation().x/2+width /2,
//                         frame.getLocation().y/2+height/2, 5, 0, 0);
//    bot = new Bot(random(50 , width - 50), random(50, width - 50),
    //               random(5, 20), random(.5, 5), random(.5, 5));                         
  }
  cursorEnabled = false;
  play(0);  
}

public void interactive(int theValue) {
  isDemo = false;
  play(0);  
}

public void minimap(int theValue) {
  minimapEnabled = !minimapEnabled;
  // minimap button status
  if(minimapEnabled) {
    spriteMinimap.setForceState(0); 
  } else {
    spriteMinimap.setForceState(3);     
  }   
}

//  initial funktion f\u00fcr start am anfang
public void play(int theValue) {
  emptyMenuBG = true;
  initialised = true;

  switch(menu) {
    case 0:
      menu = 1;
      controlP5.hide();
      player.play();  
      startAllScheduledEvents();         
      break;
    case 1:
      controlP5.hide();
      player.play();  
      startAllScheduledEvents();       
      break;
    case 2:    
      replay(0);       
  }  
}

public void quit(int theValue) {
  exit();
}

public void replay(int theValue) {
  doClear = true;  
  pauseAllScheduledEvents();  
  controlP5.hide();
  setup();
}

public void screenshot(int theValue) {
  controlP5.hide();
  player.pause();
  drawSaveOverlay = true;
}

public void switchCursor(int kind) {
  if(switchCursor != kind || useNyancat) {
    switch(kind) {
      case 1: cursor(ARROW); switchCursor = kind; break;
      case 2: cursor(cursorImage_blank); switchCursor = kind; break;   
      case 3: cursor(cursorImage_circle); switchCursor = kind; break;
      case 4: cursor(cursorImage_nyancat); switchCursor = kind;
    }  
  }  
}

public void ToggleCursor() {
  cursorEnabled = !cursorEnabled;
}

// tastatur befehle
// r = reset
// space = play/pause => icon einblenden?
// ???
public void keyReleased() {
  if (ESC == key) { exit(); }
  if ('b' == key || 'B' == key) { switchBGImage = (switchBGImage+1) % 2; initCanvas(true); }  
  if ('d' == key || 'D' == key) { demo(0); }
  if ('f' == key || 'F' == key) { doFilter = (doFilter+1) % 7; }  
  if ('i' == key || 'I' == key) { interactive(0); }
  if ('m' == key || 'M' == key) { minimap(0); }
  if ('n' == key || 'N' == key) {
    switchCursor(useNyancat ? switchCursor : 4);
    useNyancat = !useNyancat;
  }    
  if ('p' == key || 'P' == key) { ToggleCursor(); }
  if (('r' == key || 'R' == key) && initialised) { replay(0); }
  if ('s' == key || 'S' == key) { pauseAllScheduledEvents(); screenshot(0); }
  if (' ' == key) {
    if(player.isPlaying()) {
      pauseAllScheduledEvents();      
      player.pause();
      controlP5.show();
    } else if(initialised && player.position() < 47986) {
      emptyMenuBG = true;
      controlP5.hide(); 
      player.play();      
      startAllScheduledEvents();
    } else if(!initialised) {
      play(0);
    }  
  }
}
// extend me please
class RoundSprite {
 
  float x, y, radius;
  float speedX, speedY;
  RoundSprite(float x, float y, float radius,
                  float speedX, float speedY){
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.speedX = speedX;
    this.speedY = speedY;
  }
  public void move(){
    x += speedX;
    y += speedY;
  }
 
  public void checkBoundaries(){
    if (x>width-radius-20){
      x = width-radius;
      speedX *= -1;
 
    }
    if (x<radius){
      x = radius;
      speedX *= -1;
    }
    if (y>height-radius-20){
      y = height-radius;
      speedY *= -1;
    }
    if (y<radius){
      y = radius;
      speedY *= -1;
    }
  }
}


class Bot extends RoundSprite{
 
  Bot(float x, float y, float radius, 
         float speedX, float speedY){
    super(x, y, radius, speedX, speedY);
  }
 
  public void create(){
    //ellipse(x, y, radius*2, radius*2);
  }
}

class RoboMouse extends RoundSprite{
 
  Robot robot;
  float localX, localY; 
 
  RoboMouse(float x, float y, float radius, 
               float speedX, float speedY){
    super(x, y, radius, speedX, speedY);
    localX = frame.getLocation().x/2;
    localY = frame.getLocation().y/2;
    try { 
      robot = new Robot();
    } 
    catch (AWTException e) {
      e.printStackTrace(); 
    }
  }
 
  public void checkBoundaries(){
    if (x>width-radius+localX){
      x = width-radius+localX;
      speedX *= -1;
    }
    if (x<radius+localX){
      x = radius+localX;
      speedX *= -1;
    }
    if (y>height-radius+localY){
      y = height-radius+localY;
      speedY *= -1;
    }
    if (y<radius+localY){
      y = radius+localY;
      speedY *= -1;
    }
  }
 
  public void move(){
    x += speedX;
    y += speedY;
    robot.mouseMove(frame.getLocation().x/2+(int)x, 
                    frame.getLocation().y/2+(int)y);
  }
}
public int calcMiniMapPosX() {
  // delta movement in percent
  float diffX =  (copyOffsetX / (bg.width/100));
  // actual movement
  float verschiebungX = 1.6f * diffX; // 1.6 = bg.width/50/100
  return (int) verschiebungX;
}

public int calcMiniMapPosY() {
  // delta movement in percent
  float diffY =  (copyOffsetY / (bg.height/100));
  // actual movement
  float verschiebungY = 0.18f * diffY; // 0.18 = bg.height/50/100  
  return (int) verschiebungY;
}

public void drawMiniMap(boolean toggle){  
  if(toggle){
    // rgb stroke black
    stroke(0,0,0);
    // stroke width 1 pixel
    strokeWeight(1);
    // rgb fill fully transparent
    fill(0,0,0,50);
    // minimap window position
    // breite und h\u00f6he sind bg.width/50+2 bzw. bg.height/50+2  
    rect(629,9,161,19);
   
    if (drawCounter % 5 == 0) {
      scaledMiniMap = bg.get(0, 0, bg.width, bg.height);
      // resize-Wert ist bg.height/50    
      scaledMiniMap.resize(0, 18);
    }
    image(scaledMiniMap, 630, 10);                    
   
    if (drawCounter % 3 == 0) {
      miniMapPosX = calcMiniMapPosX() + 630;
      miniMapPosY = calcMiniMapPosY() + 10;
    }
   
    // rgb stroke black
    // stroke(0,0,0,0);  check whether actually necessary
    rect(miniMapPosX, miniMapPosY, 16, 9);
  }
}

public void drawVignette(boolean doDraw){
  if(doDraw) { image(vignette, 0, 0); }
}

public PImage getBufSlice() {
  PImage temp;
  temp = bg.get(copyOffsetX, copyOffsetY, copyWidth, copyHeight);
  switch(doFilter) {
    case 1: temp.filter(GRAY); break;
    case 2: temp.filter(INVERT); break;
    case 3: temp.filter(ERODE); break;
    case 4: temp.filter(DILATE); break;   
    case 5: temp.filter(THRESHOLD, 0.8f); break;    
    case 6: temp.filter(POSTERIZE, 4); break;    
    default:
  }    
  return temp;
}

public void initCanvas(boolean useBGImage) {
  bg = createGraphics(8000, 900, JAVA2D);
  bg.beginDraw();  
  bg.smooth();  
  if(useBGImage) {    
    switch(switchBGImage) {
      case 0: bg.background(bgCanvas); break;
      case 1: bg.background(bgCanvasAlt);
    }
    
  } else {
    bg.background(160);
  }  
  bg.endDraw();
}

public void initImages() {
  bgCanvas                = loadImage("bg_leinwand.jpg");
  bgCanvasAlt             = loadImage("bg_leinwand_1.jpg");  
  cursorImage_blank       = loadImage("cursor.png");
  cursorImage_circle      = loadImage("cursor_circle.png");
  cursorImage_nyancat     = loadImage("cursor_nyan.png");
  buttonMap               = loadImage("gui/ButtonMap.png");
  buttonReplay            = loadImage("gui/ButtonReplay.png");
  buttonSave              = loadImage("gui/ButtonSave.png");
  buttonHoverBigPlay      = loadImage("gui/ButtonHoverBigPlay.png"); 
  buttonHoverBigDemo      = loadImage("gui/ButtonHoverBigDemo.png");
  buttonHoverBigInteractive = loadImage("gui/ButtonHoverBigInteractive.png"); 
  buttonHoverBigReplay    = loadImage("gui/ButtonHoverBigReplay.png");
  buttonMaskBig           = loadImage("gui/MaskBig.png");
  buttonMaskSmall         = loadImage("gui/MaskSmall.png");
//buttonExitImage         = loadImage("gui/MaskExit.png");
//buttonDemoImage         = loadImage("gui/MaskDemo.png");
//buttonInteractiveImage  = loadImage("gui/MaskInteractive.png");
//buttonPlayImage         = loadImage("gui/MaskPlay.png");
//buttonReplayImage       = loadImage("gui/MaskReplay.png");
//buttonReplayBigImage    = loadImage("gui/MaskReplayBig.png");
//buttonPauseImage        = loadImage("gui/MaskPause.png");
//buttonMapImage          = loadImage("gui/MaskMap.png");
//buttonSaveImage         = loadImage("gui/MaskSave.png");
  overlayImage            = loadImage("OverlayMenu.png");
  savingImage             = loadImage("OverlaySaving.png");    
  vignette                = loadImage("vignette.png");
//flowerSmall             = loadImage("flowers/flowerSmall.png");
  flowerMedium            = loadImage("flowers/flowerMedium_0.png"); 
  flowerLarge             = loadImage("flowers/flowerLarge.png"); 
  
  for(int i = 0; i < flowersSmall.length; i++) {
    flowersSmall[i]    = loadImage("flowers/flowerSmall_"+i+".png");    
  } 

  for(int i = 0; i < inkSplatter.length; i++) {
    inkSplatter[i]    = loadImage("flowers/n"+i+"_100.png");    
  } 
}  

public void moveMouse() {
  // start = 400 & 225;
  float rand = random(0,1);  
  roboX += (int) random(-1,3);
  boolean dontSkip = false;

  if(0.26f >= rand) {
    roboY += (int) random(10,30);
  } else if(0.26f < rand && 0.5f > rand) {
    roboY -= (int) random(10,30);
  } else {
    roboY += (int) random(-3,3);
  }  
  
  // left boundary 
  if(roboX < frame.getLocation().x + 30) {
    roboX += (int) random(40,70);
  }
  // right boundary
  if(roboX > frame.getLocation().x + width - 30) {
    roboX -= (int) random(40,70);    
  } 

  // upper boundary 
  if(roboY < frame.getLocation().y + 30) {
    roboY += (int) random(40,70);    
  }
  // lower boundary
  if(roboY > frame.getLocation().y + height - 30) {
    roboY -= (int) random(40,70);    
  }

  if(player.position() > 14000 && player.position() < 43300) {
      if(player.position() < 14000) {
        roboY = frame.getLocation().y+225;
      } else if(player.position() < 14500 && player.position() > 14050) {
        roboY = frame.getLocation().y+225-70;
      } else if(player.position() < 15000 && player.position() > 14550) {
        roboY = frame.getLocation().y+225+105;
      } else if(player.position() < 15500 && player.position() > 15050) {
        roboY = frame.getLocation().y+225-50;
      } else if(player.position() < 16000 && player.position() > 15550) {
        roboY = frame.getLocation().y+225;
      } else if(player.position() < 16500 && player.position() > 16050) {
        roboY = frame.getLocation().y+225+50;
      } else if(player.position() < 17000 && player.position() > 16550) {
        roboY = frame.getLocation().y+225-100;
      } else if(player.position() < 17500 && player.position() > 17050) {
        roboY = frame.getLocation().y+225+90;
      } else if(player.position() < 18000 && player.position() > 17500) {
        roboY = frame.getLocation().y+225-90;
      } else if(player.position() < 43300 && player.position() > 43000) {
        roboY = frame.getLocation().y+225+ (int) random(-20,20);
      }
      
      dontSkip = true;     
  }  
  
  if(10 == drawCounter || dontSkip) {
    robot.mouseMove(roboX,roboY); 
  }
}  

public void moveViewport(){ 
  image(getBufSlice(), 0, 0);

  float posX = mouseX-width/2;  // posX,posY sind Koordinaten relativ zum Mittelpunkt
  float posY = mouseY-height/2;
  
  if (drawCounter % 2 == 0) {
    if ((abs(posX) >  scrollProtectionX ) || (abs(posY) >  scrollProtectionY )) {          // Schutzzone
      // "normalisiert" den Richtungsvektor den posY darstellt
      posY = posY * 1.7f;        
      
      directionFactorX = (posX / (abs(posX) + abs(posY)));
      directionFactorY = (posY / (abs(posX) + abs(posY)));
    }
  }

  float xBeschleunigungsFaktor = (abs(directionFactorX) * tempScrollSpeed)/2 + autoScrollX;    // AutoScrolling unabh\u00e4ngig vom Beschleunigungsfaktor              // ABS() ENTFERNEN ZUM SCROLLEN IN BEL. RICHTUNGEN
  float yBeschleunigungsFaktor = directionFactorY * tempScrollSpeed + autoScrollY;
  
  positionCoordX = copyOffsetX + (int) xBeschleunigungsFaktor;
  positionCoordY = copyOffsetY + (int) yBeschleunigungsFaktor;
  
 if(positionCoordX > bg.width - width) {
    positionCoordX = bg.width - width;
  } else if(positionCoordX < 0) {
    positionCoordX = 0;
  }
   
  if(positionCoordY > bg.height - height) {
    positionCoordY = bg.height - height;
  } else if(positionCoordY < 0) {
    positionCoordY = 0;
  }
  
  copyOffsetX = positionCoordX;
  copyOffsetY = positionCoordY;
}  

public boolean testOnCanvasX(int posXCoord) {
  if(positionCoordX > bg.width - width) {
    return false;
  } else if(positionCoordX < 0) {
    return false;
  }
   
   return true;
}

public boolean testOnCanvasY(int posYCoord) {
  if(positionCoordY > bg.height - height) {
    return false;
  } else if(positionCoordY < 0) {
    return false;
  }
   
  return true;
}

public String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "BangBang" });
  }
}
