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
  int pos = player.position();
  
  if (pos < player.length() * 0.5) {
    // 0 - 50%
    if (pos < player.length() * 0.25) {
      // 0 - 25%      
      if (pos < player.length() * 0.125) {
        // 0 - 12.5% // 0.001 - 5.997
        if((player.position() <  3050) && (player.position() > 1950) ||
           (player.position() <  6050) && (player.position() > 4950)) 
        {
           brushOne(true); 
        }
        tintenklecks(2300, 8);
        tintenklecks(5200, 6.5);
      } else {
        // 12.5 - 25% // 5.998 - 11.996
        if((player.position() < 10550) && (player.position() > 9750)) {
          brushOne(true);
        }  
        ps.addParticle(x+copyOffsetX,y+copyOffsetY);
      }
    } else {
      // 25 - 50%
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
      } else {
        // 62.5 - 75% // 29.991 - 35.989
      }
    } else {
      // 75 - 100%
      if (pos < player.length() * 0.875) {
        // 75 - 87.5% // 35.990 - 41.987
      } else {
        // 87.5 - 100% // 41.988 - 47.986
      }
    }
  }
}


void happyBlackRectangle(int time) {
  if ((player.position() < time + 300) && (player.position() > time - 300)) {
    for (int i = 0; i<30; i++) {
      buf.rect(lastMousePosX[i], lastMousePosY[i], 10, 10);
    }
  }
} 

void tintenklecks(int time, float size) {
  if ((player.position() < time + 165) && (player.position() > time - 165)) {
    buf.shape(klecks, copyOffsetX + 50 + 100 * random(-1,+1), copyOffsetY + 70 * random(-1,+1), 112 * size, 100 * size);
  }
} 

void initFlock(int amount) {
  for (int j = 0; j < 10; j++) {
    for (int i = 0; i < amount; i++) {
      flock.addBoid(new Boid(new PVector(lastMousePosX[j*3], lastMousePosY[j*3]), 3.0, 0.05));
    }  
  }
}  
