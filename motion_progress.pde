// Motion Project
// By: Winslow Church

import com.hamoid.*;
VideoExport videoExport;

Dot[] dots;
int rl = int(random(10,150));
int rh = int(random(rl+30, 200));
int bl = int(random(10,200));
int bh = int(random(bl+30, 255));
//float colortype = int(random(3));
boolean isBlurred = true;
boolean isFaded = false;
boolean dotsSet = false;


void setup() {
  size(1000, 700);
  surface.setTitle("Northern Lightning");
  background(random(0,80), 5, random(0,80));
  // put initial dots on page
  setDots(10000);
  
  videoExport = new VideoExport(this);
  videoExport.setQuality(80, 128);
  videoExport.startMovie();
}

void setDots(int dcount) {
  dots = new Dot[dcount];
  float colortype = int(random(3));
  for (int i = 0; i < dcount; i++) { 
    float ix = random(width);
    float iy = random(height);
    
    // make the color non-uniform throughout the screen
    float curr = map(ix, 0, height, 255, 0); // differ color by x value
    int ic = color(random(rl, rh), curr, random(bl, bh));
    if (colortype == 1) {
      curr = map(iy, 0, height, 255, 0); // differ color by y value
      ic = color(random(bl, bh), random(rl, rh), curr);
    } else if (colortype == 2) { // differ color randomly
      ic = color(random(rl, rh), random(255), random(bl, bh));
    }
    
    dots[i]= new Dot(ix, iy, ic);
  }
}
  
float alpha;
float rtime = 0;
void draw() {
  frameRate(50);
  
  // fades old pixels
  if (isFaded) {
    fill(0, 4);
    rect(0, 0, width, height);
  }
  
  if (isBlurred) filter(BLUR, 2);
  loadPixels();
  for (Dot d: dots) d.next_spot();
  updatePixels();
  
  /*rtime = second();
  if (rtime % 2 == 0) {
    if (!dotsSet) setDots(5000);
    dotsSet = true;
  } else {
    dotsSet = false;   
  }*/
  videoExport.saveFrame();
}

// using a class (wow am i cool)
float curr;
class Dot {
  float px, py, iadd, dcurr;
  color  c;
  
  Dot(float dx, float dy, color dc) {
    px = dx;
    py = dy;
    c = dc;
  }

  void next_spot() {
    iadd += .001;
    dcurr = noise(px * .005, py * .005, iadd) * TWO_PI;
    px += -5 * cos(dcurr);
    py += -5 * sin(dcurr);
    
    // wrap around to right side of screen
    if (px < 0) px = width;
    else if (px > width) px = 0;
    if (py < 0) py = height;
    else if (py > height) py = 0;
    
    if (px > 0 && px < width && py > 0  && py < height) {
      pixels[(int)px + (int)py * width] = c;
    }
  }
}

void mouseClicked() {
  setDots(10000);
}

void keyPressed() {
  // space changes blur
  if (key == ' ') {
    isBlurred = !isBlurred;
  // s saves current frame
  } else if (key == 's') {
    save("untitled.tif");
  } else if (key == 'f') {
    isFaded = !isFaded;
  } else if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}
