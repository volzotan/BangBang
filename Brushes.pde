/**
 * Zu verwendende Parameter
 *   ?
 * Fehlende Implementierungen:
 *
 * Probleme:
 * Alle Zeichenanweisungen die außerhalb der Methoden unten 
 * stattfinden müssen Stroke, Fill, etc wieder auf einen Basiswert zurücksetzen
 */
 /*
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
*/
/** 
 * "Stempel" mit 5 Ellipsen im Pentagram
 */
void BrushOne() {
  angle += 10;
  float val = cos(radians(angle)) * 10.0;
  for (int a = 0; a < 360; a += 10) {
    float xoff = cos(radians(a)) * val;
    float yoff = sin(radians(a)) * val;
    buf.fill(0);     
    buf.ellipse(x + copyOffsetX + xoff, y + copyOffsetY + yoff + player.left.get(0) * 50, val, val);
  }
  buf.fill(255);
  //buf.ellipse(x + copyOffsetX, y + copyOffsetY, 2 * player.left.get(0) * 50, 2 * player.right.get(0) * 50);
  buf.ellipse(x + copyOffsetX, y + copyOffsetY + player.left.get(0) * 50, 2 , 2 /* * player.right.get(0) * 50*/ );
}
