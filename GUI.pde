void setupGUI(){
  controlP5 = new ControlP5(this);
  
  // sprites
  spritePause   = new ControllerSprite(controlP5,buttonHoverBigImage,220,220,3);
  spritePause.setMask(buttonPauseImage);
  spritePause.enableMask();    
  spritePlay    = new ControllerSprite(controlP5,buttonHoverBigImage,220,220,3);
  spritePlay.setMask(buttonPlayImage);
  spritePlay.enableMask();  
  spriteRestart = new ControllerSprite(controlP5,buttonHoverBigImage,220,220,3);
  spriteRestart.setMask(buttonReplayBigImage);
  spriteRestart.enableMask();  
  spriteSmall   = new ControllerSprite(controlP5,buttonHoverImage,100,100,3);
  spriteMinimapE= new ControllerSprite(controlP5,buttonHoverImage,100,100,3);
  spriteMinimapE.setMask(buttonMapONImage);
  spriteMinimapE.enableMask();   
  spriteMinimapD= new ControllerSprite(controlP5,buttonHoverImage,100,100,3);
  spriteMinimapD.setMask(buttonMapOFFImage);
  spriteMinimapD.enableMask();  
  
  // demo button
  // used in: start; finished
  spriteSmall.setMask(buttonDemoImage);
  spriteSmall.enableMask();
  demo = controlP5.addButton("demo",0,165,(int) height/2-50,100,100);
  demo.setSprite(spriteSmall.clone());  
  
  // minimap button
  // used in: start; playing/paused;   
  minimap = controlP5.addButton("minimap",0,535,(int) height/2-50,100,100);
  minimap.setSprite(spriteMinimapD);  
   
  // play button (doubles as pause and large restart button)
  // used in: start (play); playing/paused (pause/play); finished (restart)
  play = controlP5.addButton("play",0,(int) width/2-110,(int) height/2-110,220,220);
  play.setSprite(spritePlay);
 
  // exit button
  // used in: start; playing/paused; finished
  spriteSmall.setMask(buttonExitImage);
  spriteSmall.enableMask();
  quit = controlP5.addButton("quit",0,40,(int) height/2-50,100,100);
  quit.setSprite(spriteSmall.clone()); 

  // replay button
  // used in: playing/paused; finished
  spriteSmall.setMask(buttonReplayImage);
  spriteSmall.enableMask();
  replay = controlP5.addButton("replay",0,165,(int) height/2-50,100,100);
  replay.setSprite(spriteSmall.clone()); 

  // save button
  // used in: playing/paused; finished
  spriteSmall.setMask(buttonSaveImage);
  spriteSmall.enableMask();
  screenshot = controlP5.addButton("screenshot",0,660,(int) height/2-50,100,100);
  screenshot.setSprite(spriteSmall.clone()); 
}

// DRAW GUI
void drawGUI() {
  // position buttons on the screen
  switch(menu) {
    // start 535
    case 0:
      demo.show();
      minimap.show();
      // make sure correct play sprite is set
      play.setSprite(spritePlay);
      play.show();
      quit.show();
      replay.hide();
      screenshot.hide();
      break;    
    // playing
    case 1: 
      demo.hide();
      minimap.show();
      // alternate between play/pause if the button is highlighted
      if(mouseX > 290 && mouseX < 510 && mouseY > 115 && mouseY < 335) {
        play.setSprite(spritePlay);        
      } else {
        play.setSprite(spritePause);      
      }
      play.show(); 
      quit.show();
      replay.show();
      screenshot.show();
      break;
    // finished
    case 2: 
      demo.hide();
      minimap.hide();
      // set replay sprite
      play.setSprite(spriteRestart);
      play.show();
      quit.show();
      replay.hide();
      screenshot.show();
      if(!drawSaveOverlay) { controlP5.show(); }
  }  
}

public PImage getMenuBG(int b, int m) {
  if(emptyMenuBG || (!emptyMenuBG && drawSaveOverlay)) {
    emptyMenuBG = false;
    tempMenuBG = getBufSlice();
    tempMenuBG.filter(BLUR, b);
    switch(m) {
      case 1 : tempMenuBG.blend(overlayImage, 0, 0, width, height,   0,   0, width, height, MULTIPLY); break;
      case 2 : tempMenuBG.blend(overlayImage, 0, 0, width, height,   0,   0, width, height, MULTIPLY);
               tempMenuBG.blend(savingImage , 0, 0, width, height, 290, 115,   220,    220, LIGHTEST); break;
    }
  }
  return tempMenuBG;
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

public void replay(int theValue) {
  doClear = true;  
  pauseAllScheduledEvents();  
  controlP5.hide();
  setup();
}

public void minimap(int theValue) {
  minimapEnabled = !minimapEnabled;
  // minimap button status
  if(minimapEnabled) {
    minimap.setSprite(spriteMinimapE);   
  } else {
    minimap.setSprite(spriteMinimapD);    
  }   
}

public void quit(int theValue) {
  exit();
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

public void screenshot(int theValue) {
  controlP5.hide();
  player.pause();
  drawSaveOverlay = true;
}

// tastatur befehle
// r = reset
// space = play/pause => icon einblenden?
// ???
void keyReleased() {
  if (ESC == key) { exit(); }
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
