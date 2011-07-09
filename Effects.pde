 /*  Variablen zum Effektezeichnen
  * + mousePosX, mousePosY geben die Mausposition an
  * + boolean testOnCanvasX(int zuTestendeKoordinate) gibt an ob 
  *   eine Koordinate die vollgezeichnet werden soll sich auf der Zeichenflaeche befindet
  * + lastMousePosX[0-29] gibt vorherige absolute Mausposition aus
  *
  *  bei einer Mindestframerate von 24 wird durchschnittliche alle 42ms ein draw gezeichnet
  *  bei jedem zweiten draw ein brush() bedeutet eine Ausführung alle 82ms. Zur Sicherheit
  *  das doppelte Intervall bei der Positionsüberprüfung berücksichtigen
  */
  
  
// Effect ranges
//
// 00,0 - 02,0 :: 1. Stimme
// 02,0 - 03,0 :: 2. Stimme
// 03,0 - 05,0 :: 1. Stimme
// 05,0 - 06,0 :: 2. Stimme
// 06,0 - 09,8 :: 1. Stimme
// 09,8 - 10,5 :: 2. Stimme

// 10,5 - 11,8 :: General Pause

// 11,8 - 24,0 :: Gesang
// 24,0 - 25,0 :: BangBang
// 25,0 - 25,2 :: Pause
// 25,2 - 27,0 :: Gesang
// 27,0 - 28,0 :: BangBang
// 28,0 - 28,2 :: Pause
// 28,2 - 30,2 :: Gesang
// 30,2 - 31,0 :: BangBang
// 31,0 - 33,0 :: Gesang
// 33,0 - 33,9 :: BangBang
// 33,9 - 39,0 :: Gesang
// 39,0 - 40,1 :: BangBang
// 40,1 - 40,6 :: Pause

// 40,6 - 43,3 :: Muster 1
// 43,3 - 47,5 :: Ende


void castEffect() {
  
  if (pos < player.length() * 0.5) {
    // 0 - 50%
    if (pos < player.length() * 0.25) {
      // 0 - 25%      
      if (pos < player.length() * 0.125) {
                                                                          // 0 - 12.5% // 0.001 - 5.997
        // 1. udn 2. part gegenstimme
        if((pos <  3050) && (pos > 1950) ||
           (pos <  6050) && (pos > 4950)) 
        {
           brushOne(true, false);            
        }
      } else {
                                                                          // 12.5 - 25% // 5.998 - 11.996
        // 3. part gegenstimme
        if(pos < 10550 && pos > 9750) {
          if(pos < 10041 && pos > 9959) {
            brushOne(true,true);
          }  
          brushOne(true, false);
        }
        // general pause  
        if((pos > 11850) && (pos > 10450)) {

        }
        // gesang
        if(pos > 11850) {
          //ps.addParticle(x+copyOffsetX,y+copyOffsetY);
        }        
      }
    } else {
      // 25 - 50%
      // gesang
      //ps.addParticle(x+copyOffsetX,y+copyOffsetY);       
      if (pos < player.length() * 0.375) {
                                                                         // 25 - 37.5% // 11.997 - 17.994 
        
        //initFlock(3);
      } else {
                                                                         // 37.5 - 50% // 17.995 - 23.992
      }
    }
  } else {
    // 50 - 100%
    if (pos < player.length() * 0.75) {
      // 50 - 75%
      if (pos < player.length() * 0.625) {
                                                                          // 50 - 62.5% // 23.993 - 29.990
        if(inkSplatter01Used == false) { inkSplatter01Used = tintenklecks(24300,  10.5, pos); }; // "bang" 1. Wort PASST                                                                
        if(inkSplatter02Used == false) { inkSplatter02Used = tintenklecks(24600,  11.0, pos); }; // "bang" 2. Wort PASST
        if(inkSplatter03Used == false) { inkSplatter03Used = tintenklecks(27059,   8.5, pos); }; // "bang" 1. Wort PASST
        if(inkSplatter04Used == false) { inkSplatter04Used = tintenklecks(27448,  12.0, pos); }; // "bang" 2. Wort PASST
    
      } else {
                                                                          // 62.5 - 75% // 29.991 - 35.989
        if(inkSplatter05Used == false) { inkSplatter05Used = tintenklecks(30100,   9.8, pos); }; // "bang" 1. Wort PASST
        if(inkSplatter06Used == false) { inkSplatter06Used = tintenklecks(30400,  10.5, pos); }; // "bang" 2. Wort PASST
        if(inkSplatter07Used == false) { inkSplatter07Used = tintenklecks(33000,   8.0, pos); }; // "bang" 1. Wort PASST
        if(inkSplatter08Used == false) { inkSplatter08Used = tintenklecks(33300,  10.5, pos); }; // "bang" 2. Wort PASST

      }
    } else {
      // 75 - 100%
      if (pos < player.length() * 0.875) {
                                                                          // 75 - 87.5% // 35.990 - 41.987
        if(inkSplatter09Used == false) { inkSplatter09Used = tintenklecks(38950,  10.5, pos); }; // "bang" 1. Wort PASST
        if(inkSplatter10Used == false) { inkSplatter10Used = tintenklecks(39250,  14.5, pos); }; // "bang" 2. Wort PASST
        if((pos > 40550)) {
          brushOne(true, false);
        }        
      } else {
                                                                          // 87.5 - 100% // 41.988 - 47.986
        if((pos < 43350)) {
          brushOne(true, false);
        } else {
          brushFour();  
        }       
      }
    }
  }
}


