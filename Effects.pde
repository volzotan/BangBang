void AbstractJs() {
    int partNum,i;
    float dir;
    
    if(px==-1) {
      px=mouseX;
      py=mouseY;
      dir=0;
    }
    else if(px==mouseX && py==mouseY) dir=int(random(36))*10;
    else dir=degrees(atan2(mouseY-py,mouseX-px))-90;
  
    i=0;
    while(i<num) {
      if(particles[i].age<1) {
        particles[i].init(dir);
        break;
      }
      i++;
    }
    
    px=mouseX;
    py=mouseY;
    
    
}

 /*  Variablen zum Effektezeichnen
  * + mousePosX, mousePosY geben die Mausposition an
  * + boolean testOnCanvasX(int zuTestendeKoordinate) gibt an ob 
  *   eine Koordinate die vollgezeichnet werden soll sich auf der Zeichenflaeche befindet
  * + lastMousePosX[0-29] gibt vorherige absolute Mausposition aus
  */
  
  
//kommentier mal wer die entsprechenden Sekunden von unserer Aufstellung hier rein!
void castEffect() {
  int pos = player.position();
  
  // Abstract JS
  for(int i=0; i<num; i++) 
    if(particles[i].age>0) particles[i].update();    
  // EO Abstract JS
  
  if (pos < player.length() * 0.5) {
    // 0 - 50%
    if (pos < player.length() * 0.25) {
      // 0 - 25%
      if (pos < player.length() * 0.125) {
        // 0 - 12.5%
        happyBlackRectangle(5000);
        BrushTwo();
        rectMode(CENTER_DIAMETER);
        ellipseMode(CENTER_DIAMETER);
        noStroke();
        AbstractJs();
        rectMode(CORNER);
        ellipseMode(CENTER);
      } else {
        // 12.5 - 25%
      }
    } else {
      // 25 - 50%
      if (pos < player.length() * 0.375) {
        // 25 - 37.5%
      } else {
        // 37.5 - 50%
      }
    }
  } else {
    // 50 - 100%
    if (pos < player.length() * 0.75) {
      // 50 - 75%
      if (pos < player.length() * 0.125) {
        // 50 - 62.5%
      } else {
        // 62.5 - 75%
      }
    } else {
      // 75 - 100%
      if (pos < player.length() * 0.375) {
        // 75 - 87.5%
      } else {
        // 87.5 - 100%
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
