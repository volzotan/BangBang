/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
void brushOne(boolean useOffset, int drawSize) {
	float extraOffsetY = 0;	float extraOffsetX = 0;
	// depending on the draw Size (2 = large, 1 = medium, 0 = small
	// a random offset in Y (and X) direction is calculated
	if(useOffset) {
		switch(drawSize) {
			case 1 : 
				extraOffsetY = (random(1) < 0.5) ? -74+60*random(-1,1) : 87+70*random(-1,1);
				extraOffsetX = (random(1) < 0.5) ? -37+60*random(-1,1) : 52+70*random(-1,1);			
				break;
			case 2 : 
				extraOffsetY = random(-50,50);		
				break;				
			default:
				extraOffsetY = (random(1) < 0.5) ? -74+60*player.left.get(1)*random(-1,1) : 87+70*player.right.get(1)*random(-1,1);
				extraOffsetX = (random(1) < 0.5) ? -37+60*player.left.get(1)*random(-1,1) : 52+70*player.right.get(1)*random(-1,1);			
		}	
	}	
	
	float val = cos(radians(angle)) * 10.0 + 4;
	angle = (angle > 360) ? 0 : angle + 10;
	float size1 = 9, size2 = random(8,20), spacing = 1.1;
	int alpha2 = 255;
	int r = 0, g = 0, b = 0, o = 150; // black
	if(2 == drawSize) { // large
		size1 = 275;
		size2 = 230;
		spacing = 32;
		alpha2 = 60;
		val = (val > 9.5 || val < 5) ? random(6,9) : val;
		r = 80; g = 22; b = 28; o = 160; // red
	} else if (1 == drawSize) { // medium
		size1 = 95;
		size2 = 85;
		spacing = 13;
		alpha2 = 60;
		val = (val > 8 || val < 5) ? random(5,7.5) : val;
		r = 13; g = 36; b = 98; o = 100; // blue
	} else {					// small
		val = random(10,22);
		
	}	
		
	buf.beginDraw();
	buf.noStroke();
	for (int a = 0; a < 360; a += 72) { // += als parameter für Pinselmuster
		float offX = cos(radians(a)) * val * spacing;
		float offY = sin(radians(a)) * val * spacing;		
		buf.noStroke();
		buf.fill(r,g,b,o);
		buf.ellipse(x + copyOffsetX + offX + extraOffsetX, y + copyOffsetY + offY + player.left.get(0) * 50 + extraOffsetY, val + player.left.get(0) * 20 + size1, val + player.left.get(0) * 20 + size1);
	}
	buf.noStroke();
	buf.fill(0,0,0,alpha2);		
	buf.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + player.left.get(0) * 50 + extraOffsetY, 2 + size2 , 2 + size2);
	buf.endDraw();

	// Grab mouse position for use in effects and brushes
	// TODO WHAT DOES THIS DO HERE? IT IS CALLED IN DRAW() WITHOUT THE + X in Y coordinate
//	if(drawCounter % 1 == 0) {															
//		lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
//		lastMousePosY[drawCounter%30] = (int) y + copyOffsetY + (int) (player.left.get(0) * 50);
//	}
}

// continuous line
void brushThree() {
	color c = color(145,145,145);
	int w = 5;
	// 10,5 - 11,8 :: General Pause	
	if(!useNyancat) {
		if(pos < 10500 || pos > 11800) {
			c = color(100-tempBrushValue,100-tempBrushValue,100-tempBrushValue);
			w += tempBrushValue*0.13;
		} else {
			w -= 1;
		}
	} else {	
		if(tempNyanPos+250 < pos) {
			switch(tempNyanCol) {
				case 0 : nyanColor = color(255,	42,  12); tempNyanCol++; break; // Red
				case 1 : nyanColor = color(255, 164,   9); tempNyanCol++; break; // Orange
				case 2 : nyanColor = color(255, 246,   0); tempNyanCol++; break; // Yellow
				case 3 : nyanColor = color( 50, 233,   3); tempNyanCol++; break; // Green
				case 4 : nyanColor = color(	2, 162, 255); tempNyanCol++; break; // Blue
				case 5 : nyanColor = color(119,	85, 255); tempNyanCol=0; break; // Purple
			}				
			tempNyanPos = pos;
		}
		c = nyanColor;
		w += tempBrushValue*0.13;
	}
	
	float verhaeltnisSumme = abs(x + copyOffsetX - directionArrayX[drawCounter%10]) + abs(y + copyOffsetY - directionArrayY[drawCounter%10]);
	float verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
	float verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;	
	
	oldX = (int) (x + copyOffsetX + verhaeltnisY * (player.left.get(0) * brushThreeDeflectionScale));
	oldY = (int) (y + copyOffsetY + verhaeltnisX * (player.left.get(0) * 100));
	
	buf.beginDraw();
	buf.stroke(c);
	buf.strokeWeight(w);
	buf.line(oldX, oldY, deltaMouseX, deltaMouseY);
	buf.endDraw();
	
	deltaMouseX = oldX;
	deltaMouseY = oldY;
}


void ghostBrush() {
	//buf.beginDraw();
	//buf.line(oldX, oldY, deltaMouseX - 100, deltaMouseY + 50);
	//buf.endDraw();
}

// random circles and dots
void brushFour(int minAmount, int maxAmount) {
	int amount = floor(random(minAmount,maxAmount));
	if(random(1) < 0.5) { amount *= -1; }
	color c = color(0,0,0);
			
	float extraOffsetX = 0, extraOffsetY = 0;	
	
	for(int i = 0; i < amount; i++) {	
		int size = floor(random(2,4));
		
		extraOffsetX = (random(1) < 0.5) ? - 6+48*player.left.get(0)+ 8*random(-10,50) : 15+30*player.right.get(0)+3*random(-10,50);
		extraOffsetY = (random(1) < 0.5) ? -44+48*player.left.get(0)+10*random(-50, 0) : 47+30*player.right.get(0)+5*random(  0,50);
		
		if(random(0,1) < 0.6) {
			c = color(145 - tempBrushValue - size + extraOffsetY - amount, 145 - tempBrushValue - size + extraOffsetY - amount, 145 - tempBrushValue - size + extraOffsetY - amount);
		} else {
			float rand = random(0,1);
			if(rand < 0.3) {
				c = color(80,22,28); // red
			} else if(rand > 0.6) {
				c = color(13,36,98); // blue
			} else {
				c = color(22,90,59); // green
			}	
		}	
		
		buf.beginDraw();
		buf.fill(c);
		buf.stroke(c);
		buf.ellipse(x + copyOffsetX + extraOffsetX, y + copyOffsetY + extraOffsetY,size,size);	
		buf.endDraw();
	}	
}


