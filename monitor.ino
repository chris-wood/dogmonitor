int analogPin = 0;     // mic connected to analog pin 0
                       // outside leads to ground and +5V
int val = 0;           // variable to store the mic read
int ledPin = 13;


void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT); // set the LED pin as out
}

void loop() {
  val = analogRead(analogPin);
  Serial.println(val);

  if (val > 600) {
    digitalWrite(ledPin, HIGH);
    delay(1000);
  } else {
    digitalWrite(ledPin, LOW);
  }
}

