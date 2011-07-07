/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
void brushOne(boolean useOffset) {
  buf.noStroke();
  buf.fill(0,0,0,150);
  float extraOffset = 0;
  if(useOffset) {
     if(random(1) < 0.5) {
        extraOffset = -37+48*player.left.get(0);
     } else {
        extraOffset = 52+30*player.right.get(0);
     }  
  }  
  angle += 10;
  float val = cos(radians(angle)) * 10.0;
  for (int a = 0; a < 360; a += 72) { // += als parameter für Pinselmuster
    float xoff = cos(radians(a)) * val;
    float yoff = sin(radians(a)) * val;    
    buf.ellipse(x + copyOffsetX + xoff, y + copyOffsetY + yoff + player.left.get(0) * 50+extraOffset, val + player.left.get(0) * 20, val + player.left.get(0) * 20);
  }
  buf.fill(0,0,0,255);
  buf.ellipse(x + copyOffsetX, y + copyOffsetY + player.left.get(0) * 50+extraOffset, 2 , 2);

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
  buf.stroke(100-tempBrushValue,100-tempBrushValue,100-tempBrushValue);
  buf.strokeWeight(5+tempBrushValue*0.13); 
  
  float verhaeltnisSumme = x + copyOffsetX - directionArrayX[drawCounter%10] + y + copyOffsetY - directionArrayY[drawCounter%10];
  float verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
  float verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;
  
  int oldX = (int) (x + copyOffsetX + verhaeltnisY * (player.left.get(0) * 50));
  int oldY = (int) (y + copyOffsetY + verhaeltnisX * (player.left.get(0) * 50));
  buf.line(oldX, oldY, deltaMouseX, deltaMouseY);
  
  if (drawCounter % 10 == 0) {
  buf.stroke(1);
  buf.strokeWeight(1);
  buf.stroke(254,0,0);
  buf.line(directionArrayX[drawCounter%10], directionArrayY[drawCounter%10], x + copyOffsetX, y + copyOffsetY);
  }
  /*
  if (drawCounter % 10 == 0) {
    buf.strokeWeight(1); 
    buf.line(directionArrayX[drawCounter%10], directionArrayY[drawCounter%10], x + copyOffsetX, test);
  }
 */
  
  deltaMouseX = oldX;
  deltaMouseY = oldY;
}
