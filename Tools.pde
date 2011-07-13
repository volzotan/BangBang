int calcMiniMapPosX() {
  float diffX =  (copyOffsetX / (buf.width/100));  // Prozentualer Vorrückungsgrad
  
  float verschiebungX = 1.6 * diffX;                // Konstante ist buf.width/50/100
  return (int) verschiebungX;
}

int calcMiniMapPosY() {
  float diffY =  (copyOffsetY / (buf.height/100));  // Prozentualer Vorrückungsgrad
  
  float verschiebungY = 0.18 * diffY;              // Konstante ist buf.width/50/100
  return (int) verschiebungY;
}

void drawMiniMap(boolean toggle){  
  if(toggle){
    
    // rgb stroke black
    stroke(0,0,0);
    // stroke width 1 pixel
    strokeWeight(1);
    // rgb fill fully transparent
    fill(0,0,0,50);
    // minimap window position
    // breite und höhe sind buf.width/50+2 bzw. buf.height/50+2  
    rect(629,9,161,19);
   
    if (drawCounter % 5 == 0) {
      scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
      // resize-Wert ist buf.height/50    
      scaledMiniMap.resize(0, 18);
    }
    image(scaledMiniMap, 630, 10);                    
   
    if (drawCounter % 3 == 0) {
      miniMapPosX = calcMiniMapPosX() + 630;
      miniMapPosY = calcMiniMapPosY() + 10;
    }
   
    // rgb stroke black
    stroke(0,0,0,0); 
    rect(miniMapPosX, miniMapPosY, 16, 9);
  }
}

void drawVignette(boolean doDraw){
  if(doDraw) {
    image(vignette, 0, 0);
  }
}

PImage getBufSlice() {
  PImage temp = buf.get(copyOffsetX, copyOffsetY, copyWidth, copyHeight);
  if(doInvert) {
    temp.filter(INVERT); 
  }
  return temp;
}

void initCanvas(boolean useBGImage) {
  buf = createGraphics(8000, 900, JAVA2D);
  buf.beginDraw();
  buf.smooth();
  if(useBGImage) {
    bgCanvas = loadImage("bg_leinwand.jpg");
    buf.background(bgCanvas);    
  } else {
    buf.background(160);
  }  
  buf.endDraw();  
}

void initImages() {
  mainButtonImage = loadImage("buttons/MainButton.png");
  menuButtonImage = loadImage("buttons/MenuButton.png");
  demoButtonImage = loadImage("buttons/DemoMask.png");
  exitButtonImage = loadImage("buttons/ExitMask.png");
  saveButtonImage = loadImage("buttons/SaveMask.png");
  mapDButtonImage = loadImage("buttons/MapDMask.png");
  mapEButtonImage = loadImage("buttons/MapEMask.png");
  resetButtonImage = loadImage("buttons/ResetMask.png");
  savingImage = loadImage("SavingOverlay.png");  
  overlayImage = loadImage("MenuOverlay.png");
  cursorImage_blank = loadImage("cursor.png");
  cursorImage_circle = loadImage("cursor_circle.png");
  cursorImage_nyancat = loadImage("cursor_nyan.png");
  for(int i = 0; i < inkSplatter.length; i++) {
    inkSplatter[i] = loadImage("inkSplatter/klecks_"+i+".png");
  }  
}  

void initVignette() {
  vignette = loadImage("vignette.png");  
}  

void moveViewport(){ 
  image(getBufSlice(), 0, 0);

  float xPos = mouseX-width/2;  // xPos,yPos sind Koordinaten relativ zum Mittelpunkt
  float yPos = mouseY-height/2;
  
  if (drawCounter % 2 == 0) {
    if ((abs(xPos) >  groesseSchutzzoneX ) || (abs(yPos) >  groesseSchutzzoneY )) {          // Schutzzone
      
      yPos = yPos * 1.7;        // "normalisiert" den Richtungsvektor den yPos darstellt
      
      xRichtungsFaktor = (xPos / (abs(xPos) + abs(yPos)));
      yRichtungsFaktor = (yPos / (abs(xPos) + abs(yPos)));
      
    }
  }

  float xBeschleunigungsFaktor = (abs(xRichtungsFaktor) * tempScrollGeschwindigkeit)/2 + autoScrollX;    // AutoScrolling unabhängig vom Beschleunigungsfaktor              // ABS() ENTFERNEN ZUM SCROLLEN IN BEL. RICHTUNGEN
  float yBeschleunigungsFaktor = yRichtungsFaktor * tempScrollGeschwindigkeit + autoScrollY;
  
  xPosKoord = copyOffsetX + (int) xBeschleunigungsFaktor;
  yPosKoord = copyOffsetY + (int) yBeschleunigungsFaktor;
  
  if(xPosKoord > buf.width - width) {
      xPosKoord = buf.width - width;
    } else if(xPosKoord < 0) {
      xPosKoord = 0;
   }
  
   if(yPosKoord > buf.height - height) {
      yPosKoord = buf.height - height;
    } else if(yPosKoord < 0) {
      yPosKoord = 0;
   }
  
  copyOffsetX = xPosKoord;
  copyOffsetY = yPosKoord;
}

void switchCursor(int kind) {
  if(switchCursor != kind || useNyancat) {
    switch(kind) {
      case 1: cursor(ARROW); switchCursor = kind; break;
      case 2: cursor(cursorImage_blank); switchCursor = kind; break;   
      case 3: cursor(cursorImage_circle); switchCursor = kind; break;
      case 4: cursor(cursorImage_nyancat); switchCursor = kind; break;
    }  
  }  
}  

boolean testOnCanvasX(int xPosCoord) {
    if(xPosKoord > buf.width - width) {
      return false;
    } else if(xPosKoord < 0) {
      return false;
   }
   
   return true;
}

boolean testOnCanvasY(int yPosCoord) {
  if(yPosKoord > buf.height - height) {
    return false;
  } else if(yPosKoord < 0) {
    return false;
  }
   
  return true;
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}

void drawGhostBrush() {
  println("buhu!");
  ghostBrush = true;
}
