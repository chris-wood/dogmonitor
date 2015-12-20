int analogPin = 5;     // mic connected to analog pin 0
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
//  Serial.println(val);
  if (val > 800) {
    digitalWrite(ledPin, HIGH);
    
    Serial.print("Sent: ");
    int sent = impSerial.write(val / 10);  // to the software serial, truncating 
    Serial.println(sent);
    delay(1000);
  } else {
    digitalWrite(ledPin, LOW);
  }

  // Send data from the software serial
//  if (impSerial.available())
//    Serial.write(impSerial.read());  // to the hardware serial
  // Send data from the hardware serial
//  if (Serial.available())
  
}



