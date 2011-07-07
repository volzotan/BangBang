 /*  Variablen zum Effektezeichnen
  * + mousePosX, mousePosY geben die Mausposition an
  * + boolean testOnCanvasX(int zuTestendeKoordinate) gibt an ob 
  *   eine Koordinate die vollgezeichnet werden soll sich auf der Zeichenflaeche befindet
  * + lastMousePosX[0-29] gibt vorherige absolute Mausposition aus
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
        
        //happyBlackRectangle(5000);
      } else {
        // 12.5 - 25% // 5.998 - 11.996
      }
    } else {
      // 25 - 50%
      if (pos < player.length() * 0.375) {
        // 25 - 37.5% // 11.997 - 17.994 
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
