ControllerSprite startSpriteMapON, startSpriteMapOFF, breakSpriteMapOFF, breakSpriteMapON, breakSpritePause;
Button startButtonMap, breakButtonMap;

void setupGUI(){
  startP5 = new ControlP5(this);
  breakP5 = new ControlP5(this);
  endP5 = new ControlP5(this);
 
  // STARTUP MENU (1)
  // --> Exit
  ControllerSprite startSpriteExit = new ControllerSprite(startP5,buttonHoverImage,100,100);
  startSpriteExit.setMask(buttonExitImage);
  startSpriteExit.enableMask();
  Button startButtonExit = startP5.addButton("Exit",0,40,(int) height/2-50,100,100);
  startButtonExit.setSprite(startSpriteExit);
  
  // --> Demo
  ControllerSprite startSpriteDemo = new ControllerSprite(startP5,buttonHoverImage,100,100);
  startSpriteDemo.setMask(buttonDemoImage);
  startSpriteDemo.enableMask();
  Button startButtonDemo = startP5.addButton("",0,165,(int) height/2-50,100,100);
  startButtonDemo.setSprite(startSpriteDemo);
  
  // --> Play
  ControllerSprite startSpritePlay = new ControllerSprite(startP5,buttonHoverBigImage,220,220);
  startSpritePlay.setMask(buttonPlayImage);
  startSpritePlay.enableMask();
  Button startButtonPlay = startP5.addButton("Play",0,(int) width/2-110,(int) height/2-110,220,220);
  startButtonPlay.setSprite(startSpritePlay);  
  
  // --> MapToggle
  startSpriteMapOFF = new ControllerSprite(startP5,buttonHoverImage,100,100);
  startSpriteMapOFF.setMask(buttonMapOFFImage);
  startSpriteMapOFF.enableMask();
  
  startSpriteMapON = new ControllerSprite(startP5,buttonHoverImage,100,100);
  startSpriteMapON.setMask(buttonMapONImage);
  startSpriteMapON.enableMask();
  startButtonMap = startP5.addButton("EnableMap",0,535,(int) height/2-50,100,100);
  if(!mapEnabled) {   
    startButtonMap.setSprite(startSpriteMapOFF);
  } else {        
    startButtonMap.setSprite(startSpriteMapON);
  }

  // PAUSE MENU (2)
  // --> Exit
  ControllerSprite breakSpriteExit = new ControllerSprite(breakP5,buttonHoverImage,100,100);
  breakSpriteExit.setMask(buttonExitImage);
  breakSpriteExit.enableMask();
  Button breakButtonExit = breakP5.addButton("Exit",0,40,(int) height/2-50,100,100);
  breakButtonExit.setSprite(breakSpriteExit);
  
  // --> Pause
  breakSpritePause = new ControllerSprite(breakP5,buttonHoverBigImage,220,220);  
  breakSpritePause.setMask(buttonPauseImage);  
  breakSpritePause.enableMask();
  Button breakButtonPause = breakP5.addButton("Break",0,(int) width/2-110,(int) height/2-110,220,220);
  breakButtonPause.setSprite(breakSpritePause);
  
  // --> MapToggle
  breakSpriteMapOFF = new ControllerSprite(breakP5,buttonHoverImage,100,100);
  breakSpriteMapOFF.setMask(buttonMapOFFImage);
  breakSpriteMapOFF.enableMask();
  
  breakSpriteMapON = new ControllerSprite(breakP5,buttonHoverImage,100,100);
  breakSpriteMapON.setMask(buttonMapONImage);
  breakSpriteMapON.enableMask();
  
  breakButtonMap = breakP5.addButton("EnableMap",0,535,(int) height/2-50,100,100);
  if(!mapEnabled) {   
    breakButtonMap.setSprite(breakSpriteMapOFF);
  } else {        
    breakButtonMap.setSprite(breakSpriteMapON);
  }
  
  // --> Replay
  ControllerSprite breakSpriteReplay = new ControllerSprite(breakP5,buttonHoverImage,100,100);
  breakSpriteReplay.setMask(buttonReplayImage);
  breakSpriteReplay.enableMask();
  Button breakButtonReplay = breakP5.addButton("Replay",0,165,(int) height/2-50,100,100);
  breakButtonReplay.setSprite(breakSpriteReplay);
  
  // --> Save
  ControllerSprite breakSpriteSave = new ControllerSprite(breakP5,buttonHoverImage,100,100);
  breakSpriteSave.setMask(buttonSaveImage);
  breakSpriteSave.enableMask();
  Button breakButtonSave = breakP5.addButton("Save",0,660,(int) height/2-50,100,100);
  breakButtonSave.setSprite(breakSpriteSave);
  
  // END MENU (3)
  // --> Exit
  ControllerSprite endSpriteExit = new ControllerSprite(endP5,buttonHoverImage,100,100);
  endSpriteExit.setMask(buttonExitImage);
  endSpriteExit.enableMask();
  Button endButtonExit = endP5.addButton("Exit",0,40,(int) height/2-50,100,100);
  endButtonExit.setSprite(endSpriteExit);
  
  // --> Replay
  ControllerSprite endSpriteReplay = new ControllerSprite(endP5,buttonHoverBigImage,220,220);
  endSpriteReplay.setMask(buttonReplayBigImage);
  endSpriteReplay.enableMask();
  Button endButtonReplay = endP5.addButton("Replay",0,(int) width/2-110,(int) height/2-110,220,220);
  endButtonReplay.setSprite(endSpriteReplay);
  
  // --> Save
  ControllerSprite endSpriteSave = new ControllerSprite(endP5,buttonHoverImage,100,100);
  endSpriteSave.setMask(buttonSaveImage);
  endSpriteSave.enableMask();
  Button endButtonSave = endP5.addButton("Save",0,660,(int) height/2-50,100,100);
  endButtonSave.setSprite(endSpriteSave);
}

