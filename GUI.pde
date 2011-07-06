void setupGUI(){
  controlP5 = new ControlP5(this);
  controlP5.addButton("Play",0,(int) width/2-40,(int) height/2-10,80,20);

}

void drawGUI(){
  controlP5.show();
  controlP5.draw();
}

public void Play(int theValue) {
  initialised = true;
  player.play();
}
