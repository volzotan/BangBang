 /*  Variablen zum Effektezeichnen
  * + mousePosX, mousePosY geben die Mausposition an
  * + boolean testOnCanvasX(int zuTestendeKoordinate) gibt an ob 
  *   eine Koordinate die vollgezeichnet werden soll sich auf der Zeichenflaeche befindet
  * + lastMousePosX[0-29] gibt vorherige absolute Mausposition aus
  *
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


int[][] splatterEventArray = new int[7][2];        // 0 = delay, 1 = size
int[][] brushFourEventArray = new int[2][3];       // 0 = delay, 1 = continuousFlag, 2 = Intervall[ms]

final int MAXAMOUNT =  4; 
final int MINAMOUNT = 50;


void initEventArrays() {
  
  splatterEventArray[0][0] =  1000;     splatterEventArray[0][1] = 1;
  splatterEventArray[1][0] =  2000;     splatterEventArray[1][1] = 2;
  splatterEventArray[2][0] =  3000;     splatterEventArray[2][1] = 3;
  splatterEventArray[3][0] =  4500;     splatterEventArray[3][1] = 4;
  splatterEventArray[4][0] =  9000;     splatterEventArray[4][1] = 5;
  splatterEventArray[5][0] = 11000;     splatterEventArray[5][1] = 1;
  splatterEventArray[6][0] = 14000;     splatterEventArray[6][1] = 2;
  
  brushFourEventArray[0][0] =  2500;    brushFourEventArray[0][1] = 0;
  brushFourEventArray[1][0] = 15000;    brushFourEventArray[1][1] = 1;    brushFourEventArray[1][2] = 80;
  
}

void savePauseTime() {
  elapsedTime = player.position();
}

void killAllScheduledEvents() {
  timer.cancel();                      // .purge() problematisch
}

void pauseAllScheduledEvents() {
  savePauseTime();
  killAllScheduledEvents();
  timer = new Timer();
}

void startAllScheduledEvents() {
  scheduleSplatterEvents();
  scheduleBrushFourEvents();
  
  scheduleGhostBrush();
}

void scheduleGhostBrush() {
   timer.schedule(new TimerTask() {
      public void run() {
        drawGhostBrush();
      }
    }, 12500);              // GhostBrush Start time
}

void scheduleSingleSplatterEvent(int delay, int size) {
      switch(size) {
        case 1: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(7);
              }
            }, delay);
          break;
        case 2: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(8);
              }
            }, delay);        
          break;
        case 3: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(9);
              }
            }, delay);        
          break;
        case 4: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(11);
              }
            }, delay);        
          break;
        case 5: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(15);
              }
            }, delay);        
          break;
      }
}

void scheduleSplatterEvents() {
  for (int i=0; i < splatterEventArray.length; i++) {
    if (splatterEventArray[i][0] - elapsedTime >= 0) {      
      scheduleSingleSplatterEvent(splatterEventArray[i][0] - elapsedTime, splatterEventArray[i][1]);
    }
  }
}

void scheduleBrushFourEvents() {
  for (int i=0; i < brushFourEventArray.length; i++) {
    if (brushFourEventArray[i][0] - elapsedTime >= 0) {      
      if (brushFourEventArray[i][1] == 0) {
        timer.schedule(new TimerTask() {
          public void run() {
            brushFour(MINAMOUNT, MAXAMOUNT);
          }
        }, brushFourEventArray[i][0] - elapsedTime);
      } else {
        timer.schedule(new TimerTask() {
          public void run() {
            brushFour(MINAMOUNT, MAXAMOUNT);
          }
        }, brushFourEventArray[i][0] - elapsedTime, brushFourEventArray[i][2]);
      }
    }
  }
}


void tintenklecks(float size) {
  
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
	  yPos = copyOffsetY + height/4 + random(-height/8,height/8) - random(0,10);
          if(yPos < copyOffsetY) { yPos = copyOffsetY - random(0,10); }
          if(yPos > (copyOffsetY+height/2)) { yPos = copyOffsetY + height/2 - random(10,20); }
        }       
    }  
    
    // bottom side :: y position
    if(2 == inkSplatterPos || 3 == inkSplatterPos) {              
        if(!(yPos >= (copyOffsetY+height/2) && yPos <= (copyOffsetY+height-splatterSize))) {
	  yPos = copyOffsetY + (height*3)/4 + random(-height/8,height/8) - random(20,100);
          if(yPos < (copyOffsetY+height/2)) { yPos = copyOffsetY + height/2 + random(30,splatterSize/3); }
          if(yPos > (copyOffsetY+height)) { yPos = copyOffsetY + height - random((splatterSize*3/4),splatterSize); }
        }      
    }
    
    //println(xPos+"\t+\t"+yPos + "\t| InkSplatterPos:"+inkSplatterPos);
    buf.image(inkSplatter[r], xPos, yPos, splatterSize, splatterSize);
    inkSplatterPos++;
    if(inkSplatterPos > 3) { inkSplatterPos = 0; }

} 
