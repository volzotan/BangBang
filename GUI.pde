// gui instanz und buttons erstellen
void setupGUI(){
  controlP5 = new ControlP5(this);
  controlP5.addButton("Play",0,(int) width/2-40,(int) height/2-10,80,20);
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
