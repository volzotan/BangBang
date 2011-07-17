 /*	Variablen zum Effektezeichnen
	* + mousePosX, mousePosY geben die Mausposition an
	* + boolean testOnCanvasX(int zuTestendeKoordinate) gibt an ob 
	*	 eine Koordinate die vollgezeichnet werden soll sich auf der Zeichenflaeche befindet
	* + lastMousePosX[0-29] gibt vorherige absolute Mausposition aus
	*
	*/	
	
// EFFECT RANGES
//
// Große Blume		 @ 10.300 sec
// Mittlere Blume	@ 25.350 sec
// Mittlere Blume	@ 28.200 sec
// Mittlere Blume	@ 31.050 sec
// Mittlere Blume	@ 39.850 sec
// Mittlere Blume	@ 42.120 sec
//
// Kleine Blumen	 @	2.340 sec -	2.930 sec ( 2.340,	2.460,	2.520,	2.625,	2.690)
// Kleine Blumen	 @	5.200 sec -	5.800 sec ( 5.200,	5.330,	5.410,	5.480,	5.580)
// Kleine Blumen	 @	8.100 sec -	8.680 sec ( 8.100,	8.180,	8.270,	8.330,	8.440)
// Kleine Blumen	 @ 33.200 sec - 34.035 sec (33.200, 33.430, 33.830, 34.035)
// Kleine Blumen	 @ 36.860 sec - 37.400 sec (36.860, 37.030, 37.170, 37.210, 37.330)

// INK SPLATTERS
int[][] splatterEventArray	= new int[10][2];	// 0 = delay, 1 = size
// FLOWER EFFECT
int[][] brushOneEventArray	= new int[30][3];	// 0 = delay, 1 = size Flag, 2 = Repeat Intervall[ms]
// SPREAD EFFECT
int[][] brushFourEventArray = new int[ 3][3];	// 0 = delay, 1 = do repeat, 2 = Repeat Intervall[ms]
// INVERT FILTER
int[][] invertEventArray	= new int[ 2][1];	// 0 = delay
// CRESCENDO EFFECT
int[][] crescendoEventArray	= new int[ 1][3];	// 0 = delay, 1 = do repeat, 2 = Repeat Intervall[ms]

// brush for circle amounts
final int MAXAMOUNT =  4; 
final int MINAMOUNT = 50;

