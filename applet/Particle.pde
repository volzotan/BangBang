class Particle {
  Vec2D v,vD;
  float dir,dirMod,speed;
  int col,age,stateCnt,type;
  
  Particle() {
    v=new Vec2D(0,0);
    vD=new Vec2D(0,0);
    age=0;
  }

  void init(float _dir) {
    dir=_dir;

    float prob=random(100);
    if(prob<80) age=15+int(random(30));
    else if(prob<99) age=45+int(random(50));
    else age=100+int(random(100));
    
    if(random(100)<80) speed=random(2)+0.5;
    else speed=random(2)+2;

    if(random(100)<80) dirMod=20;
    else dirMod=60;
    
    v.set(mouseX+copyOffsetX,mouseY+copyOffsetY);
    initMove();
    dir=_dir;
    stateCnt=10;
    if(random(100)>50) col=0;
    else col=1;
    
        type=(int)random(30000)%2;

  }
    
  void initMove() {
    if(random(100)>50) dirMod=-dirMod;
    dir+=dirMod;
    
    vD.set(speed,0);
    vD.rotate(radians(dir+90));

    stateCnt=10+int(random(5));
    if(random(100)>90) stateCnt+=30;
  }
  
  void update() {
    age--;
    
    if(age>=30) {
      vD.rotate(radians(1));
      vD.mult(1.01f);
    }
    
    v.add(vD);
    if(col==0) buf.fill(255-age,0,100,150);
    else buf.fill(100,200-(age/2),255-age,150);
    
    if(type==1) {
      if(col==0) buf.fill(255-age,100,0,150);
      else buf.fill(255,200-(age/2),0,150);
    }
      
    pushMatrix();
    translate(v.x,v.y);
    rotate(radians(dir));
    buf.rect(copyOffsetX,+copyOffsetX,1,16);
    popMatrix();
    
    if(age==0) {
      if(random(100)>50) buf.fill(200,0,0,200);
      else buf.fill(00,200,255,200);
      float size=2+random(4);
      if(random(100)>95) size+=5;
      buf.ellipse(v.x+copyOffsetX,v.y+copyOffsetY,size,size);
    }
    if(v.x<0 || v.x>(width+copyOffsetX) || v.y<0 || v.y>(height+copyOffsetY)) age=0;
    
    if(age<30) {
      stateCnt--;
      if(stateCnt==0) {
        initMove();
      }
    }
   } 
  
}
