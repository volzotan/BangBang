void setupGUI(){
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
  interactive = controlP5.addButton("interactive",0, 200,80,175,175);
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
void drawGUI() {
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

//  initial funktion für start am anfang
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

void switchCursor(int kind) {
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
void keyReleased() {
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
