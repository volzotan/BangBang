/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
void brushOne(boolean useOffset, boolean drawHuge) {
  float extraOffsetY = 0;  float extraOffsetX = 0;
  if(useOffset) {
     extraOffsetY = (random(1) < 0.5) ? -74+60*player.left.get(0)*random(-1,1) : 87+70*player.right.get(0)*random(-1,1);
     extraOffsetX = (random(1) < 0.5) ? -37+60*player.left.get(0)*random(-1,1) : 52+70*player.right.get(0)*random(-1,1);
  }  
  
  float val = cos(radians(angle)) * 10.0 + 4;
  float size1 = 9, size2 = random(8,20), spacing = 1;
  int alpha1 = 150, alpha2 = 255;
  if(drawHuge) {
    size1 = 250;
    size2 = 325;
    spacing = 35;
    alpha1 = 50;
    alpha2 = 60;
    println(val);    
  } else {
    val += random(0,1)*20;
  }  
  
  buf.noStroke();
  buf.fill(0,0,0,alpha1);

  angle += 10;
  for (int a = 0; a < 360; a += 72) { // += als parameter für Pinselmuster
    float xoff = cos(radians(a)) * val * spacing;
    float yoff = sin(radians(a)) * val * spacing;    
    buf.ellipse(x + copyOffsetX + xoff + extraOffsetX, y + copyOffsetY + yoff + player.left.get(0) * 50 + extraOffsetY, val + player.left.get(0) * 20 + size1, val + player.left.get(0) * 20 + size1);
  }
  buf.fill(0,0,0,alpha2);
  buf.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + player.left.get(0) * 50 + extraOffsetY, 2 + size2 , 2 + size2);

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
  
  
  int oldX = (int) (x + copyOffsetX + verhaeltnisY * (player.left.get(0) * 100));
  int oldY = (int) (y + copyOffsetY + verhaeltnisX * (player.left.get(0) * 100));
  buf.line(oldX, oldY, deltaMouseX, deltaMouseY);

/*  
  if (drawCounter % 10 == 0) {
  buf.stroke(1);
  buf.strokeWeight(1);
  buf.stroke(254,0,0);
  buf.line(directionArrayX[drawCounter%10], directionArrayY[drawCounter%10], x + copyOffsetX, y + copyOffsetY);          // Rote Linie stellt Richtungsvektor dar
  }
 */
  
  deltaMouseX = oldX;
  deltaMouseY = oldY;
}

void brushFour(int minAmount, int maxAmount) {
   int amount = floor(random(minAmount,maxAmount));
   if(random(1) < 0.5) { amount *= -1; }
      
   float extraOffsetX = 0, extraOffsetY = 0;   
   
   for(int i = 0; i < amount; i++) {   
     int size = floor(random(2,4));
     
     if(random(1) < 0.5) {
       extraOffsetX = -6+48*player.left.get(0)+8*random(-10,50);
     } else {
       extraOffsetX = 15+30*player.right.get(0)+3*random(-10,50);
     }   
   
     if(random(1) < 0.5) {
       extraOffsetY = -44+48*player.left.get(0)+10*random(-50,0);
     } else {
       extraOffsetY = 47+30*player.right.get(0)+5*random(0,50);
     }
     
     if(random(0,1) < 0.6) {
       buf.fill(cR2 - tempBrushValue - size + extraOffsetY - amount, cG2 - tempBrushValue - size + extraOffsetY - amount, cB2 - tempBrushValue - size + extraOffsetY - amount);
       buf.stroke(cR2 - tempBrushValue - size + extraOffsetY - amount, cG2 - tempBrushValue - size + extraOffsetY - amount, cB2 - tempBrushValue - size + extraOffsetY - amount);
     } else {
        float rand = random(0,1);
        if(rand < 0.3) {
          buf.fill(80,22,28); // red
          buf.stroke(80,22,28); // red          
        } else if(rand > 0.6) {
          buf.fill(13,36,98); // blue
          buf.stroke(13,36,98); // blue          
        } else {
          buf.fill(22,90,59); // green
          buf.stroke(22,90,59); // green          
        }  
     }  
        
     buf.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + extraOffsetY,size,size);   
   }
   
}
