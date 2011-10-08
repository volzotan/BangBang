// COLORS (in rgb)
// blue/green:     5, 136, 138
// white/yellow: 240, 236, 202
// light orange: 227, 168,  47
// dark orange:  213,  77,  27  
// brown:         81,  61,  46

/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
public /*synchronized*/ void brushOne(boolean useOffset, int drawSize) {
  float extraOffsetY = 0;  float extraOffsetX = 0;
  int rand = 0, rand2 = 0;  
  // depending on the draw Size (2 = large, 1 = medium, 0 = small
  // a random offset in Y (and X) direction is calculated
  if(useOffset) {
    switch(drawSize) {
      case 1 : 
        extraOffsetY = (random(1) < 0.5) ? -74+60*random(-1,1)+30*random(-1,1) : 47+70*random(-1,1)+30*random(-1,1);
        extraOffsetX = (random(1) < 0.5) ? -37+60*random(-1,1) : 52+70*random(-1,1);      
        break;
      case 2 : 
        extraOffsetY = random(-40,40);    
        break;        
      default:
        extraOffsetY = (random(1) < 0.5) ? -64+40*player.left.get(1)*random(-1,1)+30*random(-1,1) : 87+60*player.right.get(1)*random(-1,1)+30*random(-1,1);
        extraOffsetX = (random(1) < 0.5) ? -37+60*player.left.get(1)*random(-1,1) : 52+70*player.right.get(1)*random(-1,1);      
    }  
  }  
  
  float val = cos(radians(angle)) * 10.0 + 4;
  angle = (angle > 360) ? 0 : angle + 10;
  float size1 = 9, size2 = random(8,20), spacing = 1.1;
  int alpha2 = 255;
  int r = 81, g = 61, b = 46, o = 150; // brown
  if(2 == drawSize) { // large
    size1 = 275;
    size2 = 230;
    spacing = 32;
    alpha2 = 60;
    val = (val > 9.5 || val < 5) ? random(6,9) : val;
    r = 240; g = 236; b = 202; o = 160; // white/yellow 
  } else if (1 == drawSize) { // medium
    size1 = 95;
    size2 = 85;
    spacing = 13;
    alpha2 = 60;
    val = (val > 8 || val < 5) ? random(5,7.5) : val;
    r = 213; g = 77; b = 27; o = 100; // dark orange
    rand = 1;
  } else {          // small
    val = random(10,22);
    rand = (int) floor(random(2.0,4.1));
    rand2 = (int) floor(random(0,2.1)) + 2;
   
    if(rand2 == rand) { rand2--; } 
  }  
  
  bg.beginDraw();
//    bg.noStroke();
//    bg.fill(r,g,b);
  for (int a = 0; a < 360; a += 72) { // += als parameter für Pinselmuster
    float offX = cos(radians(a)) * val * spacing;
    float offY = sin(radians(a)) * val * spacing;          
//    bg.ellipse(x + copyOffsetX + offX + extraOffsetX, y + copyOffsetY + offY + player.left.get(0) * 50 + extraOffsetY, val + player.left.get(0) * 20 + size1, val + player.left.get(0) * 20 + size1);
      bg.image(flowerLarge, x + copyOffsetX + offX + extraOffsetX, y + copyOffsetY + offY + player.left.get(0) * 50 + extraOffsetY, val + player.left.get(0) * 20 + size1, val + player.left.get(0) * 20 + size1);     
  }
    if(0 == drawSize) {
//      bg.fill(0,0,0,alpha2);    
//      bg.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + player.left.get(0) * 50 + extraOffsetY, 2 + size2 , 2 + size2);
      bg.image(flowerSmall, x + copyOffsetX + extraOffsetX,  y + copyOffsetY + player.left.get(0) * 50 + extraOffsetY, 2 + size2, 2 + size2);  
    }
  bg.endDraw();  

  // Grab mouse position for use in effects and brushes
  // TODO WHAT DOES THIS DO HERE? IT IS CALLED IN DRAW() WITHOUT THE + X in Y coordinate
//  if(drawCounter % 1 == 0) {                              
//    lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
//    lastMousePosY[drawCounter%30] = (int) y + copyOffsetY + (int) (player.left.get(0) * 50);
//  }
}

