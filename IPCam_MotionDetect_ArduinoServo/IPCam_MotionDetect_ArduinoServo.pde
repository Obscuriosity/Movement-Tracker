// Daniel Shiffman
// http://codingrainbow.com
// http://patreon.com/codingrainbow
// Code for: https://youtu.be/QLHMtE5XsMs
import ipcapture.*;
import processing.serial.*;

Serial arduino;
IPCapture video;
PImage prev;

float threshold = 25;

float motionX = 0;
float motionY = 0;

float lerpX = 0;
float lerpY = 0;

int panServo;
int tiltServo;

boolean Moving;

void setup() {
  size(480, 320);
  video = new IPCapture(this, "http://192.168.1.7:8080/video", "", "");
  video.start();
  prev = createImage(480, 320, RGB);
  
  println(Serial.list());
  arduino = new Serial(this, Serial.list()[0], 9600);
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
  motionDetect();
  servoControl();
  //image(video, 0, 0, 120, 80); // show video image pip
  //image(prev, 120, 0, 120, 80); // show previous video image pip
  //println(mouseX, threshold);
}

void serialEvent(Serial arduino) {
  String arduinoData = arduino.readStringUntil('\n');
  println("servo - " + arduinoData);
  //arduinoData = trim(arduinoData);
  //int data[] = int(split(arduinoData, ','));
  //if (data.length > 1) {
  // panServo = data[0];
   //tiltServo = data[1];
  //}
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}