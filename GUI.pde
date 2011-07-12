ControllerSprite setupMapDisSprite, setupMapEnSprite, breakMapDisSprite, breakMapEnSprite;
Button setupMapToggleButton, breakMapToggleButton;

void setupGUI(){
  setupP5 = new ControlP5(this);
  breakP5 = new ControlP5(this);
  endP5 = new ControlP5(this);
 
  // STARTUP MENU (1)
  // -> main (initial play)
  ControllerSprite playSprite = new ControllerSprite(setupP5,mainButtonImage,220,220);
  playSprite.setMask(loadImage("buttons/PlayMask.png"));
  playSprite.enableMask();

  Button playButton = setupP5.addButton("Play",0,(int) width/2-110,(int) height/2-110,220,220);
  playButton.setSprite(playSprite);
  
  // -> right top
  setupMapDisSprite = new ControllerSprite(setupP5,menuButtonImage,250,120);
  setupMapDisSprite.setMask(mapDButtonImage);
  setupMapDisSprite.enableMask();
  setupMapToggleButton = setupP5.addButton("EnableMap",0,530,105,250,120);
  
  setupMapEnSprite = new ControllerSprite(setupP5,menuButtonImage,250,120);
  setupMapEnSprite.setMask(mapEButtonImage);
  setupMapEnSprite.enableMask();
  if(!mapEnabled) {   
    setupMapToggleButton.setSprite(setupMapDisSprite);
  } else {        
    setupMapToggleButton.setSprite(setupMapEnSprite);
  }  
  
  // -> left top
  ControllerSprite setupDemoSprite = new ControllerSprite(setupP5,menuButtonImage,250,120);
  setupDemoSprite.setMask(demoButtonImage);
  setupDemoSprite.enableMask();
  
  Button setupDemoButton = setupP5.addButton("Demo",0,20,105,250,120);
  setupDemoButton.setSprite(setupDemoSprite);
  
  // -> left bottom (exit)
  ControllerSprite setupExitSprite = new ControllerSprite(setupP5,menuButtonImage,250,120);
  setupExitSprite.setMask(exitButtonImage);
  setupExitSprite.enableMask();
  
  Button setupExitButton = setupP5.addButton("Exit",0,20,225,250,120);
  setupExitButton.setSprite(setupExitSprite);

  // BREAK MENU (2)
  // -> main (break)
  ControllerSprite breakSprite = new ControllerSprite(breakP5,mainButtonImage,220,220);
  breakSprite.setMask(loadImage("buttons/BreakMask.png"));
  breakSprite.enableMask();

  Button breakButton = breakP5.addButton("Break",0,(int) width/2-110,(int) height/2-110,220,220);
  breakButton.setSprite(breakSprite);
  
  // -> right top
  breakMapDisSprite = new ControllerSprite(breakP5,menuButtonImage,250,120);
  breakMapDisSprite.setMask(mapDButtonImage);
  breakMapDisSprite.enableMask();
  breakMapToggleButton = breakP5.addButton("EnableMap",0,530,105,250,120);
  
  breakMapEnSprite = new ControllerSprite(breakP5,menuButtonImage,250,120);
  breakMapEnSprite.setMask(mapEButtonImage);
  breakMapEnSprite.enableMask();
  if(!mapEnabled) {   
    breakMapToggleButton.setSprite(breakMapDisSprite);
  } else {        
    breakMapToggleButton.setSprite(breakMapEnSprite);
  }
  
  // -> left top (reset)
  ControllerSprite breakResetSprite = new ControllerSprite(breakP5,menuButtonImage,250,120);
  breakResetSprite.setMask(resetButtonImage);
  breakResetSprite.enableMask();
  
  Button breakResetButton = breakP5.addButton("Replay",0,20,105,250,120);
  breakResetButton.setSprite(breakResetSprite);
  
  // -> left bottom (exit)
  ControllerSprite breakExitSprite = new ControllerSprite(breakP5,menuButtonImage,250,120);
  breakExitSprite.setMask(exitButtonImage);
  breakExitSprite.enableMask();
  
  Button breakExitButton = breakP5.addButton("Exit",0,20,225,250,120);
  breakExitButton.setSprite(breakExitSprite);
  
  // -> right bottom (save)
  ControllerSprite breakSaveSprite = new ControllerSprite(breakP5,menuButtonImage,250,120);
  breakSaveSprite.setMask(saveButtonImage);
  breakSaveSprite.enableMask();
  
  Button breakSaveButton = breakP5.addButton("Save",0,530,225,250,120);
  breakSaveButton.setSprite(breakSaveSprite);
  
  // END MENU (3)
  // -> main (replay)
  ControllerSprite replaySprite = new ControllerSprite(endP5,mainButtonImage,220,220);
  replaySprite.setMask(loadImage("buttons/ReplayMask.png"));
  replaySprite.enableMask();
  
  Button replayButton = endP5.addButton("Replay",0,(int) width/2-110,(int) height/2-110,220,220);
  replayButton.setSprite(replaySprite);
  
  // -> left bottom (exit)
  ControllerSprite endExitSprite = new ControllerSprite(endP5,menuButtonImage,250,120);
  endExitSprite.setMask(exitButtonImage);
  endExitSprite.enableMask();
  
  Button endExitButton = endP5.addButton("Exit",0,20,225,250,120);
  endExitButton.setSprite(endExitSprite);
  
  // -> right bottom (save)
  ControllerSprite endSaveSprite = new ControllerSprite(endP5,menuButtonImage,250,120);
  endSaveSprite.setMask(saveButtonImage);
  endSaveSprite.enableMask();
  
  Button endSaveButton = endP5.addButton("Save",0,530,225,250,120);
  endSaveButton.setSprite(endSaveSprite);
}

