// Daniel Shiffman
// http://codingrainbow.com
// http://patreon.com/codingrainbow
// Code for: https://youtu.be/QLHMtE5XsMs
import ipcapture.*;

IPCapture video;
PImage prev;

float threshold = 25;

float motionX = 0;
float motionY = 0;

float lerpX = 0;
float lerpY = 0;


void setup() {
  size(480, 320);
  video = new IPCapture(this, "http://192.168.1.7:8080/video", "", "");
  video.start();
  prev = createImage(480, 320, RGB);
}

void mousePressed() {
}

void draw() {
  if (video.isAvailable()) {
    prev.copy(video, 0, 0, video.width, video.height, 0, 0, prev.width, prev.height);
    prev.updatePixels();
    video.read();
  }
  video.loadPixels();
  prev.loadPixels();
  image(video, 0, 0);
  threshold = 50;
  int count = 0;
  float avgX = 0;
  float avgY = 0;
  loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d > threshold*threshold) { //highlight moving pixels
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgX += x;
        avgY += y;
        count++;
        pixels[loc] = color(255);
      } else {
        // pixels[loc] = color(0); // draw non moving pixels black
      }
    }
  }
  updatePixels();

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 50) { 
    motionX = avgX / count;
    motionY = avgY / count;
  }

  lerpX = lerp(lerpX, motionX, 0.1); 
  lerpY = lerp(lerpY, motionY, 0.1); 

  fill(255, 0, 255);
  noFill();
  strokeWeight(2.0);
  stroke(255, 0, 255);
  ellipse(lerpX, lerpY, 16, 16);
  
  int moveX = int(lerpX)-width/2;
  int moveY = int(-lerpY)+height/2;
  text(moveX + ", " + moveY, 10, 20);

  image(video, 0, 0, 120, 80); // show video image pip
  //image(prev, 120, 0, 120, 80); // show previous video image pip
  //println(mouseX, threshold);
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}