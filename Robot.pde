// extend me please
class RoundSprite {
 
  float x, y, radius;
  float speedX, speedY;
  RoundSprite(float x, float y, float radius,
                  float speedX, float speedY){
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.speedX = speedX;
    this.speedY = speedY;
  }
  void move(){
    x += speedX;
    y += speedY;
  }
 
  void checkBoundaries(){
    if (x>width-radius){
      x = width-radius;
      speedX *= -1;
 
    }
    if (x<radius){
      x = radius;
      speedX *= -1;
    }
    if (y>height-radius){
      y = height-radius;
      speedY *= -1;
    }
    if (y<radius){
      y = radius;
      speedY *= -1;
    }
  }
}


class Bot extends RoundSprite{
 
  Bot(float x, float y, float radius, 
         float speedX, float speedY){
    super(x, y, radius, speedX, speedY);
  }
 
  void create(){
    ellipse(x, y, radius*2, radius*2);
  }
}

class RoboMouse extends RoundSprite{
 
  Robot robot;
  float localX, localY;
 
  RoboMouse(float x, float y, float radius, 
               float speedX, float speedY){
    super(x, y, radius, speedX, speedY);
    localX = frame.getLocation().x/2;
    localY = frame.getLocation().y/2;
    try { 
      robot = new Robot();
    } 
    catch (AWTException e) {
      e.printStackTrace(); 
    }
  }
 
  void checkBoundaries(){
    if (x>width-radius+localX){
      x = width-radius+localX;
      speedX *= -1;
    }
    if (x<radius+localX){
      x = radius+localX;
      speedX *= -1;
    }
    if (y>height-radius+localY){
      y = height-radius+localY;
      speedY *= -1;
    }
    if (y<radius+localY){
      y = radius+localY;
      speedY *= -1;
    }
  }
 
  void move(){
    x += speedX;
    y += speedY;
    robot.mouseMove(frame.getLocation().x/2+(int)x, 
                    frame.getLocation().y/2+(int)y);
  }
}
