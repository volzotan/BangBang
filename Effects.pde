 /*  Variablen zum Effektezeichnen
  * + mousePosX, mousePosY geben die Mausposition an
  * + boolean testOnCanvasX(int zuTestendeKoordinate) gibt an ob 
  *   eine Koordinate die vollgezeichnet werden soll sich auf der Zeichenflaeche befindet
  * + lastMousePosX[0-29] gibt vorherige absolute Mausposition aus
  *
  */  
// EFFECT RANGES
//
// Große Blume     @ 10.200 sec
// Mittlere Blume  @ 25.350 sec
// Mittlere Blume  @ 28.200 sec
// Mittlere Blume  @ 31.050 sec
// Mittlere Blume  @ 39.850 sec
// Mittlere Blume  @ 42.120 sec
// Kleine Blumen   @ 10.150 sec - 10.450 sec
//
// Kleine Blumen   @  2.340 sec -  2.930 sec
// Kleine Blumen   @  5.200 sec -  5.800 sec
// Kleine Blumen   @  8.100 sec -  8.680 sec
// Kleine Blumen   @ 36.860 sec - 37.400 sec

int[][] splatterEventArray  = new int[10][2];       // 0 = delay, 1 = size
int[][] brushFourEventArray = new int[ 1][3];       // 0 = delay, 1 = continuousFlag      , 2 = Repeat Intervall[ms]
int[][] brushOneEventArray  = new int[11][3];       // 0 = delay, 1 = huge/continuous Flag, 3 = Repeat Intervall[ms]
int[][] invertEventArray    = new int[ 2][1];       // 0 = delay

final int MAXAMOUNT =  4; 
final int MINAMOUNT = 50;

void initEventArrays() {
  
  splatterEventArray[0][0] =  24240;    splatterEventArray[0][1] = 3;
  splatterEventArray[1][0] =  24628;    splatterEventArray[1][1] = 1;
  splatterEventArray[2][0] =  27000;    splatterEventArray[2][1] = 4;
  splatterEventArray[3][0] =  27450;    splatterEventArray[3][1] = 3;
  splatterEventArray[4][0] =  29890;    splatterEventArray[4][1] = 2;
  splatterEventArray[5][0] =  30280;    splatterEventArray[5][1] = 4;
  splatterEventArray[6][0] =  32770;    splatterEventArray[6][1] = 2;
  splatterEventArray[7][0] =  33200;    splatterEventArray[7][1] = 3;
  splatterEventArray[8][0] =  38690;    splatterEventArray[8][1] = 4;
  splatterEventArray[9][0] =  39050;    splatterEventArray[9][1] = 5;
  
  invertEventArray[1][0] =  39850;
  invertEventArray[0][0] =  42120;
 
  brushOneEventArray[0][0] =  2340;    brushOneEventArray[0][1] = 0;    brushOneEventArray[0][2] = 590;
  brushOneEventArray[1][0] =  5200;    brushOneEventArray[1][1] = 0;    brushOneEventArray[1][2] = 600;
  brushOneEventArray[2][0] =  8100;    brushOneEventArray[2][1] = 0;    brushOneEventArray[2][2] = 570;
  brushOneEventArray[3][0] = 10150;    brushOneEventArray[3][1] = 0;    brushOneEventArray[3][2] = 300;
  brushOneEventArray[4][0] = 36860;    brushOneEventArray[4][1] = 0;    brushOneEventArray[4][2] = 540;
  
  brushOneEventArray[5][0] = 25350;    brushOneEventArray[5][1] = 1;    brushOneEventArray[5][2] = 0;
  brushOneEventArray[6][0] = 28200;    brushOneEventArray[6][1] = 1;    brushOneEventArray[6][2] = 0;
  brushOneEventArray[7][0] = 31050;    brushOneEventArray[7][1] = 1;    brushOneEventArray[7][2] = 0;
  brushOneEventArray[8][0] = 39850;    brushOneEventArray[8][1] = 1;    brushOneEventArray[8][2] = 0;
  brushOneEventArray[9][0] = 42120;    brushOneEventArray[9][1] = 1;    brushOneEventArray[9][2] = 0;
  
  brushOneEventArray[10][0] = 10200;   brushOneEventArray[10][1] = 2;   brushOneEventArray[10][2] = 0;
  
  brushFourEventArray[0][0] = 43300;   brushFourEventArray[0][1] = 1;   brushFourEventArray[0][2] = 100;
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
  scheduleBrushOneEvents();
  scheduleBrushFourEvents();
  scheduleInvertEvent();
  
  scheduleGhostBrush();
}

void scheduleInvertEvent() {
  for (int i=0; i < invertEventArray.length; i++) {
    if (invertEventArray[i][0] - elapsedTime >= 0) { 
      timer.schedule(new TimerTask() {
        public void run() {
          doInvert = !doInvert;
        }
      }, invertEventArray[i][0] - elapsedTime);
    }
  }  
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
                tintenklecks(8);
              }
            }, delay);
          break;
        case 2: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(9);
              }
            }, delay);        
          break;
        case 3: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(10);
              }
            }, delay);        
          break;
        case 4: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(12);
              }
            }, delay);        
          break;
        case 5: 
            timer.schedule(new TimerTask() {
              public void run() {
                tintenklecks(14);
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

void scheduleBrushOneEvents() {
  for (int i=0; i < brushOneEventArray.length; i++) {
    if (brushOneEventArray[i][0] - elapsedTime >= 0) {      
      if (brushOneEventArray[i][1] == 1) {       // medium flower
        timer.schedule(new TimerTask() {
          public void run() {
            brushOne(true, 1);
          }
        }, brushOneEventArray[i][0] - elapsedTime);
      } else if (brushOneEventArray[i][1] == 2) { // large flower
        timer.schedule(new TimerTask() {
          public void run() {
            brushOne(true, 2);
          }
        }, brushOneEventArray[i][0] - elapsedTime);
      }/* else {                                   // regular/small flower
        // TODO STOP AFTER SET INTERVAL
        timer.schedule(new TimerTask() {
          public void run() {
            brushOne(true, 0);
          }
        }, brushOneEventArray[i][0] - elapsedTime, brushOneEventArray[i][2]);
      }*/
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
            //brushFour(MINAMOUNT, MAXAMOUNT);
            crescendo();
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

void crescendo() {
  if (firstRun) {
    oldDeltaX = oldX;
    oldDeltaY = oldY;
              
    mainBrushActive = false;
    firstRun = false;
  }
            
  if(pos < 10500 || pos > 11800) {
              buf.stroke(cR1-tempBrushValue,cG1-tempBrushValue,cB1-tempBrushValue);
              buf.strokeWeight(5+tempBrushValue*0.13); 
  } else {
              buf.stroke(cR2,cG2,cB2);
              buf.strokeWeight(4); 
  }  
            
  tempX = (int) (deltaMouseX + xPlus + random(-1,1) * 8);
  tempY = (int) (deltaMouseY + random(-1,1) * 15 + invsVar * (-1) * abs(amp));
            
  buf.line(oldDeltaX, oldDeltaY, tempX, tempY);
        
  oldDeltaX = tempX;
  oldDeltaY = tempY;
            
  amp = amp - 5;
  xPlus = xPlus + 6;
  invsVar = invsVar * (-1);
}
