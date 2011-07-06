/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
void BrushOne() {
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
    lastMousePosY[drawCounter%30] = (int) y + copyOffsetY + (int) player.left.get(0) * 50;
  }
}

// kontinuierliche linie
void BrushTwo() {
  buf.stroke(0,0,0);
  buf.strokeWeight(5);     
  int pX = (pmouseX != mouseX) ? pmouseX : mouseX;
  int pY = (pmouseY != mouseY) ? pmouseY : mouseY;
  buf.line(mouseX + copyOffsetX, mouseY + copyOffsetY, pX + prevOffsetX, pY + prevOffsetY);
}

void brushThree() {

  deltaMouseX = mouseX + copyOffsetX;
  deltaMouseY = mouseY + copyOffsetY;
}
