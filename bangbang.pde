// ---- Timer and event scheduling ----
import java.util.Timer;
import java.util.TimerTask;
// timer
Timer timer;
int elapsedTime = 0;

// ---- import GUI ----
import controlP5.*;
// GUI
ControlP5 setupP5, breakP5, endP5;
PImage tempMenuBG, mainButtonImage, menuButtonImage, resetButtonImage, mapEButtonImage, mapDButtonImage, exitButtonImage, demoButtonImage, saveButtonImage, savingImage, overlayImage, cursorImage_blank, cursorImage_circle, cursorImage_nyancat;
boolean mapEnabled = false, cursorEnabled = true, useNyancat = false, emptyMenuBG; // emptyMenuBG = still photo flag
// switch Cursor: 1 = pfeil, 2 = leer, 3 = custom, else do nothing; wasGUI: previous GUI number
int switchCursor, wasGUI;

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
PImage vignette, bgCanvas, bgTransparent;
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
int brushThreeDeflectionScale = 100;
// use ghost brush?
boolean ghostBrush = false;
// use main brush ?
boolean mainBrushActive;

// ---- Effects ----
// player position in milliseconds
int pos = 0;
// ink splatter array containing the loaded images
PImage inkSplatter[] = new PImage[10];
// last used quadrant: 0 (top right), 1 (top left), 2 (bottom left), 3 (bottom right)
int inkSplatterPos;

// ---- Nyancat
color nyanColor = color(255,	42,	12);
int tempNyanPos, tempNyanCol;

// direction sensitive drawing
int[] directionArrayX = new int[10];
int[] directionArrayY = new int[10];

// ---- Save Overlay
int saveReady = 0;							// says whether the application may now save the canvas to file
boolean drawSaveOverlay = false;// says whether the overlay should be drawn

// TODO WHERE DO THESE BELONG, WHAT DO THESE DO?
int invsVar = 1;
int amp = 200;
float xPlus = 0;
int oldX, oldDeltaX;
int oldY, oldDeltaY;
boolean firstRun;
int tempX, tempY;

// ---- Generic ----
boolean initialised, doClear = false, doInvert = false;
String savePath;
// use this with % to execute functions at every nth draw execution
int drawCounter = 0;

void setup(){
	// Create Applet Window and set maximum frame rate
	size(800, 450, JAVA2D);
	background(150,0,0);
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
	wasGUI = 0;
	// make sure start up GUI window is shown
	initialised = false;
	// clear/set save image path	
	savePath = "";
	
	
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
	scaledMiniMap = bg.get(0, 0, bg.width, bg.height);
	// resize value is bg.height/50 || where else would this need to be changed in case of canvas size changes?
	scaledMiniMap.resize(0, 18);
}

void draw() {	
	// Startup GUI
	if(!initialised) {
		// use regular Cursor
		switchCursor(1);
		// get static background image
		image(getMenuBG(0, 1), 0, 0); 
		// draw GUI
		drawGUI(1);
	// Playing, Pausing, End
	} else {	
		// Save Canvas as image part 2: save image
		if (saveReady == 2) {
			if(initialised) {
				savePath = selectOutput("Save Canvas to:");
				if(savePath != null && savePath != "") {
					if(!savePath.endsWith(".png") && !savePath.endsWith(".jpg") && !savePath.endsWith(".jpeg") && !savePath.endsWith(".tif") && !savePath.endsWith(".tga") && !savePath.endsWith(".tiff")) {
						savePath += ".jpg";
					}
				} 
				try {
					bg.save(savePath);		// dataPath("shots/"+timestamp() +".png")
				} catch(Exception e) {
					// TODO make work accordingly ? can't seem to catch any exception here
				}
				savePath = "";			
			} 
			if(initialised && player.position() < 47986 && wasGUI == 0) {
				player.play(); 
				startAllScheduledEvents();
				emptyMenuBG = true;
			} else {
				wasGUI = 0;
			}
			saveReady = 0;
		}		
		
		// close startup gui
		closeGUI(1); // TODO move to a single call, not continous
		// get dampened mouse position			 
		x = x + (mouseX-x)/mouseDampeningX;
		y = y + (mouseY-y)/mouseDampeningY;

		// TODO should this really happen in here?
		drawCounter = (drawCounter+1) % 30;
		pos = player.position();
			
		if(player.isPlaying() && player.position() < 47986) {
			// get beat from playing song
			beat.detect(player.mix);
			if(beat.isOnset()) {
				 tempBrushValue = 80; 
			}
			
			switchCursor(cursorEnabled ? (useNyancat ? 4 : 3) : 2);
			moveViewport();
			if (mainBrushActive) {				
				brushThree();
				if (ghostBrush) {
					ghostBrush();
				}
			}								 
			
			directionArrayX[drawCounter % 10] = (int) x + copyOffsetX;
			directionArrayY[drawCounter % 10] = (int) y + copyOffsetY;			
		
			drawVignette(true);
			drawMiniMap(mapEnabled);			 
			tempBrushValue *= 0.95;
		 	// Grab mouse position for use in effects and brushes
		 	if(drawCounter % 1 == 0) {															
				lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
				lastMousePosY[drawCounter%30] = (int) y + copyOffsetY;
			}			
		} else {
			switchCursor(1);
			if (player.position() < 47986 && !drawSaveOverlay) {
				image(getMenuBG(2, 1), 0, 0);
				drawGUI(2); 
			} else if (!drawSaveOverlay) {
				pauseAllScheduledEvents();
				image(getMenuBG(2, 1), 0, 0);
				drawGUI(3);		 
			}		 
		}		
	
		if (drawCounter % 3 == 0) {
			prevOffsetX = copyOffsetX;
			prevOffsetY = copyOffsetY;
		}	 
		
		// Save image as canvas part one: draw overlay
		if(drawSaveOverlay){
			image(getMenuBG(2, 2), 0, 0); 
			switch(saveReady) {
				case 0: saveReady++; break;
				case 1: saveReady++;
						drawSaveOverlay = false;
						emptyMenuBG = true;
			}
		}		
	}	
	// ---- Debug Info ----
	//println(frameRate + " at " + player.position()); 
}
	
void stop() {
	player.close();
	minim.stop();
	super.stop();
}
