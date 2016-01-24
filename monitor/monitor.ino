int analogPin = 5;     // mic connected to analog pin 5
                       // outside leads to ground and +5V
int val = 0;           // variable to store the mic read
int ledPin = 13;

#include <SoftwareSerial.h>

const int IMP_SERIAL_RX = 8;
const int IMP_SERIAL_TX = 9;

SoftwareSerial impSerial(IMP_SERIAL_RX, IMP_SERIAL_TX);

void setup() {
  pinMode(ledPin, OUTPUT); // set the LED pin as out

   // Open the hardware serial port
  Serial.begin(19200);

  // Set the data rate for the SoftwareSerial port
  impSerial.begin(19200);
}

void loop() {
  val = analogRead(analogPin);
  if (val > 1000) {
    digitalWrite(ledPin, HIGH);

    // Truncate the value that's sent
    int sent = impSerial.write(val / 10);
    delay(500); // wait 0.5s
  } else {
    digitalWrite(ledPin, LOW);
  }
}
