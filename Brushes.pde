/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
void brushOne() {
  buf.noStroke();
  buf.fill(0,0,0,150); 
  angle += 10;
  float val = cos(radians(angle)) * 10.0;
  for (int a = 0; a < 360; a += 72) { // += als parameter für Pinselmuster
    float xoff = cos(radians(a)) * val;
    float yoff = sin(radians(a)) * val;    
    buf.ellipse(x + copyOffsetX + xoff, y + copyOffsetY + yoff + player.left.get(0) * 50, val + player.left.get(0) * 20, val + player.left.get(0) * 20);
  }
  buf.fill(0,0,0,255);
  buf.ellipse(x + copyOffsetX, y + copyOffsetY + player.left.get(0) * 50, 2 , 2);

  // Mittelpunkt des Pinsels abgreifen zur Verwendung für Effekte
  if(drawCounter % 1 == 0) {                              
    lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
    lastMousePosY[drawCounter%30] = (int) y + copyOffsetY + (int) (player.left.get(0) * 50);
  }

}

// kontinuierliche linie
void brushTwo() {
  buf.stroke(0,0,0);
  buf.strokeWeight(5);     
  buf.line(mouseX + copyOffsetX, mouseY + copyOffsetY, pmouseX + prevOffsetX, pmouseY + prevOffsetY);
}

void brushThree() {
  buf.stroke(0,0,0);
  buf.strokeWeight(5); 

  int test = (int) (y + copyOffsetY + player.left.get(0) * 70);
  buf.line(x + copyOffsetX, test, deltaMouseX, deltaMouseY);
  
  if (drawCounter % 10 == 0) {
    buf.strokeWeight(1); 
    buf.line(directionArrayX[drawCounter%10], directionArrayY[drawCounter%10], x + copyOffsetX, test);
  }
 
  
  deltaMouseX = (int) x + copyOffsetX;
  deltaMouseY = test;
}
