/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */

void brushOne(boolean useOffset, int drawSize) {
  float extraOffsetY = 0;  float extraOffsetX = 0;
  if(useOffset) {
    switch(drawSize) {
       case 1 : 
         extraOffsetY = (random(1) < 0.5) ? -74+60*random(-1,1) : 87+70*random(-1,1);
         extraOffsetX = (random(1) < 0.5) ? -37+60*random(-1,1) : 52+70*random(-1,1);       
         break;
       case 2 : 
         extraOffsetY = random(-50,50);     
         break;         
       default:
         extraOffsetY = (random(1) < 0.5) ? -74+60*player.left.get(1)*random(-1,1) : 87+70*player.right.get(1)*random(-1,1);
         extraOffsetX = (random(1) < 0.5) ? -37+60*player.left.get(1)*random(-1,1) : 52+70*player.right.get(1)*random(-1,1);       
     }  
  }  
  
  float val = cos(radians(angle)) * 10.0 + 4;
  float size1 = 9, size2 = random(8,20), spacing = 1.1;
  int alpha2 = 255;
  if(2 == drawSize) { // large
    size1 = 275;
    size2 = 230;
    spacing = 32;
    alpha2 = 60;
    val = (val > 9.5 || val < 5) ? random(6,9) : val;
    buf.fill(80,22,28,160);
  } else if (1 == drawSize) { // medium
    size1 = 95;
    size2 = 85;
    spacing = 13;
    alpha2 = 60;
    val = (val > 8 || val < 5) ? random(5,7.5) : val;
    buf.fill(13,36,98,100); // blue
  } else {          // small
    val = random(10,22);
    buf.fill(0,0,0,150);
  }  
  
  angle += 10;
  for (int a = 0; a < 360; a += 72) { // += als parameter für Pinselmuster
    float xoff = cos(radians(a)) * val * spacing;
    float yoff = sin(radians(a)) * val * spacing;    
    buf.noStroke();
    buf.ellipse(x + copyOffsetX + xoff + extraOffsetX, y + copyOffsetY + yoff + player.left.get(0) * 50 + extraOffsetY, val + player.left.get(0) * 20 + size1, val + player.left.get(0) * 20 + size1);
  }
  buf.fill(0,0,0,alpha2);
  buf.noStroke();
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
  if(!useNyancat) {
    if(pos < 10500 || pos > 11800) {
      buf.stroke(cR1-tempBrushValue,cG1-tempBrushValue,cB1-tempBrushValue);
      buf.strokeWeight(5+tempBrushValue*0.13);
    } else {
      buf.stroke(cR2, cG2, cB2);
      buf.strokeWeight(4);
    }
  } else {  
    if(tempNyanPos+250 < pos) {
      switch(tempNyanCol) {
        case 0 : nyanColor = nyan0; tempNyanCol++; break;
        case 1 : nyanColor = nyan1; tempNyanCol++; break;
        case 2 : nyanColor = nyan2; tempNyanCol++; break;
        case 3 : nyanColor = nyan3; tempNyanCol++; break;
        case 4 : nyanColor = nyan4; tempNyanCol++; break;
        case 5 : nyanColor = nyan5; tempNyanCol = 0; break;
      }        
      tempNyanPos = pos;
      }
      buf.stroke(nyanColor);  
      buf.strokeWeight(5+tempBrushValue*0.13);
  }
  
  /*
  float verhaeltnisSumme = x + copyOffsetX - directionArrayX[drawCounter%10] + y + copyOffsetY - directionArrayY[drawCounter%10];
  float verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
  float verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;
  */
  
  float verhaeltnisSumme = abs(x + copyOffsetX - directionArrayX[drawCounter%10]) + abs(y + copyOffsetY - directionArrayY[drawCounter%10]);
  float verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
  float verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;  
  
  oldX = (int) (x + copyOffsetX + verhaeltnisY * (player.left.get(0) * brushThreeSkalierungAusschlag));
  oldY = (int) (y + copyOffsetY + verhaeltnisX * (player.left.get(0) * 100));
  buf.line(oldX, oldY, deltaMouseX, deltaMouseY);
  buf.noStroke();

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


void ghostBrush() {
  //buf.line(oldX, oldY, deltaMouseX - 100, deltaMouseY + 50);
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