// continuous line
/*synchronized*/ void mainBrush() {
  color c = color(145,145,145);
  int w = 5;
  // 10,5 - 11,8 :: General Pause  
  if(!useNyancat) {
    if(pos < 10500 || pos > 11800) {
      c = color(100-tempBrushValue,100-tempBrushValue,100-tempBrushValue);
      w += tempBrushValue*0.13;
    } else {
      w -= 1;
    }
  } else {  
    if(tempNyanPos+250 < pos) {
      switch(tempNyanCol) {
        case 0 : nyanColor = color(255,  42,  12); tempNyanCol++; break; // Red
        case 1 : nyanColor = color(255, 164,   9); tempNyanCol++; break; // Orange
        case 2 : nyanColor = color(255, 246,   0); tempNyanCol++; break; // Yellow
        case 3 : nyanColor = color( 50, 233,   3); tempNyanCol++; break; // Green
        case 4 : nyanColor = color(  2, 162, 255); tempNyanCol++; break; // Blue
        case 5 : nyanColor = color(119,  85, 255); tempNyanCol=0; break; // Purple
      }        
      tempNyanPos = pos;
    }
    c = nyanColor;
    w += tempBrushValue*0.13;
  }
  
  verhaeltnisSumme = abs(x + copyOffsetX - directionArrayX[drawCounter%10]) + abs(y + copyOffsetY - directionArrayY[drawCounter%10]);
  verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
  verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;  
  
  oldX = (int) (x + copyOffsetX + verhaeltnisY * (player.left.get(0) * mainBrushDeflectionScale));
  oldY = (int) (y + copyOffsetY + verhaeltnisX * (player.left.get(0) * 100));
  
  bg.beginDraw();
    bg.stroke(c);
    bg.strokeWeight(w);
    bg.line(oldX-25, oldY, deltaMouseX-25, deltaMouseY);
  bg.endDraw();
  
  deltaMouseX = oldX;
  deltaMouseY = oldY;
}

void startGhostBrush() {
  ghostOldX = (int) directionArrayX[drawCounter%10] - deltaWidth;
  ghostOldY = (int) directionArrayY[drawCounter%10] ;
  ghostBrush = true;
}

void ghostBrush() {
  bg.beginDraw();
  
    color c = color(145,145,145);
    switch(tempNyanCol) {
        case 0 : nyanColor = color(255,  42,  12); tempNyanCol++; break; // Red
        case 1 : nyanColor = color(255, 164,   9); tempNyanCol++; break; // Orange
        case 2 : nyanColor = color(255, 246,   0); tempNyanCol++; break; // Yellow
        case 3 : nyanColor = color( 50, 233,   3); tempNyanCol++; break; // Green
        case 4 : nyanColor = color(  2, 162, 255); tempNyanCol++; break; // Blue
        case 5 : nyanColor = color(119,  85, 255); tempNyanCol=0; break; // Purple
      }        
      tempNyanPos = pos;
  
      c = nyanColor;
    
    bg.stroke(c);
    bg.strokeWeight(5);
    /*
    newGhostPosX = x + copyOffsetX - deltaWidth;
    newGhostPosY = y + copyOffsetY - deltaHeight + sin(theta) * amplitude;
    */
    newGhostPosX = directionArrayX[drawCounter%10] - deltaWidth;
    newGhostPosY = directionArrayY[drawCounter%10] - deltaHeight + sin(theta) * amplitude;
    
    bg.line(ghostOldX, ghostOldY,  newGhostPosX, newGhostPosY);
  bg.endDraw();

  ghostOldX = (int) ( newGhostPosX );
  ghostOldY = (int) ( newGhostPosY );
  
  deltaHeight = (int) ( (y - 225) );
  deltaWidth = (int) ( (x - 400) );
  theta += 0.2;
  
}

// random circles and dots
void brushFour(int minAmount, int maxAmount) {
  int amount = floor(random(minAmount,maxAmount));
  if(random(1) < 0.5) { amount *= -1; }
  color c = color(0,0,0);
      
  float extraOffsetX = 0, extraOffsetY = 0;  
  
  for(int i = 0; i < amount; i++) {  
    int size = floor(random(2,4));
    
    extraOffsetX = (random(1) < 0.5) ? - 6+48*player.left.get(0)+ 8*random(-10,50) : 15+30*player.right.get(0)+3*random(-10,50);
    extraOffsetY = (random(1) < 0.5) ? -44+48*player.left.get(0)+10*random(-50, 0) : 47+30*player.right.get(0)+5*random(  0,50);
    
    if(random(0,1) < 0.6) {
      c = color(81, 61, 46);
    } else {
      float rand = random(0,1);      
      if(rand < 0.3) {
        c = color(5,136,138);
      } else if(rand > 0.6) {
        c = color(240,236,202);
      } else {
        c = color(213,77,27);
      }  
    }  
    
    bg.beginDraw();
      bg.fill(c);
      bg.stroke(c);
      bg.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + extraOffsetY,size,size);  
    bg.endDraw();
  }  
}

// splatters around main brush
void brushFive() {
  int amount = floor(random(0, 8));

  for(int i = 0; i < amount; i++) {
    int splatterRadius = floor(random(2,4));
    
    float colorPicker = random(0,1);
    color c = color(5,136,138);
    if(colorPicker <= 0.2) {
      c = color(240,236,202);
    } else if(0.2 < colorPicker && colorPicker <= 0.4) {
      c = color(227,168,47);    
    } else if(0.4 < colorPicker && colorPicker <= 0.6) {
      c = color(213,77,27);   
    } else if(0.6 < colorPicker && colorPicker <= 0.8) {
      c = color(81,61,46);   
    }
    
    bg.beginDraw();
    if(random(0,1) < 0.5) {
      bg.noStroke();      
      bg.fill(c);      
    } else {
      bg.noFill();
      bg.stroke(c);     
    }   
      bg.ellipse(x + copyOffsetX + random(-20,20), y + copyOffsetY + random(-90,90), splatterRadius, splatterRadius);  
    bg.endDraw();    
    
  }  
  
}  
