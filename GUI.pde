// gui instanz und buttons erstellen
void setupGUI(){
  doStart = true;
  controlP5 = new ControlP5(this);
  controlP5.addButton("Play",0,(int) width/2-100,(int) height/2-100,200,200);
  controlP5.setColorActive(color(255,255,255,0));
  controlP5.setColorBackground(color(255,255,255,0));
  controlP5.setColorForeground(color(255,255,255,0));
  controlP5.setColorLabel(color(255,255,255,0));
  controlP5.setColorValue(color(255,255,255,0));
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

// tastatur befehle
// r = reset
// space = play/pause => icon einblenden?
// ???
void keyReleased() {
  if ('r' == key  || 'R' == key) { doClear = true; }
  if (' ' == key) { 
    if(player.isPlaying()) {
      player.pause();
    } else if(initialised && player.position() < player.length()) {
      player.play();
    }  
  }
}
