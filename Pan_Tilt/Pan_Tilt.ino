#include <Servo.h> 

Servo tilt;
Servo pan;
int inbyte = 0;
byte newPanAngle, newTiltAngle = 100;
int tiltAngle = 100;
int panAngle = 90;
int turn;

void setup() {

  Serial.begin(9600);
  pan.attach(5);
  tilt.attach(9);
  pan.write(panAngle);
  tilt.write(tiltAngle);
}

void loop() 
{
  delay(80);
  if (Serial.available() > 0) {
    inbyte = Serial.read();
    switch (inbyte) {
    case 'a':
      panAngle += 1;
      pan.write(panAngle);
      tilt.write(tiltAngle);
      Serial.println(panAngle);
      break;

    case 's':
      panAngle -= 1;
      pan.write(panAngle);
      tilt.write(tiltAngle);
      Serial.println(panAngle);
      break;
    }
  }
}







