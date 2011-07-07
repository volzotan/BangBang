import processing.core.*; 
import processing.xml.*; 

import controlP5.*; 
import ddf.minim.*; 
import ddf.minim.signals.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class BangBang extends PApplet {

// controlP5


// GUI
ControlP5 controlP5;
PImage playImage, pauseImage;
PShape kleckse[] = new PShape[9];

// Minim



 
 
// Audio Player, Beat detection
Minim minim;
AudioPlayer player;
BeatDetect beat;

// Canvas setup 
PImage bufSlice;
PGraphics buf;
int copyOffsetX, copyOffsetY, copyWidth, copyHeight, prevOffsetX = 0, prevOffsetY = 0;

// Vignette / Background image 
PImage vignette, bgCanvas;
 
// Viewport-Initialisierung / Viewport-Bewegungsvariablen
float x = 400;
float y = 225;          // Legt Position des Viewports bei Initialisierung fest

// Protected zone (rectangle) around the relative center in which scrolling doesn't happen, 0 = no such zone
int groesseSchutzzoneX = 0; 
int groesseSchutzzoneY = 0;

// dampen mouse movements for brush following
float verfolgungsDaempfungX = 10;
float verfolgungsDaempfungY = 10;

// Global auto-scrolling value
float scrollGeschwindigkeit = 5;
int autoScrollX = 0;
int autoScrollY = 0;
// Direction; constant scrolling in any direction without any mouse movements
float xRichtungsFaktor = 10, yRichtungsFaktor = 0;
  
int xPosKoord = copyOffsetX + (int) xRichtungsFaktor;
int yPosKoord = copyOffsetY + (int) yRichtungsFaktor;

// use this with % to execute functions at every nth draw execution
int drawCounter = 0;

// MiniMap; Initialpositionierung des Viewport-Rechtecks (abh\u00e4ngig von x,y in Z. 17) wird aber sofort bei Programmstart \u00fcberschrieben  
int miniMapPosX = 0, miniMapPosY = 0;
PImage scaledMiniMap;

// Brush
int angle = 0, tempBrushValue;

// Variablen zur Kontrolle des Brushes
int deltaMouseX = 0;
int deltaMouseY = 450;
int[] lastMousePosX = new int[30], lastMousePosY = new int[30];

// Particle System
ParticleSystem ps;

// Bird flock
Flock flock;

// EXPERIMENTAL
int[] directionArrayX = new int[10];
int[] directionArrayY = new int[10];

// setup
boolean initialised = false, doClear = false;

public void setup(){
  size(800, 450, JAVA2D);
  frameRate(30);

  initCanvas(true);
  initVignette();
  initImages();
  setupGUI();
 
  copyOffsetX = 0;
  copyOffsetY = (buf.height - height) / 2;      // startet am linken \u00e4u\u00dferen Rand in der Mitte
  copyWidth = width;
  copyHeight = height;
  
  // load and instantiate audio player
  minim = new Minim(this);
  player = minim.loadFile("BettyChungBangBang.mp3");
  beat = new BeatDetect();

  scaledMiniMap = buf.get(0, 0, buf.width, buf.height);
  scaledMiniMap.resize(0, 18);                // resize-Wert ist buf.height/50
  
  ps = new ParticleSystem(0, new PVector(width/2,height/2,0));
  flock = new Flock();
  boolean initFlock = false;
  
  deltaMouseX = 470;
  deltaMouseY = 450;
}

public void draw(){
  if(doClear) {
    initCanvas(true);
    doClear = false;
    initialised = false;
    player.pause();
    player.rewind();
  }
  
  if(!initialised) {
    image(getBufSlice(), 0, 0);
    image(playImage, 0, 0);
    drawGUI();
  } else {  
    controlP5.hide();
    beat.detect(player.mix);
    if(beat.isOnset()) {
       tempBrushValue = 80; 
    }
           
    x = x + (mouseX-x)/verfolgungsDaempfungX;
    y = y + (mouseY-y)/verfolgungsDaempfungY;
    drawCounter++;
      
    if(player.isPlaying() && player.position() < 47986) {
      moveViewport();
      buf.beginDraw();
      if (drawCounter % 1 == 0) {        
        brushThree();
      }      
      directionArrayX[drawCounter % 10] = (int) x + copyOffsetX;
      directionArrayY[drawCounter % 10] = (int) y + copyOffsetY;
      
      if (drawCounter % 3 == 0) {
   
        castEffect();
      }      
      buf.endDraw();
    
      ps.run();
      flock.run();
      drawVignette();
      drawMiniMap();       
      tempBrushValue *= 0.95f;      
    } else {
      if (player.position() < 47986) {
        image(getBufSlice(), 0, 0);
        image(pauseImage, 0, 0);    
      } else {
        moveViewport();
        drawVignette();
        drawMiniMap();          
      }     
    }  
  
    if (drawCounter % 3 == 0) {
      prevOffsetX = copyOffsetX;
      prevOffsetY = copyOffsetY;
    }   
  }

  // Mittelpunkt des Pinsels abgreifen zur Verwendung f\u00fcr Effekte
  if(drawCounter % 1 == 0) {                              
    lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
    lastMousePosY[drawCounter%30] = (int) y + copyOffsetY;
  }
  //println(frameRate + " at " + player.position());
}
  
public void stop() {                                       // Minim Stop
  player.close();
  minim.stop();
  super.stop();
}
/** 
 * "Stempel" mit 5 Ellipsen im Umkreis
 */
public void brushOne(boolean useOffset) {
  buf.noStroke();
  buf.fill(0,0,0,150);
  float extraOffset = 0;
  if(useOffset) {
     if(random(1) < 0.5f) {
        extraOffset = -37+48*player.left.get(0);
     } else {
        extraOffset = 52+30*player.right.get(0);
     }  
  }  
  angle += 10;
  float val = cos(radians(angle)) * 10.0f;
  for (int a = 0; a < 360; a += 72) { // += als parameter f\u00fcr Pinselmuster
    float xoff = cos(radians(a)) * val;
    float yoff = sin(radians(a)) * val;    
    buf.ellipse(x + copyOffsetX + xoff, y + copyOffsetY + yoff + player.left.get(0) * 50+extraOffset, val + player.left.get(0) * 20, val + player.left.get(0) * 20);
  }
  buf.fill(0,0,0,255);
  buf.ellipse(x + copyOffsetX, y + copyOffsetY + player.left.get(0) * 50+extraOffset, 2 , 2);

  // Mittelpunkt des Pinsels abgreifen zur Verwendung f\u00fcr Effekte
  if(drawCounter % 1 == 0) {                              
    lastMousePosX[drawCounter%30] = (int) x + copyOffsetX;
    lastMousePosY[drawCounter%30] = (int) y + copyOffsetY + (int) (player.left.get(0) * 50);
  }

}

// kontinuierliche linie
public void brushTwo() {
  buf.stroke(0,0,0);
  buf.strokeWeight(5);     
  buf.line(mouseX + copyOffsetX, mouseY + copyOffsetY, pmouseX + prevOffsetX, pmouseY + prevOffsetY);
}

public void brushThree() {
  buf.stroke(100-tempBrushValue,100-tempBrushValue,100-tempBrushValue);
  buf.strokeWeight(5+tempBrushValue*0.13f); 
  
  float verhaeltnisSumme = x + copyOffsetX - directionArrayX[drawCounter%10] + y + copyOffsetY - directionArrayY[drawCounter%10];
  float verhaeltnisX = (x + copyOffsetX - directionArrayX[drawCounter%10]) / verhaeltnisSumme;
  float verhaeltnisY = (y + copyOffsetY - directionArrayY[drawCounter%10]) / verhaeltnisSumme;
  
  int oldX = (int) (x + copyOffsetX + verhaeltnisY * (player.left.get(0) * 50));
  int oldY = (int) (y + copyOffsetY + verhaeltnisX * (player.left.get(0) * 50));
  buf.line(oldX, oldY, deltaMouseX, deltaMouseY);
  
  /*
  if (drawCounter % 10 == 0) {
    buf.strokeWeight(1); 
    buf.line(directionArrayX[drawCounter%10], directionArrayY[drawCounter%10], x + copyOffsetX, test);
  }
 */
  
  deltaMouseX = oldX;
  deltaMouseY = oldY;
}
 /*  Variablen zum Effektezeichnen
  * + mousePosX, mousePosY geben die Mausposition an
  * + boolean testOnCanvasX(int zuTestendeKoordinate) gibt an ob 
  *   eine Koordinate die vollgezeichnet werden soll sich auf der Zeichenflaeche befindet
  * + lastMousePosX[0-29] gibt vorherige absolute Mausposition aus
  *
  *  bei einer Mindestframerate von 24 wird durchschnittliche alle 42ms ein draw gezeichnet
  *  bei jedem zweiten draw ein brush() bedeutet eine Ausf\u00fchrung alle 82ms. Zur Sicherheit
  *  das doppelte Intervall bei der Positions\u00fcberpr\u00fcfung ber\u00fccksichtigen
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


public void castEffect() {
  int pos = player.position();
  
  if (pos < player.length() * 0.5f) {
    // 0 - 50%
    if (pos < player.length() * 0.25f) {
      // 0 - 25%      
      if (pos < player.length() * 0.125f) {
        // 0 - 12.5% // 0.001 - 5.997
        // 1. udn 2. part gegenstimme
        if((pos <  3050) && (pos > 1950) ||
           (pos <  6050) && (pos > 4950)) 
        {
           brushOne(true); 
        }
      } else {
        // 12.5 - 25% // 5.998 - 11.996
        // 3. part gegenstimme
        if((pos < 10550) && (pos > 9750)) {
          brushOne(true);
        }
        // general pause  
        if((pos > 11850) && (pos > 10450)) {

        }
        // gesang
        if(pos > 11850) {
          ps.addParticle(x+copyOffsetX,y+copyOffsetY);
        }        
      }
    } else {
      // 25 - 50%
      // gesang
      ps.addParticle(x+copyOffsetX,y+copyOffsetY);       
      if (pos < player.length() * 0.375f) {
        // 25 - 37.5% // 11.997 - 17.994 
        
        //initFlock(3);
      } else {
        // 37.5 - 50% // 17.995 - 23.992
      }
    }
  } else {
    // 50 - 100%
    if (pos < player.length() * 0.75f) {
      // 50 - 75%
      if (pos < player.length() * 0.625f) {
        // 50 - 62.5% // 23.993 - 29.990
        tintenklecks(24000,  8  , pos);
        tintenklecks(25000,  6.5f, pos);
        tintenklecks(27000,  3  , pos);
        tintenklecks(28000, 10  , pos);        
      } else {
        // 62.5 - 75% // 29.991 - 35.989
        tintenklecks(30000,  1  , pos);
        tintenklecks(31000, 11  , pos);   
        tintenklecks(33000,  8  , pos);
        tintenklecks(33900,  6.5f, pos);        
      }
    } else {
      // 75 - 100%
      if (pos < player.length() * 0.875f) {
        // 75 - 87.5% // 35.990 - 41.987
        tintenklecks(39000,  4  , pos);
        tintenklecks(40000,  7  , pos);
        if((pos > 40550)) {
          brushOne(true);
        }        
      } else {
        // 87.5 - 100% // 41.988 - 47.986
        if((pos < 43350)) {
          brushOne(true);
        }        
      }
    }
  }
}


public void happyBlackRectangle(int time) {
  if ((player.position() < time + 300) && (player.position() > time - 300)) {
    for (int i = 0; i<30; i++) {
      buf.rect(lastMousePosX[i], lastMousePosY[i], 10, 10);
    }
  }
} 

public void tintenklecks(int time, float size, int pos) {
  if ((pos < time + 165) && (pos > time - 165)) {
    int r = floor(random(0,8.5f));
    buf.shape(kleckse[r], copyOffsetX + 50 + 100 * random(-1,+1), copyOffsetY + 70 * random(-1,+1));
  }
} 

public void initFlock(int amount) {
  for (int j = 0; j < 10; j++) {
    for (int i = 0; i < amount; i++) {
      flock.addBoid(new Boid(new PVector(lastMousePosX[j*3], lastMousePosY[j*3]), 3.0f, 0.05f));
    }  
  }
}  
// The Flock (a list of Boid objects)

class Flock {
  ArrayList boids; // An arraylist for all the boids

  Flock() {
    boids = new ArrayList(); // Initialize the arraylist
  }

  public void run() {
    for (int i = 0; i < boids.size(); i++) {
      Boid b = (Boid) boids.get(i);  
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  public void addBoid(Boid b) {
    boids.add(b);
  }

}




// The Boid class

class Boid {

  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    Boid(PVector l, float ms, float mf) {
    acc = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));
    loc = l.get();
    r = 2.0f;
    maxspeed = ms;
    maxforce = mf;
  }

  public void run(ArrayList boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  // We accumulate a new acceleration each time based on three rules
  public void flock(ArrayList boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5f);
    ali.mult(1.0f);
    coh.mult(1.0f);
    // Add the force vectors to acceleration
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
  }

  // Method to update location
  public void update() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }

  public void seek(PVector target) {
    acc.add(steer(target,false));
  }

  public void arrive(PVector target) {
    acc.add(steer(target,true));
  }

  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
  public PVector steer(PVector target, boolean slowdown) {
    PVector steer;  // The steering vector
    PVector desired = target.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0f)) desired.mult(maxspeed*(d/100.0f)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = target.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force
    } 
    else {
      steer = new PVector(0,0);
    }
    return steer;
  }

  public void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = vel.heading2D() + PI/2;
    fill(100,100);
    stroke(0);
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  public void borders() {
    if (loc.x < -r) loc.x = width+r;
    if (loc.y < -r) loc.y = height+r;
    if (loc.x > width+r) loc.x = -r;
    if (loc.y > height+r) loc.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  public PVector separate (ArrayList boids) {
    float desiredseparation = 20.0f;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  public PVector align (ArrayList boids) {
    float neighbordist = 25.0f;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist)) {
        steer.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  public PVector cohesion (ArrayList boids) {
    float neighbordist = 25.0f;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = loc.dist(other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.loc); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return steer(sum,false);  // Steer towards the location
    }
    return sum;
  }
}
// gui instanz und buttons erstellen
public void setupGUI(){
  controlP5 = new ControlP5(this);
  Button playButton = controlP5.addButton("Play",0,(int) width/2-100,(int) height/2-100,200,200);
  
  // settings playbutton
  playButton.setColorActive(color(255,255,255,0));
  playButton.setColorBackground(color(255,255,255,0));
  playButton.setColorForeground(color(255,255,255,0));
  playButton.setColorLabel(color(255,255,255,0));
  playButton.setColorValue(color(255,255,255,0));
  playButton.captionLabel().style().marginLeft = 100;
}

// gui zeichnen
public void drawGUI(){
  controlP5.show();
  controlP5.draw();
}

//  initial funktion f\u00fcr start am anfang
public void Play(int theValue) {
  initialised = true;
  player.play();
}

// tastatur befehle
// r = reset
// space = play/pause => icon einblenden?
// ???
public void keyReleased() {
  if ('r' == key || 'R' == key) { doClear = true; }
  if ('s' == key || 'S' == key) { buf.save(timestamp() +".png"); }
  if (' ' == key) { 
    if(player.isPlaying()) {
      player.pause();
    } else if(initialised && player.position() < 47986) {
      player.play();
    } else if(!initialised) {
      Play(0);
    }  
  }
}
// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are born

  ParticleSystem(int num, PVector v) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin));    // Add "num" amount of particles to the arraylist
    }
  }

  public void run() {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  public void addParticle() {
    particles.add(new Particle(origin));
  }
  
  public void addParticle(float x, float y) {
    particles.add(new Particle(new PVector(x,y)));
  }

  public void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  public boolean dead() {
    return particles.isEmpty();
  }

}

// A simple Particle class
class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  
  // Another constructor (the one we are using here)
  Particle(PVector l) {
    acc = new PVector(0,0.05f,0);
    vel = new PVector(random(-1,1),random(-2,0),0);
    loc = l.get();
    r = 10.0f;
    timer = 100.0f;
  }

  public void run() {
    update();
    if((int) timer % 6 == 0) {
      render();
    }
  }

  // Method to update location
  public void update() {
    vel.add(acc);
    loc.add(vel);
    timer -= 1.0f;
  }

  // Method to display
  public void render() {
    ellipseMode(CENTER);
    buf.stroke(0,timer);
    buf.fill(0,timer);
    buf.ellipse(loc.x,loc.y,r,r);
    //displayVector(vel,loc.x,loc.y,10);
  }
  
  // Is the particle still useful?
  public boolean dead() {
    if (timer <= 0.0f) {
      return true;
    } else {
      return false;
    }
  }
  
   public void displayVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(255);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    line(len,0,len-arrowsize,+arrowsize/2);
    line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  } 

}
public int calcMiniMapPosX() {
  float diffX =  (copyOffsetX / (buf.width/100));  // Prozentualer Vorr\u00fcckungsgrad
  
  float verschiebungX = 1.6f * diffX;                // Konstante ist buf.width/50/100
  return (int) verschiebungX;
}

public int calcMiniMapPosY() {
  float diffY =  (copyOffsetY / (buf.height/100));  // Prozentualer Vorr\u00fcckungsgrad
  
  float verschiebungY = 0.18f * diffY;              // Konstante ist buf.width/50/100
  return (int) verschiebungY;
}

public void drawMiniMap(){
  // rgb stroke black
  stroke(0,0,0);
  // stroke width 1 pixel
  strokeWeight(1);
  // rgb fill fully transparent
  fill(0,0,0,50);
  // minimap window position
  // breite und h\u00f6he sind buf.width/50+2 bzw. buf.height/50+2  
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

public void drawVignette(){
  image(vignette, 0, 0);
}

public PImage getBufSlice() {
  return buf.get(copyOffsetX, copyOffsetY, copyWidth, copyHeight);
}

public void initCanvas(boolean useBGImage) {
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

public void initImages() {
  pauseImage = loadImage("pause_new.png");
  playImage = loadImage("play_new.png");
  for(int i = 0; i < 9; i++) {
    kleckse[i] = loadShape("klecks_"+i+".svg");
  }  
}  

public void initVignette() {
  vignette = loadImage("vignette.png");  
}  

public void moveViewport(){ 
  image(getBufSlice(), 0, 0);

  float xPos = mouseX-width/2;  // xPos,yPos sind Koordinaten relativ zum Mittelpunkt
  float yPos = mouseY-height/2;
  
  if (drawCounter % 2 == 0) {
    if ((abs(xPos) >  groesseSchutzzoneX ) || (abs(yPos) >  groesseSchutzzoneY )) {          // Schutzzone
      
      yPos = yPos * 1.7f;        // "normalisiert" den Richtungsvektor den yPos darstellt
      
      xRichtungsFaktor = (xPos / (abs(xPos) + abs(yPos)));
      yRichtungsFaktor = (yPos / (abs(xPos) + abs(yPos)));
      
    }
  }

  float xBeschleunigungsFaktor = xRichtungsFaktor * scrollGeschwindigkeit + autoScrollX;    // AutoScrolling unabh\u00e4ngig vom Beschleunigungsfaktor
  float yBeschleunigungsFaktor = yRichtungsFaktor * scrollGeschwindigkeit + autoScrollY;
  
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

public boolean testOnCanvasX(int xPosCoord) {
    if(xPosKoord > buf.width - width) {
      return false;
    } else if(xPosKoord < 0) {
      return false;
   }
   
   return true;
}

public boolean testOnCanvasY(int yPosCoord) {
  if(yPosKoord > buf.height - height) {
    return false;
  } else if(yPosKoord < 0) {
    return false;
  }
   
  return true;
}

public String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#D4D0C8", "BangBang" });
  }
}
