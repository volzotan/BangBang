int calcMiniMapPosX() {
  // delta movement in percent
  float diffX =  (copyOffsetX / (bg.width/100));
  // actual movement
  float verschiebungX = 1.6 * diffX; // 1.6 = bg.width/50/100
  return (int) verschiebungX;
}

int calcMiniMapPosY() {
  // delta movement in percent
  float diffY =  (copyOffsetY / (bg.height/100));
  // actual movement
  float verschiebungY = 0.18 * diffY; // 0.18 = bg.height/50/100  
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
    // breite und höhe sind bg.width/50+2 bzw. bg.height/50+2  
    rect(629,9,161,19);
   
    if (drawCounter % 5 == 0) {
      scaledMiniMap = bg.get(0, 0, bg.width, bg.height);
      // resize-Wert ist bg.height/50    
      scaledMiniMap.resize(0, 18);
    }
    image(scaledMiniMap, 630, 10);                    
   
    if (drawCounter % 3 == 0) {
      miniMapPosX = calcMiniMapPosX() + 630;
      miniMapPosY = calcMiniMapPosY() + 10;
    }
   
    // rgb stroke black
    // stroke(0,0,0,0);  check whether actually necessary
    rect(miniMapPosX, miniMapPosY, 16, 9);
  }
}

void drawVignette(boolean doDraw){
  if(doDraw) { image(vignette, 0, 0); }
}

PImage getBufSlice() {
  PImage temp;
  temp = bg.get(copyOffsetX, copyOffsetY, copyWidth, copyHeight);
  switch(doFilter) {
    case 1: temp.filter(GRAY); break;
    case 2: temp.filter(INVERT); break;
    case 3: temp.filter(ERODE); break;
    case 4: temp.filter(DILATE); break;   
    case 5: temp.filter(THRESHOLD, 0.8); break;    
    case 6: temp.filter(POSTERIZE, 4); break;    
    default:
  }    
  return temp;
}

void initCanvas(boolean useBGImage) {
  bg = createGraphics(8000, 900, JAVA2D);
  bg.beginDraw();  
  bg.smooth();  
  if(useBGImage) {    
    switch(switchBGImage) {
      case 0: bg.background(bgCanvas); break;
      case 1: bg.background(bgCanvasAlt);
    }
    
  } else {
    bg.background(160);
  }  
  bg.endDraw();
}

void initImages() {
  bgCanvas                = loadImage("bg_leinwand.jpg");
  bgCanvasAlt             = loadImage("bg_leinwand_1.jpg");  
  cursorImage_blank       = loadImage("cursor.png");
  cursorImage_circle      = loadImage("cursor_circle.png");
  cursorImage_nyancat     = loadImage("cursor_nyan.png");
  buttonMap               = loadImage("gui/ButtonMap.png");
  buttonReplay            = loadImage("gui/ButtonReplay.png");
  buttonSave              = loadImage("gui/ButtonSave.png");
  buttonHoverBigPlay      = loadImage("gui/ButtonHoverBigPlay.png"); 
  buttonHoverBigDemo      = loadImage("gui/ButtonHoverBigDemo.png");
  buttonHoverBigInteractive = loadImage("gui/ButtonHoverBigInteractive.png"); 
  buttonHoverBigReplay    = loadImage("gui/ButtonHoverBigReplay.png");
  buttonMaskBig           = loadImage("gui/MaskBig.png");
  buttonMaskSmall         = loadImage("gui/MaskSmall.png");
//buttonExitImage         = loadImage("gui/MaskExit.png");
//buttonDemoImage         = loadImage("gui/MaskDemo.png");
//buttonInteractiveImage  = loadImage("gui/MaskInteractive.png");
//buttonPlayImage         = loadImage("gui/MaskPlay.png");
//buttonReplayImage       = loadImage("gui/MaskReplay.png");
//buttonReplayBigImage    = loadImage("gui/MaskReplayBig.png");
//buttonPauseImage        = loadImage("gui/MaskPause.png");
//buttonMapImage          = loadImage("gui/MaskMap.png");
//buttonSaveImage         = loadImage("gui/MaskSave.png");
  overlayImage            = loadImage("OverlayMenu.png");
  savingImage             = loadImage("OverlaySaving.png");    
  vignette                = loadImage("vignette.png");
//flowerSmall             = loadImage("flowers/flowerSmall.png");
  flowerMedium            = loadImage("flowers/flowerMedium_0.png"); 
  flowerLarge             = loadImage("flowers/flowerLarge.png"); 
  
  for(int i = 0; i < flowersSmall.length; i++) {
    flowersSmall[i]    = loadImage("flowers/flowerSmall_"+i+".png");    
  } 

  for(int i = 0; i < inkSplatter.length; i++) {
    inkSplatter[i]    = loadImage("flowers/n"+i+"_100.png");    
  } 
}  

