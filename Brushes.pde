/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
void brushOne(boolean useOffset, boolean drawHuge) {
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
  
  float size1 = 0, size2 = 0, spacing = 1;
  if(drawHuge) {
    size1 = 300;
    size2 = 200;
    spacing = 40;
  }  
  
  angle += 10;
  float val = cos(radians(angle)) * 10.0;
  for (int a = 0; a < 360; a += 72) { // += als parameter für Pinselmuster
    float xoff = cos(radians(a)) * val * spacing;
    float yoff = sin(radians(a)) * val * spacing;    
    buf.ellipse(x + copyOffsetX + xoff, y + copyOffsetY + yoff + player.left.get(0) * 50+extraOffset, val + player.left.get(0) * 20 + size1, val + player.left.get(0) * 20 + size1);
  }
  buf.fill(0,0,0,255);
  buf.ellipse(x + copyOffsetX, y + copyOffsetY + player.left.get(0) * 50+extraOffset, 2 + size2 , 2 + size2);

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
  // 10,5 - 11,8 :: General Pause
  if(pos < 10500 || pos > 11800) {
    buf.stroke(cR1-tempBrushValue,cG1-tempBrushValue,cB1-tempBrushValue);
    buf.strokeWeight(5+tempBrushValue*0.13); 
  } else {
    buf.stroke(cR2,cG2,cB2);
    buf.strokeWeight(4); 
  }  
  /*
  float verhaeltnisSumme = x + copyOffsetX - directionArrayX[drawCounter%10] + y + copyOffsetY - directionArrayY[drawCounter%10];
  float verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
  float verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;
  */
  
  float verhaeltnisSumme = abs(x + copyOffsetX - directionArrayX[drawCounter%10]) + abs(y + copyOffsetY - directionArrayY[drawCounter%10]);
  float verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
  float verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;
  
//  println("verhaeltnisX =" + verhaeltnisX);
//  println("verhaeltnisY =" + verhaeltnisY);
  
  int oldX = (int) (x + copyOffsetX + verhaeltnisY * (player.left.get(0) * 100));
  int oldY = (int) (y + copyOffsetY + verhaeltnisX * (player.left.get(0) * 100));
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

void brushFour() {
   int amount = floor(random(4,15.5));
   if(random(1) < 0.5) { amount *= -1; }
      
   float extraOffsetX = 0, extraOffsetY = 0;   
   
   for(int i = 0; i < amount; i++) {   
     int size = floor(random(2,4));
     
     if(random(1) < 0.5) {
       extraOffsetX = -6+48*player.left.get(0)+8*random(-10,10);
     } else {
       extraOffsetX = 15+30*player.right.get(0)+3*random(-10,10);
     }   
   
     if(random(1) < 0.5) {
       extraOffsetY = -24+48*player.left.get(0)+10*random(-10,10);
     } else {
       extraOffsetY = 9+30*player.right.get(0)+5*random(-10,10);
     }
     
     buf.fill(cR2-tempBrushValue - size - extraOffsetY - amount, cG2-tempBrushValue - size - extraOffsetY - amount, cB2-tempBrushValue - size - extraOffsetY - amount);
        
     buf.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + extraOffsetY,size,size);   
   }
   
}