// DRAW GUI
void drawGUI(int openMenu){
  switch(openMenu){
    case 1 : closeGUI(2); closeGUI(3); setupP5.show(); setupP5.draw(); break;
    case 2 : closeGUI(1); closeGUI(3); breakP5.show(); breakP5.draw(); wasGUI = 2; break;
    case 3 : closeGUI(1); closeGUI(2); endP5.show();   endP5.draw();   wasGUI = 3;
  }
}

// CLOSE GUI
void closeGUI(int closeMenu){
  switch(closeMenu) {
    case 1 : setupP5.hide(); break;
    case 2 : breakP5.hide(); break;
    case 3 : endP5.hide(); break;
    case 4 : setupP5.hide(); breakP5.hide(); endP5.hide();
  }
}

//  initial funktion für start am anfang
public void Play(int theValue) {
  initialised = true;
  player.play();  
  startAllScheduledEvents();  
  usePlay = false;
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
    player.play();
    startAllScheduledEvents();
  } else if(!initialised) {
    Play(0);
  }
}

public void EnableMap(int theValue) {
  mapEnabled = (mapEnabled) ? false : true;
  if(!mapEnabled) {   
    setupMapToggleButton.setSprite(setupMapDisSprite);
    breakMapToggleButton.setSprite(breakMapDisSprite);
  } else {        
    setupMapToggleButton.setSprite(setupMapEnSprite);
    breakMapToggleButton.setSprite(breakMapEnSprite);
  }  
}

public void Exit(int theValue) {
  exit();
}

public void ToggleCursor() {
  cursorEnabled = !cursorEnabled;
}

public void Save(int theValue) {
    drawSaveOverlay = true;
    player.pause();
    closeGUI(4);
}

// tastatur befehle
// r = reset
// space = play/pause => icon einblenden?
// ???
void keyReleased() {
  if (ESC == key) { exit(); }
  if ('m' == key || 'M' == key) { EnableMap(0); }
  if ('n' == key || 'N' == key) { switchCursor(useNyancat ? switchCursor : 4); }    
  if ('p' == key || 'P' == key) { ToggleCursor(); }
  if ('r' == key || 'R' == key) { Replay(0); }
  if ('s' == key || 'S' == key) {
    pauseAllScheduledEvents();
    Save((player.isPlaying()) ? 1 : 0); 
  }
  if (' ' == key) { 
    if(player.isPlaying()) {      
      pauseAllScheduledEvents();      
      player.pause();
    } else if(initialised && player.position() < 47986) {
      closeGUI(2);
      player.play();      
      startAllScheduledEvents();
    } else if(!initialised) {
      Play(0);
    }  
  }
}
