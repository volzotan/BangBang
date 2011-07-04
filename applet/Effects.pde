void AbstractJs() {
  float dir = int(random(36))*10;
  Particle particle = new Particle();
  particle.init(dir); 
  particle.update();
}