void happyBlackRectangle(int time) {
  if ((pos < time + 300) && (pos > time - 300)) {
    for (int i = 0; i<30; i++) {
      buf.rect(lastMousePosX[i], lastMousePosY[i], 10, 10);
    }
  }
} 

boolean tintenklecks(int time, float size, int pos) {
  if ((pos < time + 41) && (pos > time - 41)) {
    int r = floor(random(0,inkSplatter.length-0.5));
    
        
    float splatterSize = 25*size;  
    
    float xPos = copyOffsetX +  width/2 + random(-50,50) * random(-2,+2), 
	  yPos = copyOffsetY + height/2 + random(-50,50) * random(-2,+2);    

    // left side :: x position
    if(1 == inkSplatterPos || 2 == inkSplatterPos) {
	if(!(xPos >= copyOffsetX && xPos <= (copyOffsetX+width/2-splatterSize))) {
	  xPos = copyOffsetX + width/3 + random(-width/6,width/6);
	}	        
    }  

    // right side :: x position
    if(0 == inkSplatterPos || 3 == inkSplatterPos) {        
	if(!(xPos >= (copyOffsetX+width/2) && xPos <= (copyOffsetX+width-splatterSize))) {
          xPos = copyOffsetX + (width*2)/3 + random(-width/6,width/6);
	}
    } 
    
    // top side :: y position
    if(1 == inkSplatterPos || 0 == inkSplatterPos) {       
        if(!(yPos >= copyOffsetY && yPos <= (copyOffsetY+height/2-splatterSize))) {
	  yPos = copyOffsetY + height/4 + random(-height/8,height/8) - random(0,20);
          if(yPos < copyOffsetY) { yPos = copyOffsetY - random(-10,10); }
          if(yPos > (copyOffsetY+height/2)) { yPos = copyOffsetY + height/2 - random(10,40); }
        }       
    }  
    
    // bottom side :: y position
    if(2 == inkSplatterPos || 3 == inkSplatterPos) {              
        if(!(yPos >= (copyOffsetY+height/2) && yPos <= (copyOffsetY+height-splatterSize))) {
	  yPos = copyOffsetY + (height*3)/4 + random(-height/8,height/8) - random(0,50);
          if(yPos < (copyOffsetY+height/2)) { yPos = copyOffsetY + height/2 + random(10,splatterSize/3); }
          if(yPos > (copyOffsetY+height)) { yPos = copyOffsetY + height - random(splatterSize/2,splatterSize); }
        }      
    }
    
    println(xPos+"\t+\t"+yPos + "\t| InkSplatterPos:"+inkSplatterPos);
    buf.image(inkSplatter[r], xPos, yPos, splatterSize, splatterSize);
    inkSplatterPos++;
    if(inkSplatterPos > 3) { inkSplatterPos = 0; }
    
    return true;
  }  
  return false;
} 

void initFlock(int amount) {
  for (int j = 0; j < 10; j++) {
    for (int i = 0; i < amount; i++) {
      flock.addBoid(new Boid(new PVector(lastMousePosX[j*3], lastMousePosY[j*3]), 3.0, 0.05));
    }  
  }
}  