void moveMouse() {
  // start = 400 & 225;
  float rand = random(0,1);  
  roboX += (int) random(-1,3);
  boolean dontSkip = false;

  if(0.26 >= rand) {
    roboY += (int) random(10,30);
  } else if(0.26 < rand && 0.5 > rand) {
    roboY -= (int) random(10,30);
  } else {
    roboY += (int) random(-3,3);
  }  
  
  // left boundary 
  if(roboX < frame.getLocation().x + 30) {
    roboX += (int) random(40,70);
  }
  // right boundary
  if(roboX > frame.getLocation().x + width - 30) {
    roboX -= (int) random(40,70);    
  } 

  // upper boundary 
  if(roboY < frame.getLocation().y + 30) {
    roboY += (int) random(40,70);    
  }
  // lower boundary
  if(roboY > frame.getLocation().y + height - 30) {
    roboY -= (int) random(40,70);    
  }

  if(player.position() > 14000 && player.position() < 43300) {
      if(player.position() < 14000) {
        roboY = frame.getLocation().y+225;
      } else if(player.position() < 14500 && player.position() > 14050) {
        roboY = frame.getLocation().y+225-70;
      } else if(player.position() < 15000 && player.position() > 14550) {
        roboY = frame.getLocation().y+225+105;
      } else if(player.position() < 15500 && player.position() > 15050) {
        roboY = frame.getLocation().y+225-50;
      } else if(player.position() < 16000 && player.position() > 15550) {
        roboY = frame.getLocation().y+225;
      } else if(player.position() < 16500 && player.position() > 16050) {
        roboY = frame.getLocation().y+225+50;
      } else if(player.position() < 17000 && player.position() > 16550) {
        roboY = frame.getLocation().y+225-100;
      } else if(player.position() < 17500 && player.position() > 17050) {
        roboY = frame.getLocation().y+225+90;
      } else if(player.position() < 18000 && player.position() > 17500) {
        roboY = frame.getLocation().y+225-90;
      } else if(player.position() < 43300 && player.position() > 43000) {
        roboY = frame.getLocation().y+225+ (int) random(-20,20);
      }
      
      dontSkip = true;     
  }  
  
  if(10 == drawCounter || dontSkip) {
    robot.mouseMove(roboX,roboY); 
  }
}  

void moveViewport(){ 
  image(getBufSlice(), 0, 0);

  float posX = mouseX-width/2;  // posX,posY sind Koordinaten relativ zum Mittelpunkt
  float posY = mouseY-height/2;
  
  if (drawCounter % 2 == 0) {
    if ((abs(posX) >  scrollProtectionX ) || (abs(posY) >  scrollProtectionY )) {          // Schutzzone
      // "normalisiert" den Richtungsvektor den posY darstellt
      posY = posY * 1.7;        
      
      directionFactorX = (posX / (abs(posX) + abs(posY)));
      directionFactorY = (posY / (abs(posX) + abs(posY)));
    }
  }

  float xBeschleunigungsFaktor = (abs(directionFactorX) * tempScrollSpeed)/2 + autoScrollX;    // AutoScrolling unabhängig vom Beschleunigungsfaktor              // ABS() ENTFERNEN ZUM SCROLLEN IN BEL. RICHTUNGEN
  float yBeschleunigungsFaktor = directionFactorY * tempScrollSpeed + autoScrollY;
  
  positionCoordX = copyOffsetX + (int) xBeschleunigungsFaktor;
  positionCoordY = copyOffsetY + (int) yBeschleunigungsFaktor;
  
 if(positionCoordX > bg.width - width) {
    positionCoordX = bg.width - width;
  } else if(positionCoordX < 0) {
    positionCoordX = 0;
  }
   
  if(positionCoordY > bg.height - height) {
    positionCoordY = bg.height - height;
  } else if(positionCoordY < 0) {
    positionCoordY = 0;
  }
  
  copyOffsetX = positionCoordX;
  copyOffsetY = positionCoordY;
}  

boolean testOnCanvasX(int posXCoord) {
  if(positionCoordX > bg.width - width) {
    return false;
  } else if(positionCoordX < 0) {
    return false;
  }
   
   return true;
}

boolean testOnCanvasY(int posYCoord) {
  if(positionCoordY > bg.height - height) {
    return false;
  } else if(positionCoordY < 0) {
    return false;
  }
   
  return true;
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}
