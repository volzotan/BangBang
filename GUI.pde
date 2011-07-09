// gui instanz und buttons erstellen
void setupGUI(){
  controlP5 = new ControlP5(this);
  Button playButton = controlP5.addButton("Play",0,(int) width/2-100,(int) height/2-100,200,200);
  
  // settings playbutton
  playButton.setColorActive(color(255,255,255,0));
  playButton.setColorBackground(color(255,255,255,0));
  playButton.setColorForeground(color(255,255,255,0));
  playButton.setColorValue(color(255,255,255,0));
  playButton.setLabel("");
}

void endGUI(){
  controlP5 = new ControlP5(this);
  Button replayButton = controlP5.addButton("Replay",0,(int) width/2-100,(int) height/2-100,200,200);
  
  // settings replaybutton
  replayButton.setColorActive(color(255,255,255,0));
  replayButton.setColorBackground(color(255,255,255,0));
  replayButton.setColorForeground(color(255,255,255,0));
  replayButton.setColorValue(color(255,255,255,0));
  replayButton.setLabel("");
}

// gui zeichnen
void drawGUI(){
  controlP5.show();
  controlP5.draw();
}

//  initial funktion für start am anfang
public void Play(int theValue) {
  initialised = true;
  player.play();
}

public void Replay(int theValue) {
  doClear = true;
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
      player.play();
    } else if(!initialised) {
      Play(0);
    }  
  }
}