// DRAW GUI
void drawGUI(int openMenu){
  switch(openMenu){
    case 1 : closeGUI(2); closeGUI(3); startP5.show(); startP5.draw();             break;
    case 2 : closeGUI(1); closeGUI(3); breakP5.show(); breakP5.draw(); wasGUI = 2; break;
    case 3 : closeGUI(1); closeGUI(2); endP5.show();   endP5.draw();   wasGUI = 3; 
  }
}

// CLOSE GUI
void closeGUI(int closeMenu){
  switch(closeMenu) {
    case 1 : startP5.hide(); break;
    case 2 : breakP5.hide(); break;
    case 3 : endP5.hide();   break;
    case 4 : startP5.hide(); breakP5.hide(); endP5.hide();
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
public void Play(int theValue) {
  emptyMenuBG = true;
  initialised = true;
  player.play();  
  startAllScheduledEvents();  
}

public void Replay(int theValue) {
  closeGUI(4);
  doClear = true;  
  pauseAllScheduledEvents();  
  setup();
}

public void Break(int theValue) {
  if(initialised && player.position() < 47986) {
    closeGUI(2);
    emptyMenuBG = true;
    player.play();
    startAllScheduledEvents();
  } else if(!initialised) {
    Play(0);
  }
}

public void EnableMap(int theValue) {
  mapEnabled = (mapEnabled) ? false : true;
  if(!mapEnabled) {   
    startButtonMap.setSprite(startSpriteMapOFF);
    breakButtonMap.setSprite(breakSpriteMapOFF);
  } else {        
    startButtonMap.setSprite(startSpriteMapON);
    breakButtonMap.setSprite(breakSpriteMapON);
  }  
}

public void Exit(int theValue) {
  exit();
}

public void ToggleCursor() {
  cursorEnabled = !cursorEnabled;
}

public void Save(int theValue) {
  player.pause();
  drawSaveOverlay = true;
  closeGUI(4);
}

// tastatur befehle
// r = reset
// space = play/pause => icon einblenden?
// ???
void keyReleased() {
  if (ESC == key) { exit(); }
  if ('m' == key || 'M' == key) { EnableMap(0); }
  if ('n' == key || 'N' == key) {
    switchCursor(useNyancat ? switchCursor : 4);
    useNyancat = !useNyancat;
  }    
  if ('p' == key || 'P' == key) { ToggleCursor(); }
  if ('r' == key || 'R' == key) { Replay(0); }
  if ('s' == key || 'S' == key) { pauseAllScheduledEvents(); Save(0); }
  if (' ' == key) {
    if(player.isPlaying()) {
      pauseAllScheduledEvents();      
      player.pause();
    } else if(initialised && player.position() < 47986) {
      closeGUI(2);
      emptyMenuBG = true;
      player.play();      
      startAllScheduledEvents();
    } else if(!initialised) {
      Play(0);
    }  
  }
}