void initEventArrays() {
	
	splatterEventArray[0][0]  =	24240;	splatterEventArray[0][1]  = 3;
	splatterEventArray[1][0]  =	24628;	splatterEventArray[1][1]  = 1;
	splatterEventArray[2][0]  =	27000;	splatterEventArray[2][1]  = 4;
	splatterEventArray[3][0]  =	27450;	splatterEventArray[3][1]  = 3;
	splatterEventArray[4][0]  =	29890;	splatterEventArray[4][1]  = 2;
	splatterEventArray[5][0]  =	30280;	splatterEventArray[5][1]  = 4;
	splatterEventArray[6][0]  =	32770;	splatterEventArray[6][1]  = 2;
	splatterEventArray[7][0]  =	33200;	splatterEventArray[7][1]  = 3;
	splatterEventArray[8][0]  =	38690;	splatterEventArray[8][1]  = 4;
	splatterEventArray[9][0]  =	39050;	splatterEventArray[9][1]  = 5;
	
	invertEventArray[0][0] 	  =	39850;
	invertEventArray[1][0]	  =	42120;
	
	crescendoEventArray[0][0] = 43300;	crescendoEventArray[0][1] = 1;	crescendoEventArray[0][2] = 100;
 
	// little flowers 1. sequenze
	brushOneEventArray[0][0]  =	 2340;	brushOneEventArray[0][1]  = 0;	brushOneEventArray[0][2]  = 0;
	brushOneEventArray[1][0]  =	 2460;	brushOneEventArray[1][1]  = 0;	brushOneEventArray[1][2]  = 0;
	brushOneEventArray[2][0]  =	 2520;	brushOneEventArray[2][1]  = 0;	brushOneEventArray[2][2]  = 0;
	brushOneEventArray[3][0]  =	 2625;	brushOneEventArray[3][1]  = 0;	brushOneEventArray[3][2]  = 0;
	brushOneEventArray[4][0]  =	 2690;	brushOneEventArray[4][1]  = 0;	brushOneEventArray[4][2]  = 0;
	
	// little flowers 2. sequenze
	brushOneEventArray[5][0]  =  5200;	brushOneEventArray[5][1]  = 0;	brushOneEventArray[5][2]  = 0;
	brushOneEventArray[6][0]  =  5330;	brushOneEventArray[6][1]  = 0;	brushOneEventArray[6][2]  = 0;
	brushOneEventArray[7][0]  =  5410;	brushOneEventArray[7][1]  = 0;	brushOneEventArray[7][2]  = 0;
	brushOneEventArray[8][0]  =  5480;	brushOneEventArray[8][1]  = 0;	brushOneEventArray[8][2]  = 0;
	brushOneEventArray[9][0]  =  5580;	brushOneEventArray[9][1]  = 0;	brushOneEventArray[9][2]  = 0;
	
	// little flowers 3. sequenze
	brushOneEventArray[10][0] =	 8100;	brushOneEventArray[10][1] = 0;	brushOneEventArray[10][2] = 0;
	brushOneEventArray[11][0] =	 8180;	brushOneEventArray[11][1] = 0;	brushOneEventArray[11][2] = 0;
	brushOneEventArray[12][0] =	 8270;	brushOneEventArray[12][1] = 0;	brushOneEventArray[12][2] = 0;
	brushOneEventArray[13][0] =	 8330;	brushOneEventArray[13][1] = 0;	brushOneEventArray[13][2] = 0;
	brushOneEventArray[14][0] =	 8440;	brushOneEventArray[14][1] = 0;	brushOneEventArray[14][2] = 0;
	
	// little flowers 4. sequenze
	brushOneEventArray[15][0] = 33200;	brushOneEventArray[15][1] = 0;	brushOneEventArray[15][2] = 0;
	brushOneEventArray[16][0] = 33430;	brushOneEventArray[16][1] = 0;	brushOneEventArray[16][2] = 0;
	brushOneEventArray[17][0] = 33830;	brushOneEventArray[17][1] = 0;	brushOneEventArray[17][2] = 0;
	brushOneEventArray[18][0] = 34035;	brushOneEventArray[18][1] = 0;	brushOneEventArray[18][2] = 0;
	
	// little flowers 5. sequenze 36.860, 37.030, 37.170, 37.210, 37.330
	brushOneEventArray[19][0] = 36860;	brushOneEventArray[19][1] = 0;	brushOneEventArray[19][2] = 0;
	brushOneEventArray[20][0] = 37030;	brushOneEventArray[20][1] = 0;	brushOneEventArray[20][2] = 0;
	brushOneEventArray[21][0] = 37170;	brushOneEventArray[21][1] = 0;	brushOneEventArray[21][2] = 0;
	brushOneEventArray[22][0] = 37210;	brushOneEventArray[22][1] = 0;	brushOneEventArray[22][2] = 0;
	brushOneEventArray[23][0] = 37330;	brushOneEventArray[23][1] = 0;	brushOneEventArray[23][2] = 0;
	
	// middle flowers
	brushOneEventArray[24][0] = 25350;	brushOneEventArray[24][1] = 1;	brushOneEventArray[24][2] = 0;
	brushOneEventArray[25][0] = 28200;	brushOneEventArray[25][1] = 1;	brushOneEventArray[25][2] = 0;
	brushOneEventArray[26][0] = 31050;	brushOneEventArray[26][1] = 1;	brushOneEventArray[26][2] = 0;
	brushOneEventArray[27][0] = 39850;	brushOneEventArray[27][1] = 1;	brushOneEventArray[27][2] = 0;
	brushOneEventArray[28][0] = 42120;	brushOneEventArray[28][1] = 1;	brushOneEventArray[28][2] = 0;
	
	// big flower
	brushOneEventArray[29][0] = 10300;	brushOneEventArray[29][1] = 2;	brushOneEventArray[29][2] = 0;
	
	brushFourEventArray[0][0] = 43300;	brushFourEventArray[0][1] = 1;	brushFourEventArray[0][2] = 100;
}

void savePauseTime() {
	elapsedTime = player.position();
}

void killAllScheduledEvents() {
	timer.cancel();											// .purge() problematisch
}

void pauseAllScheduledEvents() {
	savePauseTime();
	killAllScheduledEvents();
	timer = new Timer();
}

void startAllScheduledEvents() {
	scheduleBrushOneEvents();
	//scheduleBrushFourEvents();
	scheduleCrescendoEvent();
	scheduleInvertEvent();
	scheduleSplatterEvents();	
	
	//scheduleKillEvent();
	
	scheduleGhostBrush();
}

void scheduleKillEvent() {
	int killTime = 12000;
	/* Beispielcode | laeuft ohne Arrays weil das zu umständlich wird bei nur wenigen Events die abgebrochen werden muessen
	if (killTime - elapsedTime >= 0) {
		timer.schedule(new TimerTask() {
			public void run() {
				brushFourEventArray[1][3] = 0;
				pauseAllScheduledEvents();
				startAllScheduledEvents();
			}
		}, killTime - elapsedTime);
	}
	
	killTime = 18000;
	if (killTime - elapsedTime >= 0) {
		timer.schedule(new TimerTask() {
			public void run() {
				brushFourEventArray[2][3] = 0;
				pauseAllScheduledEvents();
				startAllScheduledEvents();
			}
		}, killTime - elapsedTime);
	}
	
	*/
}

