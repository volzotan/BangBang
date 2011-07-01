/**
 * Zu verwendende Parameter
 *   ?
 * Fehlende Implementierungen:
 *
 * Probleme:
 * Alle Zeichenanweisungen die außerhalb der Methoden unten 
 * stattfinden müssen Stroke, Fill, etc wieder auf einen Basiswert zurücksetzen
 */
 
void drawBrush() {
  drawBrush(0); 
}  
 
void drawBrush(int BrushId) {
  switch(BrushId) {
    case 1: BrushOne();   break;  
    case 2: BrushTwo();   break;  
    case 3: BrushThree(); break;  
    case 4: BrushFour();  break;  
    case 5: BrushFive();  break;    
    default: BrushOne();
  }  
}

/** 
 * "Stempel" mit 5 Ellipsen im Pentagram
 */
void BrushOne() {
  angle += 10;
  float val = cos(radians(angle)) * 10.0;
  for (int a = 0; a < 360; a += 10) {
    float xoff = cos(radians(a)) * val;
    float yoff = sin(radians(a)) * val;
    fill(0);
    buf.ellipse(x + copyOffsetX + xoff, y + copyOffsetY + yoff + player.left.get(0) * 50, val, val);
  }
  buf.fill(255);
  //buf.ellipse(x + copyOffsetX, y + copyOffsetY, 2 * player.left.get(0) * 50, 2 * player.right.get(0) * 50);
  buf.ellipse(x + copyOffsetX, y + copyOffsetY + player.left.get(0) * 50, 2 , 2 /* * player.right.get(0) * 50*/ );
}

void BrushTwo() {
   
}

/**
 * Kontinuierliche Linien
 * TODO Die Linie ist nicht kontinuierlich
 */
void BrushThree() {
    buf.stroke(0,0,0);
    buf.strokeWeight(10);
    buf.line(mouseX + copyOffsetX, mouseY + copyOffsetY, pmouseX + prevOffsetX, pmouseY + prevOffsetY);    
}

/**
 * http://processing.org/learning/basics/bezierellipse.html
 */
void BrushFour() {
   
}

/**
 * http://processing.org/learning/topics/softbody.html
 */
void BrushFive() {
   
}
