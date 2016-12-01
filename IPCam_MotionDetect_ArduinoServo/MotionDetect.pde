void motionDetect()
{
  if (Moving == false) {
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
  int movemX = int(lerpX);
  int movemY = int(lerpY);
  text(movemX + ", " + movemY, 10, 20);
  fill(0);
  text("Count" + count, width/2, 20);
}
}

void servoControl()
{
  int moveX = int(lerpX);
  int moveY = int(lerpY);
    println(moveX);
    if (moveX > width/2 - 25 && moveX < width/2 + 25) {
      return;
    }
    if (moveX < width/2) {
      Moving = true;
      arduino.write("a");
      arduino.write("\n");
    }
    if (moveX > width/2) {
      Moving = true;
      arduino.write("s");
      arduino.write("\n");
    }
}