void scheduleBrushOneEvents() {
	for (int i=0; i < brushOneEventArray.length; i++) {
		if (brushOneEventArray[i][0] - elapsedTime >= 0) {			
			if (brushOneEventArray[i][1] == 1) {			 // medium flower
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
			} else {																	 // regular/small flower
				// TODO STOP AFTER SET INTERVAL
				timer.schedule(new TimerTask() {
					public void run() {
						brushOne(true, 0);
					}
				}, brushOneEventArray[i][0] - elapsedTime);
			}
		}
	}
}

void scheduleBrushFourEvents() {
	for (int i=0; i < brushFourEventArray.length; i++) {
		if (brushFourEventArray[i][0] - elapsedTime >= 0 && brushFourEventArray[i][3] == 1) {			
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

void scheduleCrescendoEvent() {
	for (int i=0; i < crescendoEventArray.length; i++) {
		if (crescendoEventArray[i][0] - elapsedTime >= 0) { 
			timer.schedule(new TimerTask() {
				public void run() {
					crescendo();
				}
			}, crescendoEventArray[i][0] - elapsedTime, crescendoEventArray[i][1]);
		}
	}
}

void scheduleGhostBrush() {
	timer.schedule(new TimerTask() {
		public void run() {
			drawGhostBrush();
		}
	}, 12500);	// GhostBrush Start time
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

void tintenklecks(float size) {
	int r = floor(random(0,inkSplatter.length-0.5));
	float splatterSize = 25*size;	
	float posX = copyOffsetX +	width/2 + random(-50,50) * random(-2  ,+2  ), 
		  posY = copyOffsetY + height/3 + random(-50,50) * random(-1.5,+1.5);		

	// left side :: x position
	if(1 == inkSplatterPos || 2 == inkSplatterPos) {
		if(!(posX >= copyOffsetX && posX <= (copyOffsetX+width/2-splatterSize))) {
			posX = copyOffsetX + width/3 + random(-width/6,width/6);
		}					
	}	

	// right side :: x position
	if(0 == inkSplatterPos || 3 == inkSplatterPos) {				
		if(!(posX >= (copyOffsetX+width/2) && posX <= (copyOffsetX+width-splatterSize))) {
			posX = copyOffsetX + (width*2)/3 + random(-width/6,width/6);
		}
	} 
		
	// top side :: y position
	if(1 == inkSplatterPos || 0 == inkSplatterPos) {			 
		if(!(posY >= copyOffsetY && posY <= (copyOffsetY+height/2-splatterSize))) {
			posY = copyOffsetY + height/5 + random(-height/9,height/9) - random(0,40);
			if(posY < copyOffsetY) { posY = copyOffsetY - random(10,30); }
			if(posY > (copyOffsetY+height/2)) { posY = copyOffsetY + height/2 - random(20,60); }
		}			 
	}	
	
	// bottom side :: y position
	if(2 == inkSplatterPos || 3 == inkSplatterPos) {							
		if(!(posY >= (copyOffsetY+height/2) && posY <= (copyOffsetY+height-splatterSize))) {
			posY = copyOffsetY + (height*3)/4 + random(-height/8,height/8) - random(0,40) - splatterSize/2;
			if(posY < (copyOffsetY+height/2)) { posY = copyOffsetY + height/2 - random(0,splatterSize/5); }
			if(posY > (copyOffsetY+height)) { posY = copyOffsetY + height - random(splatterSize/2,splatterSize); }
		}			
	}
	
	//println(posX+"\t+\t"+posY + "\t| InkSplatterPos:"+inkSplatterPos);
	bg.beginDraw();
	bg.image(inkSplatter[r], posX, posY, splatterSize, splatterSize);
	bg.endDraw();
	inkSplatterPos = (inkSplatterPos+1) % 4;
} 

void crescendo() {
	if (firstRun) {
		oldDeltaX = oldX;
		oldDeltaY = oldY;
							
		tempScrollSpeed = 13;
							
		mainBrushActive = false;
		firstRun = false;
	}
												
	tempX = (int) (deltaMouseX + xPlus + random(-1,1) * 8);
	tempY = (int) (deltaMouseY + random(-1,1) * 15 + invsVar * (-1) * abs(amp));
	
	bg.beginDraw();
	bg.stroke(100-tempBrushValue,100-tempBrushValue,100-tempBrushValue);
	bg.strokeWeight(5+tempBrushValue*0.13);	
	bg.line(oldDeltaX, oldDeltaY, tempX, tempY);
	bg.endDraw();
				
	oldDeltaX = tempX;
	oldDeltaY = tempY;
						
	amp = amp + (0 - amp)/15;
	xPlus = xPlus + 6;
	invsVar = invsVar * (-1);
	
	tempScrollSpeed = tempScrollSpeed + (0 - tempScrollSpeed)/18;
	println(tempScrollSpeed);
}
