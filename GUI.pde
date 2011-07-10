void setupGUI(){
  setupP5 = new ControlP5(this);
  breakP5 = new ControlP5(this);
  endP5 = new ControlP5(this);
 
  // STARTUP MENU (1)
  ControllerSprite playSprite = new ControllerSprite(setupP5,mainButtonImage,220,220);
  playSprite.setMask(loadImage("buttons/PlayMask.png"));
  playSprite.enableMask();

  Button playButton = setupP5.addButton("Play",0,(int) width/2-110,(int) height/2-110,220,220);
  playButton.setSprite(playSprite);

  // BREAK MENU (2)
  ControllerSprite breakSprite = new ControllerSprite(breakP5,mainButtonImage,220,220);
  breakSprite.setMask(loadImage("buttons/BreakMask.png"));
  breakSprite.enableMask();

  Button breakButton = breakP5.addButton("Break",0,(int) width/2-110,(int) height/2-110,220,220);
  breakButton.setSprite(breakSprite);
  
  // END MENU (3)
  ControllerSprite replaySprite = new ControllerSprite(endP5,mainButtonImage,220,220);
  replaySprite.setMask(loadImage("buttons/ReplayMask.png"));
  replaySprite.enableMask();
  
  Button replayButton = endP5.addButton("Play",0,(int) width/2-110,(int) height/2-110,220,220);
  replayButton.setSprite(replaySprite);
}

// DRAW GUI
void drawGUI(int openMenu){
  switch(openMenu){
    case 1 : closeGUI(2); closeGUI(3); setupP5.show(); setupP5.draw(); break;
    case 2 : closeGUI(1); closeGUI(3); breakP5.show(); breakP5.draw(); break;
    case 3 : closeGUI(1); closeGUI(2); endP5.show(); endP5.draw(); break;
  }
}

// CLOSE GUI
void closeGUI(int closeMenu){
  switch(closeMenu){
    case 1 : setupP5.hide(); break;
    case 2 : breakP5.hide(); break;
    case 3 : endP5.hide(); break;
  }
}

//  initial funktion für start am anfang
public void Play(int theValue) {
  if(usePlay) {
    initialised = true;
    player.play();
    usePlay = false;
  } else {
    doClear = true;
    usePlay = true;
  }
}

public void Break(int theValue) {
  if(initialised && player.position() < 47986) {
    closeGUI(2);
    player.play();
  } else if(!initialised) {
    Play(0);
  }
}  

// tastatur befehle
// r = reset
// space = play/pause => icon einblenden?
// ???
void keyReleased() {
  if ('r' == key || 'R' == key) { doClear = true; }
  if ('s' == key || 'S' == key) { buf.save(timestamp() +".png"); }
  if (' ' == key) { 
    if(player.isPlaying()) {
      player.pause();
    } else if(initialised && player.position() < 47986) {
      closeGUI(2);
      player.play();
    } else if(!initialised) {
      Play(0);
    }  
  }
}
